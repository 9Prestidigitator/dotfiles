vim.cmd("colorscheme catppuccin-macchiato") -- set color theme

vim.opt.termguicolors = true --bufferline
require("bufferline").setup{} --bufferline

-- Sets colors to line numbers Above, Current and Below  in this order
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#51B3EC', bold=true })
vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#FB508F', bold=true })

