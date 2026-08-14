#!/bin/bash
set -euo pipefail

BACKEND=wayland

keybind_rows=(
    "Key" "Description" "Action"
    "CTRL SHIFT ALT Delete" "Exit Hyprland" "hyprctl dispatch exit 0"
    "  Q" "Close active window" "close"
    "  SHIFT Q" "Kill active window" "KillActiveProcess.sh"
    "CTRL ALT L" "Lock session" "Noctalia session lock"
    "CTRL ALT Delete" "Power menu" "Noctalia session panel"
    "  Delete" "Power menu" "Noctalia session panel"
    "  F2" "Power menu" "Noctalia session panel"
    "  N" "Noctalia notifications" "Notifications panel"
    "  SHIFT E" "Quick Settings" "Quick_Settings.sh"
    "  Y" "File manager" "kitty yazi"
    "  CTRL D" "Remove master / annotation draw toggle" "layoutmsg removemaster; wayscriber draw toggle"
    "  CTRL I" "Add master" "layoutmsg addmaster"
    "  H" "Focus left" "focus left"
    "  L" "Focus right" "focus right"
    "  ALT Return" "Swap with master" "layoutmsg swapwithmaster"
    "  P" "Toggle pseudo window" "dwindle pseudo"
    "  C" "System panel" "Noctalia system panel"
    "  CTRL Tab" "Change active group window" "hyprctl dispatch changegroupactive"
    "ALT Tab" "Cycle next window and bring to top" "cycle_next; bring_to_top"
    "Print" "Screenshot area" "ScreenShot.sh --area"
    "  Print" "Screenshot" "ScreenShot.sh --now"
    "  CTRL Print" "Screenshot after 5 seconds" "ScreenShot.sh --in5"
    "  CTRL SHIFT Print" "Screenshot after 10 seconds" "ScreenShot.sh --in10"
    "ALT Print" "Screenshot active window" "ScreenShot.sh --active"
    "  SHIFT S" "Screenshot with Swappy" "ScreenShot.sh --swappy"
    "  SHIFT Left" "Resize window left" "resize -50 0"
    "  SHIFT Right" "Resize window right" "resize +50 0"
    "  SHIFT Up" "Resize window up" "resize 0 -50"
    "  SHIFT Down" "Resize window down" "resize 0 +50"
    "  CTRL Left" "Move window left" "hyprctl dispatch movewindow l"
    "  CTRL Right" "Move window right" "hyprctl dispatch movewindow r"
    "  CTRL Up" "Move window up" "hyprctl dispatch movewindow u"
    "  CTRL Down" "Move window down" "hyprctl dispatch movewindow d"
    "  ALT Left" "Swap window left" "swap left"
    "  ALT Right" "Swap window right" "swap right"
    "  ALT Up" "Swap window up" "swap up"
    "  ALT Down" "Swap window down" "swap down"
    "  Left" "Focus left" "focus left"
    "  Right" "Focus right" "focus right"
    "  Up" "Focus up" "focus up"
    "  Down" "Focus down" "focus down"
    "  Tab" "Next existing workspace" "workspace m+1"
    "  SHIFT Tab" "Previous existing workspace" "workspace m-1"
    "  SHIFT U" "Move window to special workspace one" "special:one"
    "  ALT U" "Move window to regular workspace" "workspace e+0"
    "  U" "Toggle special workspace one" "special:one"
    "  SHIFT I" "Move window to special workspace two" "special:two"
    "  ALT I" "Move window to regular workspace" "workspace e+0"
    "  I" "Toggle special workspace two" "special:two"
    "  SHIFT O" "Move window to special workspace three" "special:three"
    "  ALT O" "Move window to regular workspace" "workspace e+0"
    "  O" "Toggle special workspace three" "special:three"
    "  SHIFT P" "Move window to regular workspace" "workspace e+0"
    "  1–0" "Switch to workspace 1–10" "code:10–19"
    "  SHIFT 1–0" "Move window to workspace 1–10" "code:10–19"
    "  SHIFT [" "Move window to previous workspace" "workspace -1"
    "  SHIFT ]" "Move window to next workspace" "workspace +1"
    "  CTRL 1–0" "Move window to workspace 1–10 without focus" "code:10–19"
    "  CTRL [" "Move window to previous workspace without focus" "workspace -1"
    "  CTRL ]" "Move window to next workspace without focus" "workspace +1"
    "  Scroll down" "Next workspace" "workspace e+1"
    "  Scroll up" "Previous workspace" "workspace e-1"
    "  Left mouse drag" "Move window" "drag"
    "  Right mouse drag" "Resize window" "resize"
    "  D" "Application launcher" "Noctalia launcher panel"
    "  B" "Open default browser" "xdg-open https://"
    "  Return" "Terminal" "kitty"
    "  E" "File manager" "dolphin"
    "  T" "Terminal" "kitty"
    "  R" "Run command" "krunner"
    "  CTRL Return" "Detached terminal without tmux" "kitty --detach zsh"
    "  CTRL T" "Detached terminal without tmux" "kitty --detach zsh"
    "  ALT H" "Keybind cheat sheet" "KeyHints.sh"
    "  ALT R" "Reload desktop shell" "Refresh.sh"
    "  ALT E" "Emoji picker" "RofiEmoji.sh"
    "  S" "Noctalia home panel" "Control center home"
    "  ALT S" "Web search" "RofiSearch.sh"
    "  CTRL S" "Window switcher" "Noctalia window-switcher"
    "  CTRL ALT O" "Toggle blur" "ChangeBlur.sh"
    "  SHIFT G" "Toggle game mode" "GameMode.sh"
    "  ALT L" "Change layout" "ChangeLayout.sh"
    "  V" "Clipboard panel" "Noctalia clipboard"
    "  A" "Power panel" "Noctalia power panel"
    "  SHIFT C" "Calendar panel" "Noctalia calendar panel"
    "  SHIFT W" "Weather panel" "Noctalia weather panel"
    "  SHIFT B" "Bluetooth panel" "Noctalia bluetooth panel"
    "  SHIFT N" "Network panel" "Noctalia network panel"
    "  SHIFT T" "Screen time panel" "Noctalia screen-time panel"
    "  M" "Media panel" "Noctalia media panel"
    "  SHIFT M" "Monitor panel" "Noctalia monitor panel"
    "  SHIFT A" "Audio panel" "Noctalia audio panel"
    "  X" "Toggle SearXNG" "SearXNGToggle.sh"
    "  SHIFT V" "Toggle Proton VPN" "ProtonVPNToggle.sh"
    "  CTRL V" "Show Proton VPN status" "ProtonVPNStatus.sh"
    "  CTRL R" "Rofi theme selector" "RofiThemeSelector.sh"
    "  CTRL SHIFT R" "Modified Rofi theme selector" "RofiThemeSelector-modified.sh"
    "  SHIFT F" "Fullscreen" "fullscreen"
    "  CTRL F" "Fake fullscreen" "fullscreen mode 1"
    "  Space" "Toggle floating window" "float toggle"
    "  ALT Space" "Float all windows" "workspaceopt allfloat"
    "  SHIFT Return" "Dropdown terminal" "Dropterminal.sh kitty"
    "CTRL   Scroll up" "Increase desktop zoom" "cursor zoom factor ×2"
    "CTRL   Scroll down" "Decrease desktop zoom" "cursor zoom factor ÷2"
    "  CTRL ALT B" "Toggle Noctalia bar" "bar-toggle"
    "  CTRL B" "Waybar style selector" "WaybarStyles.sh"
    "  ALT B" "Waybar layout selector" "WaybarLayout.sh"
    "  W" "Wallpaper panel" "Noctalia wallpaper panel"
    "CTRL ALT W" "Random wallpaper" "Noctalia wallpaper-random"
    "  CTRL O" "Toggle active window opacity" "hyprctl setprop active opaque toggle"
    "  SHIFT K" "Search configured keybinds" "KeyBinds.sh"
    "  CTRL A" "Animation selector" "Animations.sh"
    "ALT_L SHIFT_L" "Change keyboard layout globally" "SwitchKeyboardLayout.sh"
    "SHIFT_L ALT_L" "Change keyboard layout per window" "Tak0-Per-Window-Switch.sh"
    "  ALT C" "Calculator" "RofiCalc.sh"
    "  CTRL F9" "Move workspace to left monitor" "movecurrentworkspacetomonitor l"
    "  CTRL F10" "Move workspace to right monitor" "movecurrentworkspacetomonitor r"
    "  CTRL F11" "Move workspace to upper monitor" "movecurrentworkspacetomonitor u"
    "  CTRL F12" "Move workspace to lower monitor" "movecurrentworkspacetomonitor d"
    "  SHIFT ." "Move window to next scrolling column" "layoutmsg movewindowto r"
    "  SHIFT ," "Move window to previous scrolling column" "layoutmsg movewindowto l"
    "  J" "Focus down" "focus down"
    "  K" "Focus up" "focus up"
    "  ," "Previous workspace, creates if needed" "workspace -1"
    "  ." "Next workspace, creates if needed" "workspace +1"
    "CTRL \`" "Toggle 0% or 100% volume" "pamixer; Volume.sh"
    "CTRL 1–9" "Set volume to 10%–90%" "Noctalia volume-set"
    "CTRL SHIFT \`" "Set brightness to 0%" "Noctalia brightness-set 0"
    "CTRL SHIFT 1–9" "Set brightness to 10%–90%" "Noctalia brightness-set"
    "  -" "Decrease volume 5%" "Noctalia volume-down"
    "  =" "Increase volume 5%" "Noctalia volume-up"
    "  SHIFT -" "Decrease brightness 5%" "Noctalia brightness-down"
    "  SHIFT =" "Increase brightness 5%" "Noctalia brightness-up"
    "  G" "Toggle HyprExpo overview" "hyprexpo plugin"
    "XF86Launch1" "Open ROG Control Center" "rog-control-center"
    "XF86Launch3" "Next keyboard RGB profile" "asusctl led-mode -n"
    "XF86Launch4" "Next ASUS performance profile" "asusctl profile -n"
    "  F6" "Screenshot" "ScreenShot.sh --now"
    "  SHIFT F6" "Screenshot area" "ScreenShot.sh --area"
    "  CTRL F6" "Screenshot after 5 seconds" "ScreenShot.sh --in5"
    "  ALT F6" "Screenshot after 10 seconds" "ScreenShot.sh --in10"
    "ALT F6" "Screenshot active window" "ScreenShot.sh --active"
)

if ! command -v yad >/dev/null; then
    notify-send -u critical "Keybind cheat sheet" "yad is not installed"
    exit 1
fi

if pidof yad >/dev/null; then
    pkill yad
fi

if [[ "${1:-}" == "--search" || "${1:-}" == "-s" ]]; then
    if ! command -v rofi >/dev/null; then
        notify-send -u critical "Keybind cheat sheet" "rofi is not installed"
        exit 1
    fi

    result=$(for ((index = 0; index < ${#keybind_rows[@]}; index += 3)); do
        printf '%s|%s|%s\n' "${keybind_rows[index]}" "${keybind_rows[index + 1]}" "${keybind_rows[index + 2]}"
    done | rofi -dmenu -i -p "Search Keybinds" -theme-str 'listview {lines: 15;}')
    if [[ -n "$result" ]]; then
        notify-send -e -u low -t 4000 "Keybind: $result"
    fi
    exit 0
fi

GDK_BACKEND="$BACKEND" yad \
    --center \
    --on-top \
    --title="Keybindings" \
    --no-buttons \
    --list \
    --column="Key" \
    --column="Description" \
    --column="Action" \
    --width=1100 \
    --height=800 \
    -- \
    "${keybind_rows[@]}"
