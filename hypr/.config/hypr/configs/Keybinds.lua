local home = os.getenv("HOME")
local mainMod = "SUPER"
local scriptsDir = home .. "/.config/hypr/scripts"

hl.bind("CTRL + SHIFT + ALT + Delete", hl.dsp.exec_cmd("hyprctl dispatch exit 0")) -- exit Hyprland
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- close active (not kill)
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(scriptsDir .. "/KillActiveProcess.sh")) -- Kill active process
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/LockScreen.sh")) -- screen lock
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(scriptsDir .. "/Wlogout.sh")) -- power menu
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw")) -- swayNC notification panel
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(scriptsDir .. "/Quick_Settings.sh")) -- Settings Menu
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("kitty yazi"))

-- Master Layout
hl.bind(mainMod .. " + CTRL + D", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg removemaster"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg addmaster"))
-- hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))
-- hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
-- hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
-- hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg swapwithmaster"))

-- Dwindle Layout
-- hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit")) -- only works on dwindle layout
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle

-- Works on either layout (Master or Dwindle)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch splitratio 0.3"))

-- group
-- hl.bind(mainMod .. " + G", hl.dsp.group.toggle()) -- toggle group
hl.bind(mainMod .. " + CTRL + tab", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive")) -- change focus to another window

-- Cycle windows if floating bring to top
local cyclenext = hl.dsp.window.cycle_next()
local bringtotop = hl.dsp.window.bring_to_top()
hl.bind("ALT + tab", function()
	hl.dispatch(cyclenext)
	hl.dispatch(bringtotop)
end)

-- Special Keys / Hot Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --inc"), { locked = true, repeating = true }) -- volume up
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --dec"), { locked = true, repeating = true }) -- volume down
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle-mic"), { locked = true }) -- mic mute
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle"), { locked = true }) -- mute
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true }) -- sleep button
hl.bind("XF86Rfkill", hl.dsp.exec_cmd(scriptsDir .. "/AirplaneMode.sh"), { locked = true }) -- Airplane mode

-- media controls using keyboards
-- Note: there is no single XF86AudioPlayPause keysym; the keycode maps to XF86AudioPlay
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --stop"), { locked = true })

-- Screenshot keybindings NOTE: You may need to press Fn key as well
hl.bind("Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --area")) -- screenshot (area)
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --now")) -- screenshot
hl.bind(mainMod .. " + CTRL + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in5")) -- screenshot (5 secs delay)
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in10")) -- screenshot (10 secs delay)
hl.bind("ALT + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --active")) -- screenshot (active window only)

-- screenshot with swappy (another screenshot tool)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --swappy")) -- screenshot (swappy)

-- Resize windows
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- Move windows
hl.bind(mainMod .. " + CTRL + left", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))

-- Swap windows
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "down" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspaces related
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspaces
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special:one" }))
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special("one"))

hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "special:two" }))
hl.bind(mainMod .. " + I", hl.dsp.workspace.toggle_special("two"))

hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ workspace = "special:three" }))
hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special("three"))

-- The following mappings use the key codes to better support various keyboard layouts
-- 1 is code:10, 2 is code 11, etc
-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + code:10", hl.dsp.focus({ workspace = 1 })) -- NOTE: code:10 = key 1
hl.bind(mainMod .. " + code:11", hl.dsp.focus({ workspace = 2 })) -- NOTE: code:11 = key 2
hl.bind(mainMod .. " + code:12", hl.dsp.focus({ workspace = 3 })) -- NOTE: code:12 = key 3
hl.bind(mainMod .. " + code:13", hl.dsp.focus({ workspace = 4 })) -- NOTE: code:13 = key 4
hl.bind(mainMod .. " + code:14", hl.dsp.focus({ workspace = 5 })) -- NOTE: code:14 = key 5
hl.bind(mainMod .. " + code:15", hl.dsp.focus({ workspace = 6 })) -- NOTE: code:15 = key 6
hl.bind(mainMod .. " + code:16", hl.dsp.focus({ workspace = 7 })) -- NOTE: code:16 = key 7
hl.bind(mainMod .. " + code:17", hl.dsp.focus({ workspace = 8 })) -- NOTE: code:17 = key 8
hl.bind(mainMod .. " + code:18", hl.dsp.focus({ workspace = 9 })) -- NOTE: code:18 = key 9
hl.bind(mainMod .. " + code:19", hl.dsp.focus({ workspace = 10 })) -- NOTE: code:19 = key 0

