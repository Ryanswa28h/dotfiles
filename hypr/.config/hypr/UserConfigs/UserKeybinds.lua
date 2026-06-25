local home = os.getenv("HOME")
local mainMod = "SUPER"
local scriptsDir = home .. "/.config/hypr/scripts"
local UserScripts = home .. "/.config/hypr/UserScripts"
local UserConfigs = home .. "/.config/hypr/UserConfigs"

-- common shortcuts
--hl.bind(mainMod .. " + " .. mainMod .. "_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window")) -- Super Key to Launch rofi menu
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window")) -- Main Menu (APP Launcher)
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

hl.bind(
	mainMod .. " + L",
	hl.dsp.exec_cmd('eww update dashrev=$( [ "$(eww get dashrev)" = "true" ] && echo false || echo true )')
)

-- FEATURES / EXTRAS
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd(scriptsDir .. "/KeyHints.sh")) -- help / cheat sheet
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(scriptsDir .. "/Refresh.sh")) -- Refresh waybar, swaync, rofi
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(scriptsDir .. "/RofiEmoji.sh")) -- emoji menu
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scriptsDir .. "/RofiSearch.sh")) -- Google search using rofi
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("rofi -show window")) -- list/switch apps using rofi
hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.sh")) -- Toggle blur settings
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/GameMode.sh")) -- Toggle animations ON/OFF
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.sh")) -- Toggle Master or Dwindle Layout
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd(scriptsDir .. "/ClipManager.sh")) -- Clipboard Manager
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(scriptsDir .. "/RofiThemeSelector.sh")) -- KooL Rofi Menu Theme Selector
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

-- FEATURES / EXTRAS (UserScripts)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(UserScripts .. "/RofiBeats.sh")) -- online music using rofi
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(UserScripts .. "/WallpaperSelect.sh")) -- Select wallpaper to apply
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(UserScripts .. "/WallpaperEffects.sh")) -- Wallpaper Effects by imagemagick
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(UserScripts .. "/WallpaperRandom.sh")) -- Random wallpapers
hl.bind(mainMod .. " + CTRL + O", hl.dsp.exec_cmd("hyprctl setprop active opaque toggle")) -- disable opacity on active window
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(scriptsDir .. "/KeyBinds.sh")) -- search keybinds via rofi
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(scriptsDir .. "/Animations.sh")) --hyprland animations menu
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(UserScripts .. "/ZshChangeTheme.sh")) -- Change oh-my-zsh theme
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
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(UserScripts .. "/RofiCalc.sh")) -- calculator (qalculate)

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
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg movewindowto u"))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg movewindowto d"))

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
