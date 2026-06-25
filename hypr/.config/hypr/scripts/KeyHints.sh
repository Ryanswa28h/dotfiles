#!/bin/bash

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi >/dev/null; then
    pkill rofi
fi

if pidof yad >/dev/null; then
    pkill yad
fi

# Use rofi for search mode if --search or -s flag is passed
if [[ "$1" == "--search" || "$1" == "-s" ]]; then
    result=$(
        GDK_BACKEND=$BACKEND rofi -dmenu -p "Search Keybinds" -i -theme-str 'listview {lines: 15;}' <<'DATA'
ESC|close this app
SUPER = Windows Key
SUPER SHIFT K|Searchable Keybinds (via rofi)
SUPER SHIFT E|Quick Settings Menu
SUPER enter|Terminal (kitty)
SUPER SHIFT enter|DropDown Terminal (kitty)
SUPER B|Launch Browser
SUPER D|Application Launcher (rofi)
SUPER A|Desktop Overview (quickshell)
SUPER E|File Manager (kitty yazi)
SUPER R|KRunner
SUPER S|Google Search via rofi
SUPER W|Choose wallpaper
SUPER SHIFT W|Wallpaper effects
CTRL ALT W|Random wallpaper
SUPER C|VS Code
SUPER Y|Yazi file manager
SUPER O|Obsidian
SUPER V|Neovim (kitty)
SUPER T|Terminal (kitty)
SUPER Q|Close active window
SUPER SHIFT Q|Kill active window
SUPER N|Toggle night light
SUPER G|Toggle Expo overview (hyprexpo)
SUPER ALT scroll|Desktop Zoom
SUPER ALT V|Clipboard Manager
SUPER ALT R|Reload Waybar swaync Rofi
SUPER SHIFT N|Notification Panel
SUPER SHIFT F|Fullscreen
SUPER CTRL F|Fake Fullscreen
ALT tab|Cycle windows + bring to top
Print|Screenshot area
SUPER Print|Screenshot
SUPER SHIFT Print|Screenshot (swappy)
SUPER CTRL Print|Screenshot 5s
SUPER CTRL SHIFT Print|Screenshot 10s
ALT Print|Screenshot active window
CTRL ALT Delete|Power-menu (wlogout)
CTRL ALT L|Screen lock (hyprlock)
CTRL SHIFT ALT Delete|Exit Hyprland
SUPER ALT L|Toggle Layout (Master/Dwindle/Scrolling)
SUPER SPACE|Toggle float
SUPER ALT SPACE|All windows float
SUPER ALT O|Toggle Blur
SUPER CTRL O|Toggle Opaque
SUPER SHIFT A|Animations Menu
SUPER CTRL R|Rofi Themes Menu
SUPER CTRL SHIFT R|Rofi Themes v2
SUPER SHIFT G|GameMode toggle
SUPER -|Volume down 5%
SUPER =|Volume up 5%
SUPER SHIFT -|Brightness down 5%
SUPER SHIFT =|Brightness up 5%
SUPER ALT E|Rofi Emoticons
SUPER H|Move focus left
SUPER J|Cycle next / Scrolling: next column
SUPER K|Cycle prev / Scrolling: prev column
SUPER L|Swap with master
SUPER I|Add master
SUPER M|Change split ratio
SUPER P|Toggle pseudo (dwindle)
SUPER CTRL D|Remove master
SUPER CTRL Return|Swap with master
SUPER CTRL L|Focus master
SUPER arrows|Move focus
SUPER SHIFT arrows|Resize windows
SUPER CTRL arrows|Move windows
SUPER ALT arrows|Swap windows
SUPER [0-9]|Switch workspaces
SUPER SHIFT [0-9]|Move window to workspace
SUPER CTRL [0-9]|Move window to workspace (silent)
SUPER tab|Next existing workspace
SUPER SHIFT tab|Previous existing workspace
SUPER ,|Previous workspace (creates if needed)
SUPER .|Next workspace (creates if needed)
SUPER SHIFT U|Move to special workspace
SUPER U|Toggle special workspace
SUPER scroll|Next/prev workspace
SUPER LMB|Move windows with mouse
SUPER RMB|Resize windows with mouse
ALT+SHIFT|Change keyboard layout (global)
SHIFT+ALT|Change keyboard layout (per window)
SUPER CTRL F9-F12|Move workspace to monitor
SUPER SHIFT M|Online music (rofi)
SUPER SHIFT O|Zsh Theme Change
SUPER ALT C|Calculator
DATA
    )
    if [ -n "$result" ]; then
        notify-send -e -u low -t 4000 "Keybind: $result"
    fi
    exit 0
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="Keymaps" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
    "ESC" "close this app" "" " = " "SUPER KEY (Windows Key Button)" "(SUPER KEY)" \
    " SHIFT K" "Searchable Keybinds" "(Search all Keybinds via rofi)" \
    " SHIFT E" "Quick Settings Menu" "" \
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
    " ALT L" "Toggle Layout: Master / Dwindle / Scrolling" "Hyprland Layout" \
    " SPACEBAR" "Toggle float" "single window" \
    " ALT SPACEBAR" "Toggle all windows to float" "all windows" \
    " ALT O" "Toggle Blur" "normal or less blur" \
    " CTRL O" "Toggle Opaque ON or OFF" "on active window only" \
    " SHIFT A" "Animations Menu" "Choose Animations via rofi" \
    " CTRL R" "Rofi Themes Menu" "Choose Rofi Themes via rofi" \
    " CTRL SHIFT R" "Rofi Themes Menu v2" "Choose Rofi Themes via Theme Selector (modified)" \
    " SHIFT G" "Gamemode! All animations OFF or ON" "toggle" \
    " minus" "Volume down 5%" "" \
    " equal" "Volume up 5%" "" \
    " SHIFT minus" "Brightness down 5%" "" \
    " SHIFT equal" "Brightness up 5%" "" \
    " ALT E" "Rofi Emoticons" "Emoticon" \
    " H" "Move focus left" "" \
    " J" "Cycle next / Scrolling: next column" "layout-aware" \
    " K" "Cycle previous / Scrolling: prev column" "layout-aware" \
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
    " tab" "Next existing workspace" "m+1" \
    " SHIFT tab" "Previous existing workspace" "m-1" \
    " ," "Previous workspace (creates if needed)" "-1" \
    " ." "Next workspace (creates if needed)" "+1" \
    " SHIFT U" "Move to special workspace" "" \
    " U" "Toggle special workspace" "" \
    " mouse_down" "Next existing workspace" "" \
    " mouse_up" "Previous existing workspace" "" \
    " LMB" "Move windows with mouse" "" \
    " RMB" "Resize windows with mouse" "" \
    "CTRL ALT W" "Random wallpaper" "(via swww)" \
    "ALT_L + SHIFT_L" "Change keyboard layout" "global" \
    "SHIFT_L + ALT_L" "Change keyboard layout per window" "local" \
    " CTRL F9/F10/F11/F12" "Move workspace to monitor" "left/right/up/down" \
    " SHIFT M" "Online music" "(rofi)" \
    " SHIFT O" "Zsh Theme Change" "(oh-my-zsh)" \
    " ALT C" "Calculator" "(qalculate)" \
    "" ""
