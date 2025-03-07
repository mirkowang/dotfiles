-- https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua
--
local prompts = {
	-- Code related prompts
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	FixCode = "Please fix the following code to make it work as intended.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	Documentation = "Please provide documentation for the following code.",
	SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
	SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log wrapper
	},

	build = "make tiktoken", -- Only on MacOS or Linux

	opts = {
		question_header = "## User ",
		answer_header = "## Copilot ",
		error_header = "## Error ",
		prompts = prompts,
		auto_follow_cursor = false, -- Don't follow the cursor after getting response
		show_help = true, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat

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

	config = function(_, opts)
		require("copilot").setup({})

		local chat = require("CopilotChat")
		local select = require("CopilotChat.select")
		-- Use unnamed register for the selection
		opts.selection = select.unnamed

		-- Override the git prompts message
		-- opts.prompts.Commit = {
		-- 	prompt = "Write commit message for the change with commitizen convention",
		-- 	selection = select.gitdiff,
		-- }

		-- opts.prompts.CommitStaged = {
		-- 	prompt = "Write commit message for the change with commitizen convention",
		-- 	selection = function(source)
		-- 		return select.gitdiff(source, true)
		-- 	end,
		-- }

		chat.setup(opts)

		-- Setup the CMP integration
		-- require("CopilotChat.integrations.cmp").setup()

		vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
			chat.ask(args.args, { selection = select.visual })
		end, { nargs = "*", range = true })

		-- Inline chat with Copilot
		vim.api.nvim_create_user_command("CopilotChatInline", function(args)
			chat.ask(args.args, {
				selection = select.visual,
				window = {
					layout = "float",
					relative = "cursor",
					width = 1,
					height = 0.7,
					row = 1,
				},
			})
		end, { nargs = "*", range = true })

		-- Restore CopilotChatBuffer
		vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
			chat.ask(args.args, { selection = select.buffer })
		end, { nargs = "*", range = true })

		-- Custom buffer for CopilotChat
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-*",
			callback = function()
				vim.opt_local.relativenumber = true
				vim.opt_local.number = true

				-- Get current filetype and set it to markdown if the current filetype is copilot-chat
				local ft = vim.bo.filetype
				if ft == "copilot-chat" then
					vim.bo.filetype = "markdown"
				end
			end,
		})
	end,

	event = "VeryLazy",

	keys = {
		-- Show help actions with telescope
		{
			"<leader>ah",
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.help_actions())
			end,
			desc = "CopilotChat - Help actions",
		},

		-- Chat with Copilot in visual mode
		{
			"<leader>av",
			":CopilotChatVisual",
			mode = "x",
			desc = "CopilotChat - Open in vertical split",
		},

		{
			"<leader>ax",
			":CopilotChatInline<cr>",
			mode = "x",
			desc = "CopilotChat - Inline chat",
		},

		-- Custom input for CopilotChat
		{
			"<leader>ai",
			function()
				local input = vim.fn.input("Ask Copilot: ")
				if input ~= "" then
					vim.cmd("CopilotChat " .. input)
				end
			end,
			desc = "CopilotChat - Ask input",
		},

		-- Show prompts actions with telescope
		{
			"<leader>ap",
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end,
			desc = "CopilotChat - Prompt actions",
		},
		{
			"<leader>ap",
			":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
			mode = "x",
			desc = "CopilotChat - Prompt actions",
		},
	},
}
