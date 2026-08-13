hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,

		border_size = 2,

		-- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
		col = {
			-- active_border = "rgba(616161ff)",
			-- active_border = "rgba(75F1FAff)",
			active_border = "rgba(75F1FAff)",
			inactive_border = "rgba(999999ff)",
		},

		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
		allow_tearing = false,

		-- layout = "dwindle"
	},

	decoration = {
		rounding = 4,
		rounding_power = 4,

		active_opacity = 0.9,
		inactive_opacity = 0.875,
		fullscreen_opacity = 1.0,

		blur = {
			enabled = true,
			xray = false,
			special = false,
			new_optimizations = true,
			size = 20,
			passes = 3,
			brightness = 1,
			noise = 0.01,
			contrast = 0.89,
			ignore_opacity = true,
			vibrancy = 0.5,
			vibrancy_darkness = 0.5,
			popups = true,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},

		shadow = {
			enabled = false,
			-- ignore_window = true
			range = 15,
			-- offset = "0 2"
			render_power = 3,
			color = "rgba(1a1b2699)",
		},

		-- Dim
		dim_inactive = true,
		dim_strength = 0.05,
		dim_special = 0.07,
	},
})

-- Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-borders-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-borders-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		-- pseudotile = true -- Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		preserve_split = true, -- You probably want this
	},
})
