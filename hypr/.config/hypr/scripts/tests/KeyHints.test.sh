#!/bin/bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
temp_dir=$(mktemp -d)
trap 'trash "$temp_dir"' EXIT

cat >"$temp_dir/pidof" <<'SH'
#!/bin/sh
exit 1
SH
cat >"$temp_dir/yad" <<'SH'
#!/bin/sh
printf '%s\n' "$@" >"$KEYHINTS_YAD_ARGS"
SH
chmod +x "$temp_dir/pidof" "$temp_dir/yad"

KEYHINTS_YAD_ARGS="$temp_dir/yad-args" PATH="$temp_dir:$PATH" bash "$repo_root/scripts/KeyHints.sh"

grep -Fxq -- "--on-top" "$temp_dir/yad-args"
grep -Fxq -- "--" "$temp_dir/yad-args"
grep -Fxq 'hl.window_rule({ match = { title = "^(Keybindings)$" }, float = true, center = true })' "$repo_root/configs/WindowRules.lua"
grep -Fxq 'hl.window_rule({ match = { title = "^(Keybindings)$" }, opacity = "0.85 0.85" })' "$repo_root/configs/WindowRules.lua"
grep -Fxq -- "  N" "$temp_dir/yad-args"
grep -Fxq -- "Noctalia notifications" "$temp_dir/yad-args"
grep -Fxq -- "  SHIFT N" "$temp_dir/yad-args"
grep -Fxq -- "Network panel" "$temp_dir/yad-args"
! grep -Eqi '^XF86(Audio|KbdBrightness|MonBrightness)' "$temp_dir/yad-args"
grep -Fxq -- "XF86Launch1" "$temp_dir/yad-args"
grep -Fxq -- "  F6" "$temp_dir/yad-args"
! grep -qi 'swaync' "$repo_root/scripts/KeyHints.sh"
