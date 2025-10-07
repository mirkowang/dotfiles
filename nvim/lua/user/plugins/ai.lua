return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log wrapper
	},
	event = "VeryLazy",
	build = "make tiktoken", -- Only on MacOS or Linux
	keys = {
		{
			"<leader>ac",
			":CopilotChatVisual",
			mode = "x",
			desc = "CopilotChat - Ask copilot with vertical split",
		},
	},
	config = function(_, opts)
		require("copilot").setup({})

		local chat = require("CopilotChat")
		local select = require("CopilotChat.select")

		-- Use unnamed register for the selection
		opts.selection = select.unnamed

		chat.setup(opts)

		vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
			chat.ask(args.args, { selection = select.visual })
		end, { nargs = "*", range = true })

		-- Custom buffer for CopilotChat
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-*",
			callback = function()
				-- vim.opt_local.relativenumber = true
				-- vim.opt_local.number = true

				-- Get current filetype and set it to markdown if the current filetype is copilot-chat
				local ft = vim.bo.filetype
				if ft == "copilot-chat" then
					vim.bo.filetype = "markdown"
				end
			end,
		})
	end,

	opts = {
		model = "gpt-5-mini",

		auto_follow_cursor = true, -- Don't follow the cursor after getting response
		show_help = true, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat

		headers = {
			user = "👤 You",
			assistant = "🤖 Copilot",
			tool = "🔧 Tool",
		},

		separator = "━━",
		auto_fold = true, -- Automatically folds non-assistant messages

		-- debug = true, -- Enable debugging
		-- See Configuration section for rest
		window = {
			layout = "vertical",
			relative = "editor",
			width = 0.4,
			title = "Copilot Chat",
			border = "none",
		},

		mappings = {
			reset = {
				normal = "<C-r>",
				insert = "<C-r>",
			},
			close = {
				normal = "qq",
				insert = "<C-c>",
			},
		},
	},
}
