-- whichkey.lua
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		win = {
			border = "rounded",
			padding = { 1, 2 },
			title_pos = "left",
		},
		layout = {
			align = "center",
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},
	},
}
