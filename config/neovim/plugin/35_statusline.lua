local space = "%="

local hl = function(group)
	return vim.api.nvim_get_hl(0, {
		name = group,
		link = false,
		create = false,
	})
end

local set_hl_groups = function()
	for group, opts in pairs({
		ModeNormal = { link = "MiniStatuslineModeNormal" },
		ModeInsert = { link = "MiniStatuslineModeInsert" },
		ModeVisual = { link = "MiniStatuslineModeVisual" },
		ModeCommand = { link = "MiniStatuslineModeCommand" },
		ModeReplace = { link = "MiniStatuslineModeReplace" },
		ModePending = { link = "MiniStatuslineModeOther" },
		DiffAdded = { link = "Added" },
		DiffChanged = { link = "Changed" },
		DiffRemoved = { link = "Removed" },
    FileDir = { fg = hl("Directory").fg, bg = "NONE" },
    FileName = { fg = hl("Title").fg, bg = "NONE", bold = true },
    FileReadOnly = { fg = hl("ErrorMsg").fg, bg = "NONE" },
		LSP = { fg = hl("SpecialKey").fg, bg = "NONE" },
		Fmt = { fg = hl("SpecialKey").fg, bg = "NONE" },
		Position = { fg = hl("SpecialKey").fg, bg = "NONE", bold = true },
		Recording = { fg = hl("Question").fg, bg = "NONE" },
		MiniIconsAzure = { fg = hl("MiniIconsAzure").fg, bg = "NONE" },
		MiniIconsBlue = { fg = hl("MiniIconsBlue").fg, bg = "NONE" },
		MiniIconsCyan = { fg = hl("MiniIconsCyan").fg, bg = "NONE" },
		MiniIconsGreen = { fg = hl("MiniIconsGreen").fg, bg = "NONE" },
		MiniIconsGrey = { fg = hl("MiniIconsGrey").fg, bg = "NONE" },
		MiniIconsOrange = { fg = hl("MiniIconsOrange").fg, bg = "NONE" },
		MiniIconsPurple = { fg = hl("MiniIconsPurple").fg, bg = "NONE" },
		MiniIconsRed = { fg = hl("MiniIconsRed").fg, bg = "NONE" },
		MiniIconsYellow = { fg = hl("MiniIconsYellow").fg, bg = "NONE" },
	}) do
		group = "St" .. group
		vim.api.nvim_set_hl(0, group, opts)
		opts.fg, opts.bg = opts.bg, opts.fg
		vim.api.nvim_set_hl(0, group .. "Inverted", opts)
	end

	vim.api.nvim_set_hl(0, "StBase", { bg = "NONE" })
end

Config.new_autocmd("ColorScheme", nil, set_hl_groups, "Re-apply statusline highlights on colorscheme change")

local mode_component = function()
	local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
	local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
	local mode_settings = {
		["n"] = { name = "n", hl = "Normal" },
		["v"] = { name = "v", hl = "Visual" },
		["V"] = { name = "v", hl = "Visual" },
		[CTRL_V] = { name = "v", hl = "Visual" },
		["s"] = { name = "s", hl = "Visual" },
		["S"] = { name = "s", hl = "Visual" },
		[CTRL_S] = { name = "s", hl = "Visual" },
		["i"] = { name = "i", hl = "Insert" },
		["R"] = { name = "r", hl = "Replace" },
		["r"] = { name = "r", hl = "Replace" },
		["c"] = { name = "c", hl = "Command" },
		["!"] = { name = "sh", hl = "Command" },
		["t"] = { name = "t", hl = "Command" },
	}

	local mode = mode_settings[vim.fn.mode()] or {}

	return table.concat({
		"%#StMode" .. mode.hl .. "Inverted#",
		"%#StMode" .. mode.hl .. "# " .. mode.name,
		" %#StMode" .. mode.hl .. "Inverted#",
		"%#StBase# ",
	})
end

local file_name_component = function()
	local path = vim.fn.expand("%f")
	if path == "" then
		return ""
	end

	local filename = ""
	local dir = ""

	local parts = vim.split(path, "/", { plain = true })
	if #parts == 1 then
		filename = parts[1]
	else
		filename = parts[#parts]
		dir = parts[#parts - 1]
	end

	if vim.bo.buftype == "terminal" then
		return "%t"
	end

	local icon, icon_hl = require("mini.icons").get("extension", filename)

	return table.concat({
		"%#StBase#",
		"%#StFileDir# " .. dir .. "/",
		"%#StFileName#" .. filename,
		"%#St" .. icon_hl .. "# " .. icon .. " ",
		vim.bo.readonly and "%#StFileReadOnly#  " or "",
	})
end

local diff_component = function()
	local summary = vim.b.minidiff_summary
	if summary == nil then
		return ""
	end

	local added, changed, removed = summary.add or 0, summary.change or 0, summary.delete or 0

	return table.concat({
		"%#StDiffAdded# " .. (added > 0 and "+" .. added or "") .. " ",
		"%#StDiffChanged#" .. (changed > 0 and "~" .. changed or "") .. " ",
		"%#StDiffRemoved#" .. (removed > 0 and "-" .. removed or "") .. " ",
		"%#StBase#",
	})
end

local fmt_component = function()
	local is_loaded, conform = pcall(require, "conform")
	if not is_loaded then
		return ""
	end

	local formatters = conform.list_formatters_for_buffer(vim.api.nvim_get_current_buf())

	local fmt_name = formatters[1] or ""
	if fmt_name == "" then
		return ""
	end

	return table.concat({
		"%#StFmt#",
		string.format("%s ", fmt_name),
	})
end

local lsp_component = function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return ""
	end

	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end

	return table.concat({
		"%#StLSP# ",
		string.format("%s ", table.concat(client_names, ",")),
		fmt_component() == "" and "" or "| ",
	})
end

local diagnostic_status = function()
	return table.concat({
		" ",
		vim.diagnostic.status(),
		"%#StBase#",
	})
end

local function position_component()
	return table.concat({
		"%#StPosition#",
		"[%P %l:%c]",
	})
end

local blink_icon = true
local blink_timer = nil
local function macro_component()
	local is_rec = vim.fn.reg_recording()
	if is_rec == "" then
		if blink_timer then
			blink_timer:stop()
			blink_timer:close()
			blink_timer = nil
		end
		return ""
	end
	if not blink_timer then
		blink_timer = vim.uv.new_timer()
		if blink_timer ~= nil then
			blink_timer:start(
				0,
				500,
				vim.schedule_wrap(function()
					blink_icon = not blink_icon
					vim.cmd("redrawstatus")
				end)
			)
		end
	end
	local icon = blink_icon and "" or " "
	return "%#StRecording#" .. icon .. "%#StBase#" .. " @" .. is_rec
end

function _G.Statusline_active()
	return table.concat({
		"%#StBase# ",
		mode_component(),
		file_name_component(),
		diff_component(),
		space,
		macro_component(),
		space,
		"%S",
		diagnostic_status(),
		lsp_component(),
		fmt_component(),
		position_component(),
	})
end

function _G.Statusline_inactive()
	return table.concat({
		"%#StBase#",
		file_name_component(),
		space,
	})
end
