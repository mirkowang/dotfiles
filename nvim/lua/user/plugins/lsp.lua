return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- provide the SchemaStore catalog for use with jsonls and yamlls
		"b0o/schemastore.nvim",
	},
	event = "BufReadPre",
	keys = {},
	-- -- Keymaps
	-- vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
	vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>"),
	-- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
	-- vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
	vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>"),
	-- vim.keymap.set('n', '<Leader>lr', ':LspRestart<CR>', { silent = true })
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>"),
	-- vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_installation = true,
		})

		-- nvim-cmp add extra capabilities to nvim.lsp default capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		require("lspconfig").lua_ls.setup({
			-- update capabilities with enhanced client capabilities
			capabilities = capabilities,

			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,

			settings = {
				Lua = {},
			},
		})

		-- community fork of pyls
		require("lspconfig").pylsp.setup({
			-- update capabilities with enhanced client capabilities
			capabilities = capabilities,

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

		require("lspconfig").jsonls.setup({
			capabilities = capabilities,
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

		require("lspconfig").ruby_lsp.setup({
			capabilities = capabilities,
			filetypes = { "ruby", "eruby" },
		})

		require("lspconfig").emmet_language_server.setup({
			capabilities = capabilities,
			filetypes = { "eruby", "html" },
		})

		-- require("lspconfig").yamlls.setup({
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
