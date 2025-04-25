vim.opt.encoding = "utf-8" -- set encoding
vim.opt.nu = true -- enables line numbers
vim.opt.relativenumber = true -- relative line numbers

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- converts tabs to spaces
vim.opt.autoindent = true -- auto-indentation
vim.opt.list = true -- show tab characters and trailing whitespaces

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 2 -- The space required between the text cursor and the
-- bottom of the viewable screen.
vim.opt.sidescrolloff = 4

vim.api.nvim_set_keymap("i", "<C-h>", "<C-w>", { noremap = true, silent = true })

-- auto-close loops
vim.keymap.set("i", '<A-S-">', '""<Left>')
vim.keymap.set("i", "<A-'>", "''<Left>")
vim.keymap.set("i", "(", "()<Left>")
vim.keymap.set("i", "[", "[]<Left>")
vim.keymap.set("i", "{", "{}<Left>")
vim.keymap.set("i", "{<CR>", "{<CR>}<Esc>O")
vim.keymap.set("i", "{;<CR>", "{<CR>};<Esc>O")

-- Create autocommand to set up the keybinding only in LaTeX (.tex) files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex", -- Only trigger for .tex files
	callback = function()
		-- Enable spell checking for the current buffer
		vim.opt_local.spell = true
		-- Set the spell languages to Dutch (nl) and British English (en_gb)
		vim.opt.spelllang = { "en_gb" }
		-- Map <C-l> in insert mode to correct the previous misspelled word
		vim.api.nvim_set_keymap("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { noremap = true, silent = true })
	end,
})

-- Extend Tab escape for all types of brackets
vim.keymap.set("i", "<Tab>", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.fn.col(".")
	local next_char = line:sub(col, col)
	if next_char == "}" or next_char == ")" or next_char == "]" then
		return "<Right>"
	else
		return "<Tab>"
	end
end, { expr = true, noremap = true, silent = true })

-- Wrap selected text in parentheses ()
vim.keymap.set("v", "(", 'c(<C-r>"<Right>)<Esc>')
-- Wrap selected text in square brackets []
vim.keymap.set("v", "[", 'c[<C-r>"<Right>]<Esc>')
-- Wrap selected text in curly braces {}
vim.keymap.set("v", "{", 'c{<C-r>"<Right>}<Esc>')
-- Wrap selected text in double quotes ""
vim.keymap.set("v", '"', 'c"<C-r>"<Right>"<Esc>')
-- Wrap selected text in single quotes ''
vim.keymap.set("v", "'", "c'<C-r>\"<Right>'<Esc>")

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.py",
	callback = function()
		vim.opt.textwidth = 79
		vim.opt.colorcolumn = "79"
	end,
}) -- python formatting

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.js", "*.html", "*.css", "*.lua" },
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.softtabstop = 2
		vim.opt.shiftwidth = 2
	end,
}) -- javascript formatting

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
}) -- return to last edit position when opening files
