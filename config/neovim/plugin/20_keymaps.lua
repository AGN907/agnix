-- General mappings

-- A helper to create a Normal mode mapping
local nmap = function(lhs, rhs, desc)
	-- See `:h vim.keymap.set()`
	vim.keymap.set("n", lhs, rhs, { desc = desc })
end

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
nmap("[p", '<Cmd>exe "iput! " . v:register<CR>', "Paste Above")
nmap("]p", '<Cmd>exe "iput "  . v:register<CR>', "Paste Below")

-- Clear highlights on search when pressing <Esc> in normal mode
nmap("<Esc>", "<cmd>nohlsearch<CR>")

_G.Config.leader_group_spec = {
	{ mode = "n", keys = "<leader>b", desc = "+Buffer" },
	{ mode = "n", keys = "<leader>e", desc = "+Explore/Edit" },
	{ mode = { "n", "x" }, keys = "<leader>g", desc = "+Git" },
	{ mode = { "n", "x" }, keys = "<leader>l", desc = "+Language" },
	{ mode = "n", keys = "<leader>s", desc = "+Session" },
	{ mode = "n", keys = "<leader>f", desc = "+Find" },
	{ mode = "n", keys = "<leader>t", desc = "+Test" },
	{ mode = "n", keys = "<leader>o", desc = "+Other" },
	{ mode = "n", keys = "<leader>q", desc = "+Quickfix" },
	{ mode = "n", keys = "<leader>z", desc = "+Zk" },
}

-- Helpers for a more concise `<Leader>` mappings.
local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc })
end

local new_scratch_buffer = function()
	vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

nmap_leader("ba", "<Cmd>b#<CR>", "Alternate")
nmap_leader("bs", new_scratch_buffer, "Scratch")
nmap_leader("br", "<Cmd>lua Snacks.rename.rename_file()<CR>", "Rename current file")

local explore_at_file = "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>"
local explore_quickfix = function()
	vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end
local explore_locations = function()
	vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen")
end

nmap_leader("ed", "<Cmd>lua MiniFiles.open()<CR>", "Directory")
nmap_leader("ef", explore_at_file, "File directory")
nmap_leader("en", "<Cmd>lua MiniNotify.show_history()<CR>", "Notifications")
nmap_leader("eq", explore_quickfix, "Quickfix list")
nmap_leader("eQ", explore_locations, "Location list")

nmap_leader("f/", "<Cmd>FzfLua search_history<CR>", '"/" history')
nmap_leader("f:", "<Cmd>FzfLua command_history<CR>", '":" history')
nmap_leader("fb", "<Cmd>FzfLua buffers<CR>", "Buffers")
nmap_leader("fc", "<Cmd>FzfLua git_commits<CR>", "Commits (all)")
nmap_leader("fC", "<Cmd>FzfLua git_bcommits<CR>", "Commits (buf)")
nmap_leader("fd", "<Cmd>FzfLua diagnostics_workspace<CR>", "Diagnostic workspace")
nmap_leader("fD", "<Cmd>FzfLua diagnostics_document<CR>", "Diagnostic buffer")
nmap_leader("ff", "<Cmd>FzfLua files<CR>", "Files")
nmap_leader("fg", "<Cmd>FzfLua live_grep<CR>", "Grep live")
nmap_leader("fG", "<Cmd>FzfLua grep_cword<CR>", "Grep current word")
nmap_leader("fh", "<Cmd>FzfLua helptags<CR>", "Help tags")
nmap_leader("fH", "<Cmd>FzfLua highlights<CR>", "Highlight groups")
nmap_leader("fl", "<Cmd>FzfLua lines<CR>", "Lines (all)")
nmap_leader("fL", "<Cmd>FzfLua blines<CR>", "Lines (buf)")
nmap_leader("fr", "<Cmd>FzfLua resume<CR>", "Resume")
nmap_leader("fR", "<Cmd>FzfLua lsp_references<CR>", "References (LSP)")
nmap_leader("fs", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>", "Symbols workspace (live)")
nmap_leader("fS", "<Cmd>FzfLua lsp_document_symbols<CR>", "Symbols document")
nmap_leader("fm", "<Cmd>FzfLua git_status<CR>", "Git status")

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. " --follow -- %"

nmap_leader("ga", "<Cmd>Git diff --cached<CR>", "Added diff")
nmap_leader("gA", "<Cmd>Git diff --cached -- %<CR>", "Added diff buffer")
nmap_leader("gc", "<Cmd>Git commit<CR>", "Commit")
nmap_leader("gC", "<Cmd>Git commit --amend<CR>", "Commit amend")
nmap_leader("gd", "<Cmd>Git diff<CR>", "Diff")
nmap_leader("gD", "<Cmd>Git diff -- %<CR>", "Diff buffer")
nmap_leader("gl", "<Cmd>" .. git_log_cmd .. "<CR>", "Log")
nmap_leader("gL", "<Cmd>" .. git_log_buf_cmd .. "<CR>", "Log buffer")
nmap_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")
nmap_leader("gg", "<Cmd>lua Snacks.lazygit()<CR>", "Open lazygit")

xmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection")

local formatting_cmd = '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>'

nmap_leader("la", "<Cmd>lua require('tiny-code-action').code_action()<CR>", "Actions")
nmap_leader("ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic popup")
nmap_leader("lf", formatting_cmd, "Format")
nmap_leader("li", "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation")
nmap_leader("lh", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover")
nmap_leader("lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
nmap_leader("lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "References")
nmap_leader("ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition")
nmap_leader("lt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition")

xmap_leader("la", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Actions")
xmap_leader("lf", formatting_cmd, "Format selection")

local session_new =
	'MiniSessions.write(MiniInput.get({prompt = "Session name", init_keys = { vim.fn.fnamemodify(vim.fn.getcwd(), ":t") }}))'

nmap_leader("sd", '<Cmd>lua MiniSessions.select("delete")<CR>', "Delete")
nmap_leader("sn", "<Cmd>lua " .. session_new .. "<CR>", "New")
nmap_leader("sr", '<Cmd>lua MiniSessions.read(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))<CR>', "Read")
nmap_leader("ss", '<Cmd>lua MiniSessions.select("read")<CR>', "Select")
nmap_leader("sR", "<Cmd>lua MiniSessions.restart()<CR>", "Restart")
nmap_leader("sw", "<Cmd>lua MiniSessions.write()<CR>", "Write current")
nmap_leader("sq", "<Cmd>quit<CR>", "Quit")

local input_cmd_terminal =
	"Snacks.input.input({}, function(cmd) if cmd ~= nil then Snacks.terminal(cmd) end return end)"
nmap_leader(".", "<Cmd>lua Snacks.terminal()<CR>", "Open terminal")
nmap_leader(",", "<Cmd>lua " .. input_cmd_terminal .. "<CR>", "Run command in terminal")

-- Quickfix
nmap_leader("qq", "<Cmd>lua require('quicker').toggle()<CR>", "Toggle quickfix")
nmap_leader("ql", "<Cmd>lua require('quicker').toggle({ loclist = true })<CR>", "Toggle loclist")

-- ZK
nmap_leader("zn", "<Cmd<ZkNew<CR>", "Create new note")
nmap_leader("zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "Find notes")
nmap_leader(
	"zf",
	"<Cmd<ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
	"Find notes with query"
)
nmap_leader("zt", "<Cmd>ZkTags<CR>", "Open notes associated with tags")