-- Move active window and follow to workspace mainMod + SHIFT [0-9]
hl.bind(mainMod .. " + SHIFT + code:10", hl.dsp.window.move({ workspace = 1 })) -- NOTE: code:10 = key 1
hl.bind(mainMod .. " + SHIFT + code:11", hl.dsp.window.move({ workspace = 2 })) -- NOTE: code:11 = key 2
hl.bind(mainMod .. " + SHIFT + code:12", hl.dsp.window.move({ workspace = 3 })) -- NOTE: code:12 = key 3
hl.bind(mainMod .. " + SHIFT + code:13", hl.dsp.window.move({ workspace = 4 })) -- NOTE: code:13 = key 4
hl.bind(mainMod .. " + SHIFT + code:14", hl.dsp.window.move({ workspace = 5 })) -- NOTE: code:14 = key 5
hl.bind(mainMod .. " + SHIFT + code:15", hl.dsp.window.move({ workspace = 6 })) -- NOTE: code:15 = key 6
hl.bind(mainMod .. " + SHIFT + code:16", hl.dsp.window.move({ workspace = 7 })) -- NOTE: code:16 = key 7
hl.bind(mainMod .. " + SHIFT + code:17", hl.dsp.window.move({ workspace = 8 })) -- NOTE: code:17 = key 8
hl.bind(mainMod .. " + SHIFT + code:18", hl.dsp.window.move({ workspace = 9 })) -- NOTE: code:18 = key 9
hl.bind(mainMod .. " + SHIFT + code:19", hl.dsp.window.move({ workspace = 10 })) -- NOTE: code:19 = key 0
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = -1 })) -- brackets [
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = 1 })) -- brackets ]

-- Move active window to a workspace silently mainMod + CTRL [0-9]
hl.bind(mainMod .. " + CTRL + code:10", hl.dsp.window.move({ workspace = 1, follow = false })) -- NOTE: code:10 = key 1
hl.bind(mainMod .. " + CTRL + code:11", hl.dsp.window.move({ workspace = 2, follow = false })) -- NOTE: code:11 = key 2
hl.bind(mainMod .. " + CTRL + code:12", hl.dsp.window.move({ workspace = 3, follow = false })) -- NOTE: code:12 = key 3
hl.bind(mainMod .. " + CTRL + code:13", hl.dsp.window.move({ workspace = 4, follow = false })) -- NOTE: code:13 = key 4
hl.bind(mainMod .. " + CTRL + code:14", hl.dsp.window.move({ workspace = 5, follow = false })) -- NOTE: code:14 = key 5
hl.bind(mainMod .. " + CTRL + code:15", hl.dsp.window.move({ workspace = 6, follow = false })) -- NOTE: code:15 = key 6
hl.bind(mainMod .. " + CTRL + code:16", hl.dsp.window.move({ workspace = 7, follow = false })) -- NOTE: code:16 = key 7
hl.bind(mainMod .. " + CTRL + code:17", hl.dsp.window.move({ workspace = 8, follow = false })) -- NOTE: code:17 = key 8
hl.bind(mainMod .. " + CTRL + code:18", hl.dsp.window.move({ workspace = 9, follow = false })) -- NOTE: code:18 = key 9
hl.bind(mainMod .. " + CTRL + code:19", hl.dsp.window.move({ workspace = 10, follow = false })) -- NOTE: code:19 = key 0
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = -1, follow = false })) -- brackets [
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = 1, follow = false })) -- brackets ]

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- NOTE: mouse:272 = left click
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- NOTE: mouse:273 = right click

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg swapwithmaster"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg focusmaster"))

-- common shortcuts
--hl.bind(mainMod .. " + " .. mainMod .. "_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window")) -- Super Key to Launch rofi menu
hl.bind(
	mainMod .. " + D",
	hl.dsp.exec_cmd(
		"pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window -config ~/.config/rofi/config-launcher.rasi"
	)
) -- Main Menu (APP Launcher)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd('xdg-open "https://"')) -- default browser
--hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || true && ags -t 'overview'")) -- desktop overview (if installed)
hl.bind(mainMod .. " + A", hl.dsp.global("quickshell:overviewToggle")) -- desktop overview (if installed)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty")) --terminal
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty yazi")) -- file manager
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty")) -- kitty terminal
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("kitty -e nvim"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("krunner"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("krunner"))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd("kitty --detach zsh -c 'export ZSH_NO_TMUX=1; exec zsh'")) -- no tmux terminal
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("kitty --detach zsh -c 'export ZSH_NO_TMUX=1; exec zsh'")) -- no tmux terminal

