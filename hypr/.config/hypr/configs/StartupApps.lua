local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"

local wallDIR = home .. "/Pictures/wallpapers"
local lock = scriptsDir .. "/LockScreen.sh"
local SwwwRandom = scriptsDir .. "/WallpaperAutoChange.sh"
local livewallpaper = ""

-- wallpaper stuff
hl.on("hyprland.start", function()
	hl.exec_cmd("swww-daemon")
	--hl.exec_cmd("mpvpaper '*' -o \"load-scripts=no no-audio --loop\" " .. livewallpaper)
end)

-- wallpaper random
--hl.on("hyprland.start", function()
--    hl.exec_cmd(SwwwRandom .. " " .. wallDIR) -- random wallpaper switcher every 30 minutes
--end)

-- Startup
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("swww init")

	hl.exec_cmd(scriptsDir .. "/Hyprsunset.sh startup")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

	-- Initialize Drop Down terminal
	hl.exec_cmd(scriptsDir .. "/Dropterminal.sh kitty &")
	hl.exec_cmd(scriptsDir .. "/autostart_kde.sh")

	-- Polkit (Polkit Gnome / KDE)
	hl.exec_cmd(scriptsDir .. "/Polkit.sh")

	-- starup apps
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("hyprpm reload") -- plugins
	hl.exec_cmd("swaync")
	--hl.exec_cmd("ags")
	hl.exec_cmd("blueman-applet")
	--hl.exec_cmd("rog-control-center")
	hl.exec_cmd("waybar")
	hl.exec_cmd("qs") -- quickshell AGS Desktop Overview alternative
	hl.exec_cmd("nm-applet &")
	hl.exec_cmd("ydotoold") -- ydotoold (Autoclicker daemon)

	--clipboard manager
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	-- Starting hypridle to start hyprlock
	hl.exec_cmd("hypridle")
end)

-- Here are list of features available but disabled by default
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("swww-daemon --format xrgb && swww img " .. home .. "/Pictures/wallpapers/mecha-nostalgia.png") -- persistent wallpaper
-- end)

--gnome polkit for nixos
--hl.on("hyprland.start", function()
--    hl.exec_cmd(scriptsDir .. "/Polkit-NixOS.sh")
--end)

-- xdg-desktop-portal-hyprland (should be auto starting. However, you can force to start)
--hl.on("hyprland.start", function()
--    hl.exec_cmd(scriptsDir .. "/PortalHyprland.sh")
--end)
