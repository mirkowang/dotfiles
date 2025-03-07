return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- local function command_messages()
		-- 	local messages = vim.api.nvim_exec("echo v:statusmsg", true)
		-- 	return messages ~= "" and messages or ""
		-- end

		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					function()
						return "󰅭 " .. vim.pesc(tostring(#vim.tbl_keys(vim.lsp.get_clients())) or "")
					end,
					{ "diagnostics", sources = { "nvim_diagnostic" } },
					-- "diagnostics",
				},

				lualine_c = {
					function()
						local filepath = vim.fn.expand("%:p") -- Get the absolute path
						local parent_dir = vim.fn.fnamemodify(filepath, ":h:t") -- Get the parent directory
						local filename = vim.fn.fnamemodify(filepath, ":t") -- Get the filename
						if parent_dir and filename then
							return parent_dir .. "/" .. filename
						else
							return filename or "" -- Fallback to just filename
						end
					end,
				},
				-- lualine_c = {
				-- 	function()
				-- 		return vim.fn.expand("%:~:.")
				-- 	end,
				-- },
				-- lualine_c = { "filename" },
				-- lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