-- FEATURES / EXTRAS
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd(scriptsDir .. "/KeyHints.sh")) -- help / cheat sheet
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(scriptsDir .. "/Refresh.sh")) -- Refresh waybar, swaync, rofi
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(scriptsDir .. "/RofiEmoji.sh")) -- emoji menu
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scriptsDir .. "/RofiSearch.sh")) -- Google search using rofi
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("rofi -show window")) -- list/switch apps using rofi
hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.sh")) -- Toggle blur settings
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/GameMode.sh")) -- Toggle animations ON/OFF
hl.bind(mainMod .. " + CTRL + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/SemiGameMode.sh")) -- Toggle animations ON/OFF (with blur on)
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.sh")) -- Toggle Master or Dwindle Layout
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd(scriptsDir .. "/ClipManager.sh")) -- Clipboard Manager
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(scriptsDir .. "/RofiThemeSelector.sh")) -- Rofi Menu Theme Selector
hl.bind(
	mainMod .. " + CTRL + SHIFT + R",
	hl.dsp.exec_cmd("pkill rofi || true && " .. scriptsDir .. "/RofiThemeSelector-modified.sh")
) -- modified Rofi Theme Selector

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen()) -- whole full screen
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = 1 })) -- fake full screen
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" })) -- Float Mode
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allfloat")) -- All Float Mode
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(scriptsDir .. "/Dropterminal.sh kitty")) -- Dropdown terminal

-- Desktop zooming or magnifier
hl.bind(
	"CTRL + SUPER + mouse_down",
	hl.dsp.exec_cmd([[
  factor=$(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {f = $2; if (f < 1) f = 1; print f * 2}')
  hyprctl eval "hl.config({ cursor = { zoom_factor = "$factor" } })"
]])
)
hl.bind(
	"CTRL + SUPER + mouse_up",
	hl.dsp.exec_cmd([[
  factor=$(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {f = $2; if (f < 1) f = 1; print f / 2}')
  hyprctl eval "hl.config({ cursor = { zoom_factor = "$factor" } })"
]])
)

-- Waybar / Bar related
hl.bind(mainMod .. " + CTRL + ALT + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")) -- Toggle hide/show waybar
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(scriptsDir .. "/WaybarStyles.sh")) -- Waybar Styles Menu
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(scriptsDir .. "/WaybarLayout.sh")) -- Waybar Layout Menu

-- Night light toggle (Hyprsunset)
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(scriptsDir .. "/Hyprsunset.sh toggle"))

-- FEATURES / EXTRAS
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(scriptsDir .. "/RofiBeats.sh")) -- online music using rofi
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(scriptsDir .. "/WallpaperSelect.sh")) -- Select wallpaper to apply
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(scriptsDir .. "/WallpaperEffects.sh")) -- Wallpaper Effects by imagemagick
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(scriptsDir .. "/WallpaperRandom.sh")) -- Random wallpapers
hl.bind(mainMod .. " + CTRL + O", hl.dsp.exec_cmd("hyprctl setprop active opaque toggle")) -- disable opacity on active window
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(scriptsDir .. "/KeyBinds.sh")) -- search keybinds via rofi
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(scriptsDir .. "/Animations.sh")) --hyprland animations menu
-- Zsh theme switch moved to a script binding (removed to keep special:three on mainMod + SHIFT + O)
hl.bind(
	"ALT_L + SHIFT_L",
	hl.dsp.exec_cmd(scriptsDir .. "/SwitchKeyboardLayout.sh"),
	{ locked = true, non_consuming = true }
) -- Change keyboard layout globally
hl.bind(
	"SHIFT_L + ALT_L",
	hl.dsp.exec_cmd(scriptsDir .. "/Tak0-Per-Window-Switch.sh"),
	{ locked = true, non_consuming = true }
) -- Change keyboard layout locally for each window
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(scriptsDir .. "/RofiCalc.sh")) -- calculator (qalculate)

