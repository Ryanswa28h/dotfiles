local function finalize_theme()
	pcall(vim.cmd.colorscheme, "nord")
end

return {
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
		enabled = true,
		config = finalize_theme,
	},
}
