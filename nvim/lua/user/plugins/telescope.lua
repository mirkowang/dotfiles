return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	keys = {
		{
			"<C-p>",
			function()
				require("telescope.builtin").find_files()
			end,
		},
		{
			"<C-e>",
			function()
				require("telescope.builtin").buffers({
					sort_mru = true, -- Sort by most recently used buffers
					ignore_current_buffer = true, -- Optionally, ignore the current buffer
				})
			end,
		},
		{
			"<C-f>",
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
		},
		{
			"<C-g>",
			function()
				require("telescope.builtin").live_grep()
			end,
		},
	},
	config = function()
		local actions = require("telescope.actions")

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = actions.close,
					},
				},
				file_ignore_patterns = { ".git/", "tmp/", "vendor/" },
				preview = {
					timeout = 200,
				},
			},
			extensions = {},
			pickers = {
				find_files = {
					previewer = true,
				},
			},
		})
	end,
}
