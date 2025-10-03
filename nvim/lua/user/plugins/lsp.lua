return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- provide the SchemaStore catalog for use with jsonls and yamlls
		"b0o/schemastore.nvim",
	},
	event = "BufReadPre",
	-- Keymaps
	vim.keymap.set("n", "<Leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>"),
	vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>"),
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>"),
	-- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
	-- vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
	-- vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>"),
	-- vim.keymap.set('n', '<Leader>lr', ':LspRestart<CR>', { silent = true })
	-- vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
	--
	config = function()
		require("mason").setup()

		-- require("mason-lspconfig").setup({
		-- 	automatic_installation = true,
		-- })

		-- nvim-cmp add extra capabilities to nvim.lsp default capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local function root_dir_from_markers(markers)
			return function(bufnr, on_dir)
				local root = vim.fs.root(bufnr, markers) or vim.uv.cwd() or vim.fn.getcwd()
				on_dir(root)
			end
		end

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						library = {
							vim.env.VIMRUNTIME .. "/lua",
							"${3rd}/luv/library",
						},
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},
						-- Ignore .luacheckrc file to avoid lowercase-global warnings
						ignoreDir = { "luacheckrc" },
					},
					diagnostics = {
						globals = { "vim" },
						-- Disable lowercase global warnings for config files
						disable = { "lowercase-global" },
					},
				},
			},

			root_dir = root_dir_from_markers({ ".luarc.json", ".luarc.jsonc", ".git" }),
		})

		-- community fork of pyls
		vim.lsp.config("pylsp", {
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							ignore = { "W391" },
							maxLineLength = 100,
						},
					},
				},
			},
		})

		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schema = require("schemastore").json.schemas({
						-- select = {
						-- 	".eslintrc",
						-- 	"package.json",
						-- },
						-- ignore = {
						-- 	".eslintrc",
						-- 	"package.json",
						-- },
					}),
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("ruby_lsp", {
			filetypes = { "ruby", "eruby" },
		})

		vim.lsp.config("emmet_language_server", {
			filetypes = { "eruby", "html" },
		})

		vim.lsp.enable({
			"lua_ls",
			"pylsp",
			"jsonls",
			"ruby_lsp",
			"emmet_language_server",
		})

		-- vim.lsp.config("yamlls", {
		-- 	settings = {
		-- 		yaml = {
		-- 			schemaStore = {
		-- 				-- You must disable built-in schemaStore support if you want to use
		-- 				-- this plugin and its advanced options like `ignore`.
		-- 				enable = false,
		-- 				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
		-- 				url = "",
		-- 			},
		-- 			schemas = require("schemastore").yaml.schemas(),
		-- 		},
		-- 	},
		-- })
	end,
}
