#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
sandbox=$(mktemp -d)
trap 'trash "$sandbox"' EXIT

mkdir -p "$sandbox/bin" "$sandbox/home/.config/hypr/scripts" "$sandbox/tmp"

cat >"$sandbox/bin/grim" <<'EOF'
#!/usr/bin/env bash
printf 'PNG'
EOF

cat >"$sandbox/bin/slurp" <<'EOF'
#!/usr/bin/env bash
printf '0,0 1x1'
EOF

cat >"$sandbox/bin/wl-copy" <<'EOF'
#!/usr/bin/env bash
cat >/dev/null
EOF

cat >"$sandbox/bin/notify-send" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

cat >"$sandbox/home/.config/hypr/scripts/Sounds.sh" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

chmod +x "$sandbox/bin"/* "$sandbox/home/.config/hypr/scripts/Sounds.sh"

HOME="$sandbox/home" TMPDIR="$sandbox/tmp" PATH="$sandbox/bin:$PATH" "$script_dir/ScreenShot.sh" --swappy

screenshots="$sandbox/home/Pictures/Screenshots"
[[ $(fd -t f -e png . "$screenshots" | wc -l) -eq 1 ]]
[[ -z $(fd -t f . "$sandbox/tmp") ]]
