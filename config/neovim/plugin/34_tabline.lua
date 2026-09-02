local hl = function(group)
	return vim.api.nvim_get_hl(0, {
		name = group,
		link = false,
		create = false,
	})
end

local set_hl_groups = function()
	for group, opts in pairs({
		Background = { bg = "NONE" },
		Visible = { fg = hl("LineNr").fg, bg = "NONE" },
		Current = { fg = hl("Title").fg, bg = hl("CursorColumn").bg, bold = true },
		VisibleModified = { fg = hl("WarningMsg").fg, bg = "NONE" },
		CurrentModified = { fg = hl("WarningMsg").fg, bg = hl("CursorColumn").bg },
	}) do
		group = "TabLine" .. group
		vim.api.nvim_set_hl(0, group, opts)
	end
end

Config.new_autocmd("ColorScheme", nil, set_hl_groups, "Re-apply tabline highlights")

local hl_cache = {}
local function get_icon_hl(mini_hl, is_current)
	if not mini_hl then
		return is_current and "TabLineCurrent" or "TabLineVisible"
	end

	local state = is_current and "Current" or "Visible"
	local custom_hl = "TabLineIcon_" .. mini_hl .. "_" .. state

	-- Return cached highlight if it already exists
	if hl_cache[custom_hl] then
		return custom_hl
	end

	-- Resolve the foreground color from mini.icons
	local hl_def = vim.api.nvim_get_hl(0, { name = mini_hl, link = false })

	-- Create a new highlight group blending the icon fg with the tab bg
	vim.api.nvim_set_hl(0, custom_hl, {
		fg = hl_def.fg,
		bg = is_current and hl("CursorColumn").bg or "NONE",
	})

	hl_cache[custom_hl] = true
	return custom_hl
end

function _G.Tabline()
	local tabline = ""
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buf = vim.api.nvim_get_current_buf()

	local has_mini, mini_icons = pcall(require, "mini.icons")

	for _, buf in ipairs(bufs) do
		local is_current = (buf.bufnr == current_buf)
		local is_modified = buf.changed == 1

		local name = buf.name == "" and "[No name]" or vim.fn.fnamemodify(buf.name, ":t")

		local icon, mini_hl = "󰈔", nil

		if has_mini then
			icon, mini_hl = mini_icons.get("file", name)
		end

		local hl_base = is_current and "%#TabLineCurrent#" or "%#TabLineVisible#"
		local hl_icon = "%#" .. get_icon_hl(mini_hl, is_current) .. "#"
		local hl_modified = is_current and "%#TablineCurrentModified#" or "%#TabLineVisibleModified#"

		local modified_symbol = is_modified and (hl_modified .. "  ") or "  "

		tabline = tabline .. hl_base .. " " .. hl_icon .. icon .. hl_base .. " " .. name .. modified_symbol
	end

	tabline = tabline .. "%#TablineBackground#%="
	return tabline
end
