-- Vendor defaults for window rules and layerrules
-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

-- NOTES: This is only for Hyprland > 0.52.1
-- note for ja: This should NOT be implemented on Debian and Ubuntu

-- windowrule - tags - add apps under appropriate tag to use the same settings
-- browser tags
hl.window_rule({
	match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" },
	tag = "+browser",
})
hl.window_rule({ match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^(chrome-.+-Default)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Cc]hromium)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^(Brave-browser(-beta|-dev|-unstable)?)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Tt]horium-browser|[Cc]achy-browser)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^(zen-alpha|zen)$" }, tag = "+browser" })

-- notif tags
hl.window_rule({
	match = { class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" },
	tag = "+notif",
})

-- Quick settings tag
hl.window_rule({ match = { title = "^(Quick Cheat Sheet)$" }, tag = "+Quick_Cheat" })
hl.window_rule({ match = { title = "^(Quick Settings)$" }, tag = "+Quick_Settings" })
hl.window_rule({ match = { class = "^(nwg-displays|nwg-look)$" }, tag = "+Quick-Settings" })

-- terminal tags
hl.window_rule({ match = { class = "^(Alacritty|kitty|kitty-dropterm)$" }, tag = "+terminal" })

-- email tags
hl.window_rule({ match = { class = "^([Tt]hunderbird|org.gnome.Evolution)$" }, tag = "+email" })
hl.window_rule({ match = { class = "^(eu.betterbird.Betterbird)$" }, tag = "+email" })

-- project tags
hl.window_rule({ match = { class = "^(codium|codium-url-handler|VSCodium)$" }, tag = "+projects" })
hl.window_rule({ match = { class = "^(VSCode|code|code-url-handler)$" }, tag = "+projects" })
hl.window_rule({ match = { class = "^(jetbrains-.+)$" }, tag = "+projects" })

-- screenshare tags
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, tag = "+screenshare" })

