return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				-- pip3 install isort black
				-- current: managed by mason
				lua = { "stylua" },

				-- pip3 install ruff
				-- current: managed by mason
				python = { "ruff_format" },

				-- gem install rubocop
				-- current: managed by mason
				ruby = { "rubocop" },

				-- gem install erb-formatter
				-- current: managed by mason
				eruby = { "erb_format" },
			},

			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
		})
	end,
}