-- Move current workspaces to monitors (left right up or down)
hl.bind(mainMod .. " + CTRL + F9", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l")) -- move current workspace to LEFT monitor
hl.bind(mainMod .. " + CTRL + F10", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r")) -- move current workspace to RIGHT monitor
hl.bind(mainMod .. " + CTRL + F11", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor u")) -- move current workspace to UP monitor
hl.bind(mainMod .. " + CTRL + F12", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor d")) -- move current workspace to DOWN monitor

-- For passthrough keyboard into a VM
-- hl.bind(mainMod .. " + ALT + P", hl.dsp.submap("passthru"))
-- hl.define_submap("passthru", function()
--     hl.bind(mainMod .. " + ALT + P", hl.dsp.submap("reset"))
-- end)

-- scrolling-only (ignored in other layouts)
-- Column navigation is handled by J/K via LayoutCycle.sh
-- SHIFT variants move windows between columns
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg movewindowto r"))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg movewindowto l"))
-- SHIFT + up/down kept as resize (base keybinds); window move on these keys removed

hl.bind(mainMod .. " + J", hl.dsp.exec_cmd(scriptsDir .. "/LayoutCycle.sh next"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(scriptsDir .. "/LayoutCycle.sh prev"))

-- Workspace switch: mainMod + , (numeric prev) / . (numeric next), creates empty workspaces
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.focus({ workspace = \"-1\" })'"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.focus({ workspace = \"+1\" })'"))

-- Volume quick set: CTRL + ` = 0/100%, CTRL + 1-9 = 10-90%
hl.bind(
	"CTRL + code:49",
	hl.dsp.exec_cmd(
		"vol=$(pamixer --get-volume); "
			.. 'if [ "$vol" -eq 0 ]; then '
			.. "pamixer --set-volume 100; " -- --set-volume caps at 100
			.. "pamixer -i 50 --allow-boost" -- boost above 100
			.. scriptsDir
			.. "/Sounds.sh --volume; "
			.. 'notify-send -e -h int:value:100 -h "string:x-canonical-private-synchronous:volume_notif" -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$HOME/.config/swaync/icons/volume-high.png" " Volume Level:" "100 %"; '
			.. "else "
			.. scriptsDir
			.. "/Volume.sh --set 0; "
			.. "fi"
	)
)
hl.bind("CTRL + code:10", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 10")) -- 1 = 10%
hl.bind("CTRL + code:11", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 20")) -- 2 = 20%
hl.bind("CTRL + code:12", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 30")) -- 3 = 30%
hl.bind("CTRL + code:13", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 40")) -- 4 = 40%
hl.bind("CTRL + code:14", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 50")) -- 5 = 50%
hl.bind("CTRL + code:15", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 60")) -- 6 = 60%
hl.bind("CTRL + code:16", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 70")) -- 7 = 70%
hl.bind("CTRL + code:17", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 80")) -- 8 = 80%
hl.bind("CTRL + code:18", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --set 90")) -- 9 = 90%

-- Brightness quick set: CTRL + SHIFT + ` = 0%, CTRL + SHIFT + 1-9 = 10-90%, CTRL + SHIFT + 0 = 100%
hl.bind("CTRL + SHIFT + code:49", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 0")) -- ~ = 0%
hl.bind("CTRL + SHIFT + code:10", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 10")) -- ! = 10%
hl.bind("CTRL + SHIFT + code:11", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 20")) -- @ = 20%
hl.bind("CTRL + SHIFT + code:12", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 30")) -- # = 30%
hl.bind("CTRL + SHIFT + code:13", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 40")) -- $ = 40%
hl.bind("CTRL + SHIFT + code:14", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 50")) -- % = 50%
hl.bind("CTRL + SHIFT + code:15", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 60")) -- ^ = 60%
hl.bind("CTRL + SHIFT + code:16", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 70")) -- & = 70%
hl.bind("CTRL + SHIFT + code:17", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 80")) -- * = 80%
hl.bind("CTRL + SHIFT + code:18", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --set 90")) -- ( = 90%

-- Volume step (5%): mainMod + - / +
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --dec"), { repeating = true })
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --inc"), { repeating = true })

-- Brightness step (5%): mainMod + _ (shift + -) / + (shift + =)
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --dec"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --inc"), { repeating = true })
