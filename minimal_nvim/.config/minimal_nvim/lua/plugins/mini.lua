local function macro_recording()
	local recording_reg = vim.fn.reg_recording()
	if recording_reg == "" then
		return ""
	else
		return "󰑋  Recording @" .. recording_reg
	end
end

local open_mini_files = function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local path = vim.fs.dirname(buf_name)
	if path == nil or path == "." or path == "" then
		path = vim.uv.os_homedir()
	end
	require("mini.files").open(path)
end

local statusline_opts = {
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 75 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local macro = macro_recording()
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },

				{ hl = mode_hl, strings = { macro } },

				{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- Right align filler
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
}

return {
	{
		"nvim-mini/mini.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.schedule(function()
				require("mini.ai").setup({})
				require("mini.surround").setup({})
				require("mini.bracketed").setup({})
				require("mini.statusline").setup(statusline_opts)
				-- require("mini.pairs").setup({})
			end)
		end,
	},
}