-- IM tags
hl.window_rule({ match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(ZapZap|com.rtosta.zapzap)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(teams-for-linux)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(im.riot.Riot|Element)$" }, tag = "+im" })

-- game tags
hl.window_rule({ match = { class = "^(gamescope)$" }, tag = "+games" })
hl.window_rule({ match = { class = "^(steam_app_\\d+)$" }, tag = "+games" })

-- gamestore tags
hl.window_rule({ match = { class = "^([Ss]team)$" }, tag = "+gamestore" })
hl.window_rule({ match = { title = "^([Ll]utris)$" }, tag = "+gamestore" })
hl.window_rule({ match = { class = "^(com.heroicgameslauncher.hgl)$" }, tag = "+gamestore" })

-- file-manager tags
hl.window_rule({ match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" }, tag = "+file-manager" })
hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, tag = "+file-manager" })

-- wallpaper tags
hl.window_rule({ match = { class = "^([Ww]aytrogen)$" }, tag = "+wallpaper" })

-- multimedia tags
hl.window_rule({ match = { class = "^([Aa]udacious)$" }, tag = "+multimedia" })

-- multimedia-video tags
hl.window_rule({ match = { class = "^([Mm]pv|vlc)$" }, tag = "+multimedia_video" })

-- settings tags
hl.window_rule({ match = { title = "^(ROG Control)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(gnome-disks|wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ match = { title = "(Kvantum Manager)" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, tag = "+settings" })
hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	tag = "+settings",
})
hl.window_rule({ match = { class = "^(qt5ct|qt6ct|[Yy]ad)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "(xdg-desktop-portal-gtk)" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^([Rr]ofi)$" }, tag = "+settings" })

-- viewer tags
hl.window_rule({
	match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" },
	tag = "+viewer",
})
hl.window_rule({ match = { class = "^(evince)$" }, tag = "+viewer" })
hl.window_rule({ match = { class = "^(eog|org.gnome.Loupe)$" }, tag = "+viewer" })

-- Some special override rules
hl.window_rule({ match = { tag = "^multimedia_video$" }, no_blur = true })
hl.window_rule({ match = { tag = "^multimedia_video$" }, opacity = 1.0 })

-- POSITION
-- hl.window_rule({ match = { float = true }, center = true })
hl.window_rule({ match = { tag = "^Quick_Cheat$" }, center = true })
hl.window_rule({ match = { class = "^([Tt]hunar)$", title = "^negative:(.*[Tt]hunar.*)$" }, center = true })
hl.window_rule({ match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ match = { tag = "^Quick-Settings$" }, center = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	center = true,
})
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, center = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, center = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, move = "72% 7%" })

-- windowrule to avoid idle for fullscreen apps
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- FLOAT
hl.window_rule({ match = { tag = "^Quick_Cheat$" }, float = true })
hl.window_rule({ match = { tag = "^wallpaper$" }, float = true })
hl.window_rule({ match = { tag = "^settings$" }, float = true })
hl.window_rule({ match = { tag = "^viewer$" }, float = true })
hl.window_rule({ match = { tag = "^Quick-Settings$" }, float = true })
hl.window_rule({ match = { class = "^([Zz]oom|onedriver|onedriver-launcher)$" }, float = true })
hl.window_rule({ match = { class = "^(org.gnome.Calculator)", title = "^(Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })

-- windowrule - float popups and dialogue
hl.window_rule({ match = { title = "^(Authentication Required)$" }, float = true, center = true })
hl.window_rule({
	match = { class = "^(codium|codium-url-handler|VSCodium)$", title = "^negative:(.*codium.*|.*VSCodium.*)$" },
	float = true,
})
hl.window_rule({
	match = { class = "^(com.heroicgameslauncher.hgl)$", title = "^negative:(Heroic Games Launcher)$" },
	float = true,
})
hl.window_rule({ match = { class = "^([Ss]team)$", title = "^negative:^([Ss]team)$" }, float = true })
hl.window_rule({ match = { class = "^([Tt]hunar)$", title = "^negative:(.*[Tt]hunar.*)$" }, float = true })

hl.window_rule({ match = { title = "^(Add Folder to Workspace)$" }, float = true, size = "70% 60%", center = true })

hl.window_rule({ match = { title = "^(Save As)$" }, float = true, size = "70% 60%", center = true })

hl.window_rule({ match = { initial_title = "^(Open Files)$" }, float = true, size = "70% 60%" })

hl.window_rule({ match = { title = "^(SDDM Background)$" }, float = true, center = true, size = "16% 12%" })

-- YAD dialog for wallpaper confirmation
hl.window_rule({ match = { class = "^(yad)$", title = "^(YAD)$" }, float = true, center = true, size = "20% 20%" })
-- END of float popups and dialogue

-- OPACITY
hl.window_rule({ match = { tag = "^browser$" }, opacity = "0.99 0.8" })
hl.window_rule({ match = { tag = "^projects$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { tag = "^im$" }, opacity = "0.94 0.86" })
hl.window_rule({ match = { tag = "^multimedia$" }, opacity = "0.94 0.86" })
hl.window_rule({ match = { tag = "^file-manager$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { tag = "^terminal$" }, opacity = "0.9 0.7" })
hl.window_rule({ match = { tag = "^settings$" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { tag = "^viewer$" }, opacity = "0.82 0.75" })
hl.window_rule({ match = { tag = "^wallpaper$" }, opacity = "0.9 0.7" })
hl.window_rule({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { class = "^(deluge)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { class = "^(seahorse)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })

-- SIZE
hl.window_rule({ match = { tag = "^Quick_Cheat$" }, size = "65% 90%" })
hl.window_rule({ match = { tag = "^wallpaper$" }, size = "70% 70%" })
hl.window_rule({ match = { tag = "^settings$" }, size = "70% 70%" })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, size = "60% 70%" })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, size = "60% 70%" })

-- PINNING
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, pin = true, keep_aspect_ratio = true })

-- BLUR & FULLSCREEN
hl.window_rule({ match = { tag = "^games$" }, no_blur = true, fullscreen = 0 })
hl.window_rule({ match = { tag = "^games$" }, fullscreen = 0 })

-- This not gonna take the focus to the window that appears when hovering over some of the parts of the IntelliJ Products
hl.window_rule({ match = { class = "^(jetbrains-*)" }, no_initial_focus = true })
hl.window_rule({ match = { title = "^(wind.*)$" }, no_initial_focus = true })

-- Discord
-- hl.window_rule({ match = { class = "^discord$" }, opacity = 0.75 })

-- LAYER RULES
-- swaync blur
hl.layer_rule({ match = { namespace = "^swaync-notification-window$" }, blur = true })
hl.layer_rule({ match = { namespace = "^swaync-notification-window$" }, ignore_alpha = 0.4 })
hl.layer_rule({ match = { namespace = "^swaync-control-center$" }, blur = true })
hl.layer_rule({ match = { namespace = "^swaync-control-center$" }, ignore_alpha = 0.4 })
hl.layer_rule({ match = { namespace = "^waybar$" }, blur = true })
hl.layer_rule({ match = { namespace = "^waybar$" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "^waybar$" }, blur_popups = true })
hl.layer_rule({ match = { namespace = "^rofi$" }, blur = true })
hl.layer_rule({ match = { namespace = "^logout_dialog$" }, blur = true })
hl.layer_rule({ match = { namespace = "^quickshell:overview$" }, blur = true })
hl.layer_rule({ match = { namespace = "^quickshell:overview$" }, ignore_alpha = 0.5 })
-- hl.layer_rule({ match = { namespace = "^logout_dialog$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^logout_dialog$" }, animation = "slide" })
hl.layer_rule({ match = { namespace = "^swaync-control-center$" }, animation = "slide" })
hl.layer_rule({ match = { namespace = "^rofi$" }, animation = "slide" })
