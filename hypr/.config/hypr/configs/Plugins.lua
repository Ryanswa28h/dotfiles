-- Plugin configuration (uncomment blocks for plugins you have installed via hyprpm)
-- See https://wiki.hypr.land/Plugins/ for more info

-- hl.config({
--     plugin = {
--         ["borders-plus-plus"] = {
--             add_borders = 1,
--             col = {
--                 border_1 = "rgb(ababab)",
--                 border_2 = "rgb(000000)",
--             },
--             border_size_1 = 1,
--             border_size_2 = 1,
--             natural_rounding = "yes",
--         },
--         hyprbars = {
--             bar_height = 25,
--             bar_color = "rgb(212121)",
--             bar_buttons_alignment = "left",
--             bar_button_padding = 5,
--             bar_padding = 20,
--             bar_blur = true,
--             hyprbars_button = {
--                 { color = "rgb(ff4040)", size = 12, on_click = "hyprctl dispatch killactive" },
--                 { color = "rgb(eeee11)", size = 12, on_click = "togglefloating" },
--                 { color = "rgb(66ff66)", size = 12, on_click = "hyprctl dispatch fullscreen 1" },
--             },
--             on_double_click = "hyprctl dispatch fullscreen 1",
--             inactive_button_color = "rgb(505050)",
--         },
--         hyprtrails = {
--             color = "rgba(ffffffff)",
--         },
--         hyprscrolling = {
--             column_width = 0.7,
--             fullscreen_on_one_column = true,
--         },
--     },
-- })

-- Hyprexpo: expose-style workspace overview
-- hl.config({
--     plugin = {
--         hyprexpo = {
--             columns = 3,
--             gaps_in = 5,
--             gaps_out = 0,
--             bg_col = "rgb(111111)",
--             workspace_method = "center current",
--             gesture_distance = 200,
--             cancel_key = "escape",
--             show_cursor = 1,
--         },
--     },
-- })

-- This will toggle HyprExpo when SUPER+g is pressed
hl.bind("SUPER + G", function()
	hl.plugin.hyprexpo.expo("toggle")
end)
