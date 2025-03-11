-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- : pastel theme plugin
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					flavour = "mocha", -- latte, frappe, macchiato, mocha
					--background = { -- :h background
					--  light = "latte",
					--  dark = "mocha",
					--},
					transparent_background = true, -- disables setting the background color.
					show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
					term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
					dim_inactive = {
						enabled = false, -- dims the background color of inactive window
						shade = "dark",
						percentage = 0.1, -- percentage of the shade to apply to the inactive window
					},
					no_italic = false, -- Force no italic
					no_bold = false, -- Force no bold
					no_underline = false, -- Force no underline
					styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
						comments = { "italic" }, -- Change the style of comments
						conditionals = { "italic" },
						loops = {},
						functions = {},
						keywords = {},
						strings = {},
						variables = {},
						numbers = {},
						booleans = {},
						properties = {},
						types = {},
						operators = {},
						-- miscs = {}, -- Uncomment to turn off hard-coded styles
					},
					color_overrides = {},
					custom_highlights = {},
					default_integrations = true,
					integrations = {
						cmp = true,
						gitsigns = true,
						nvimtree = true,
						treesitter = true,
						notify = false,
						mini = {
							enabled = true,
							indentscope_color = "",
						},
						-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
					},
				})
				-- setup must be called before loading
				vim.cmd.colorscheme("catppuccin")
			end,
		},

		-- telescope
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		-- File tree
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			requires = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({})
			end,
		},

		-- Vimtex
		{
			"lervag/vimtex",
			lazy = false,
			init = function()
				vim.g.vimtex_view_method = "zathura"
				vim.vimtex_compiler_method = "latexmk"
				vim.opt.conceallevel = 1
				vim.g.tex_conceal = "abdmg"
			end,
		},

		-- R.nvim
		{
			"R-nvim/R.nvim",
			-- Only required if you also set defaults.lazy = true
			lazy = false,
			-- R.nvim is still young and we may make some breaking changes from time
			-- to time. For now we recommend pinning to the latest minor version
			-- like so:
			version = "~0.1.0",
		},

		{
			"R-nvim/cmp-r",
			{
				"hrsh7th/nvim-cmp",
				config = function()
					require("cmp").setup({ sources = { { name = "cmp_r" } } })
					require("cmp_r").setup({})
				end,
			},
		},

		{
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "markdown", "markdown_inline", "r", "rnoweb", "yaml" },
					highlight = { enable = true },
				})
			end,
		},

		-- Visualize buffers as tabs
		{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

		-- Snippets
		-- {
		-- 	"SirVer/ultisnips",
		-- 	lazy = false,
		-- 	init = function()
		-- 		vim.g.UltiSnipsExpandTrigger = "<C-l>" -- Trigger for snippet expansion
		-- 		vim.g.UltiSnipsJumpForwardTrigger = "<Tab>" -- Trigger to jump forward through snippet placeholders
		-- 		vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>" -- Trigger to jump backward through snippet placeholders
		-- 		vim.g.UltiSnipsSnippetDirectories = { "~/.config/nvim/UltiSnips/" }
		-- 		vim.g.python3_host_prog = "~/virtualenvs/nvim-venv/bin/python"
		-- 		return vim.fn.has("python3") == 1
		-- 	end,
		-- },

		-- OXY2DEV
		{
			"OXY2DEV/markview.nvim",
			lazy = false, -- Recommended
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
		},

		-- Live preview markdown files (depricated-look for replacement)
		-- {
		-- 	"iamcco/markdown-preview.nvim",
		-- 	version = false,
		-- 	-- pin = true,
		-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		-- 	ft = { "markdown" },
		-- 	build = function()
		-- 		vim.fn["mkdp#util#install"]()
		-- 	end,
		-- },

		-- Comments
		{
			"terrortylor/nvim-comment",
			config = function()
				require("nvim_comment").setup({ create_mappings = false })
			end,
		},

		-- Save and Load buffers (a session) automatically for each folder
		{
			"rmagatti/auto-session",
			config = function()
				require("auto-session").setup({
					log_level = "error",
					auto_session_suppress_dirs = { "~/", "~/Downloads" },
				})
			end,
		},

		-- Run multiple terminals
		{
			-- amongst your other plugins
			{ "akinsho/toggleterm.nvim", version = "*", config = true },
		},

		-- null-ls
		{
			"jay-babu/mason-null-ls.nvim",
			event = { "BufReadPre", "BufNewFile" },
			dependencies = {
				"williamboman/mason.nvim",
				"nvimtools/none-ls.nvim",
				"nvim-lua/plenary.nvim",
				-- "quangnguyen30192/cmp-nvim-ultisnips",
			},
			config = function()
				local null_ls = require("null-ls")

				-- Setup null-ls with Black for Python and stylua for Lua
				null_ls.setup({
					sources = {
						-- Python formatting using Black
						null_ls.builtins.formatting.black.with({
							extra_args = { "--fast" },
						}),

						-- Lua formatting using stylua
						null_ls.builtins.formatting.stylua,

						-- Tex formatting using latexindent
						null_ls.builtins.formatting.latexindent,
					},
					on_attach = function(client, bufnr)
						if client.server_capabilities.documentFormattingProvider then
							-- Manual formatting keybinding
							vim.api.nvim_buf_set_keymap(
								bufnr,
								"n",
								"<leader>f",
								"<cmd>lua vim.lsp.buf.format()<CR>",
								{ noremap = true, silent = true }
							)
						end
					end,
				})
			end,
		},

		-- LSP Zero
		{
			{
				"VonHeikemen/lsp-zero.nvim",
				branch = "v4.x",
				lazy = true,
				config = false,
			},

			{
				"williamboman/mason.nvim",
				lazy = false,
				config = true,
			},

			{
				"hrsh7th/nvim-cmp",
				event = "InsertEnter",
				config = function()
					local cmp = require("cmp")
					local cmp_action = require("lsp-zero").cmp_action()

					cmp.setup({
						sources = {
							{ name = "nvim_lsp" },
							-- { name = "ultisnips" },
							{ name = "buffer" },
							{ name = "path" },
						},
						mapping = cmp.mapping.preset.insert({
							["<C-Space>"] = cmp.mapping.complete(),
							["<C-u>"] = cmp.mapping.scroll_docs(-4),
							["<C-d>"] = cmp.mapping.scroll_docs(4),
							["<C-f>"] = cmp_action.vim_snippet_jump_forward(),
							["<C-b>"] = cmp_action.vim_snippet_jump_backward(),
							["<C-Tab>"] = cmp.mapping.select_next_item(),
						}),
						snippet = {
							expand = function(args)
								vim.snippet.expand(args.body)
								-- vim.fn["UltiSnips#Anon"](args.body)
							end,
						},
					})
				end,
			},

			{
				"neovim/nvim-lspconfig",
				cmd = { "LspInfo", "LspInstall", "LspStart" },
				event = { "BufReadPre", "BufNewFile" },
				dependencies = {
					{ "hrsh7th/cmp-nvim-lsp" },
					{ "williamboman/mason.nvim" },
					{ "williamboman/mason-lspconfig.nvim" },
				},
				config = function()
					local lsp_zero = require("lsp-zero")

					-- lsp_attach is where you enable features that only work
					-- if there is a language server active in the file
					local lsp_attach = function(client, bufnr)
						local opts = { buffer = bufnr }

						vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
						vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
						vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
						vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
						vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
						vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
						vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
						vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
						vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
						vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					end

					lsp_zero.extend_lspconfig({
						sign_text = true,
						lsp_attach = lsp_attach,
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					})

					require("mason-lspconfig").setup({
						ensure_installed = { "pyright" },
						handlers = {
							-- this first function is the "default handler"
							-- it applies to every language server without a "custom handler"
							function(server_name)
								require("lspconfig")[server_name].setup({})
							end,

							-- this is the "custom handler" for `lua_ls`
							lua_ls = function()
								-- (Optional) Configure lua language server for neovim
								require("lspconfig").lua_ls.setup({
									on_init = function(client)
										lsp_zero.nvim_lua_settings(client, {})
									end,
								})
							end,
						},
					})

					-- Python environment
					local util = require("lspconfig/util")
					local path = util.path
					require("lspconfig").pyright.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						before_init = function(_, config)
							default_venv_path = path.join(vim.env.HOME, "virtualenvs", "nvim-venv", "bin", "python")
							config.settings.python.pythonPath = default_venv_path
						end,
					})
				end,
			},
		},
	},

	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
