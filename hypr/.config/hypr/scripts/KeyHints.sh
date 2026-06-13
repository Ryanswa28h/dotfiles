#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="KooL Quick Cheat Sheet" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "close this app" "" " = " "SUPER KEY (Windows Key Button)" "(SUPER KEY)" \
" SHIFT K" "Searchable Keybinds" "(Search all Keybinds via rofi)" \
" SHIFT E" "KooL Hyprland Settings Menu" "" \
"" "" "" \
" enter" "Terminal" "(kitty)" \
" SHIFT enter" "DropDown Terminal" "(kitty)" \
" B" "Launch Browser" "(Default browser)" \
" D" "Application Launcher" "(rofi-wayland)" \
" A" "Desktop Overview" "(quickshell)" \
" E" "Open File Manager" "(kitty yazi)" \
" R" "KRunner" "(krunner)" \
" S" "Google Search using rofi" "(rofi)" \
" W" "Choose wallpaper" "(Wallpaper Menu)" \
" SHIFT W" "Choose wallpaper effects" "(imagemagick + swww)" \
"CTRL ALT W" "Random wallpaper" "(via swww)" \
" C" "Launch VS Code" "(code)" \
" Y" "Yazi file manager" "(kitty yazi)" \
" O" "Launch Obsidian" "(obsidian)" \
" V" "Neovim" "(kitty -e nvim)" \
" T" "Terminal" "(kitty)" \
" Q" "close active window" "(not kill)" \
" Shift Q" "Kill active window" "(kill)" \
" N" "Toggle night light" "(Hyprsunset)" \
" G" "Toggle Expo overview" "(hyprexpo)" \
" ALT mouse scroll up/down" "Desktop Zoom" "Desktop Magnifier" \
" Alt V" "Clipboard Manager" "(cliphist)" \
" ALT R" "Reload Waybar swaync Rofi" "CHECK NOTIFICATION FIRST!!!" \
" SHIFT N" "Launch Notification Panel" "swaync Notification Center" \
" SHIFT F" "Fullscreen" "Toggles to full screen" \
" CTL F" "Fake Fullscreen" "Toggles to fake full screen" \
"ALT tab" "Cycle windows + bring to top" "" \
"Print" "Screenshot area" "(grim)" \
" Print" "Screenshot" "(grim)" \
" Shift Print" "Screenshot region" "(swappy)" \
" CTRL Print" "Screenshot timer 5 secs" "(grim)" \
" CTRL SHIFT Print" "Screenshot timer 10 secs" "(grim)" \
"ALT Print" "Screenshot active window" "active window only" \
"CTRL ALT Delete" "Power-menu" "(wlogout)" \
"CTRL ALT L" "Screen lock" "(hyprlock)" \
"CTRL SHIFT ALT Delete" "Hyprland Exit" "(NOTE: Hyprland Will exit immediately)" \
" ALT L" "Toggle Dwindle | Master Layout" "Hyprland Layout" \
" SPACEBAR" "Toggle float" "single window" \
" ALT SPACEBAR" "Toggle all windows to float" "all windows" \
" ALT O" "Toggle Blur" "normal or less blur" \
" CTRL O" "Toggle Opaque ON or OFF" "on active window only" \
" SHIFT A" "Animations Menu" "Choose Animations via rofi" \
" CTRL R" "Rofi Themes Menu" "Choose Rofi Themes via rofi" \
" CTRL SHIFT R" "Rofi Themes Menu v2" "Choose Rofi Themes via Theme Selector (modified)" \
" SHIFT G" "Gamemode! All animations OFF or ON" "toggle" \
" ALT E" "Rofi Emoticons" "Emoticon" \
" H" "Move focus left" "" \
" J" "Cycle next window" "cyclenext" \
" K" "Cycle previous window" "cyclenext prev" \
" L" "Swap with master / focus master layout" "" \
" I" "Add master" "layoutmsg addmaster" \
" M" "Change split ratio" "splitratio 0.3" \
" P" "Toggle pseudo" "dwindle" \
" CTRL D" "Remove master" "layoutmsg removemaster" \
" CTRL Return" "Swap with master" "layoutmsg swapwithmaster" \
" CTRL L" "Focus master" "layoutmsg focusmaster" \
" left/right/up/down" "Move focus" "" \
" SHIFT left/right/up/down" "Resize windows" "" \
" CTRL left/right/up/down" "Move windows" "" \
" ALT left/right/up/down" "Swap windows" "" \
" [0-9]" "Switch workspaces" "" \
" SHIFT [0-9]" "Move window to workspace" "" \
" CTRL [0-9]" "Move window to workspace silently" "" \
" tab" "Next workspace" "" \
" SHIFT tab" "Previous workspace" "" \
" SHIFT U" "Move to special workspace" "" \
" U" "Toggle special workspace" "" \
" mouse_down" "Next workspace" "" \
" mouse_up" "Previous workspace" "" \
" LMB" "Move windows with mouse" "" \
" RMB" "Resize windows with mouse" "" \
"CTRL ALT W" "Random wallpaper" "(via swww)" \
"ALT_L + SHIFT_L" "Change keyboard layout" "global" \
"SHIFT_L + ALT_L" "Change keyboard layout per window" "local" \
" CTRL F9/F10/F11/F12" "Move workspace to monitor" "left/right/up/down" \
" SHIFT M" "Online music" "(rofi)" \
" SHIFT O" "Zsh Theme Change" "(oh-my-zsh)" \
" ALT C" "Calculator" "(qalculate)" \
"" "" "" \
"More tips:" "https://github.com/JaKooLit/Hyprland-Dots/wiki" ""\
