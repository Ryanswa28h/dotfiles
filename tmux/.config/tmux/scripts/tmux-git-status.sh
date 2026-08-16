#!/usr/bin/env bash

path=${1:-}

if ! git -C "$path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

branch=$(git -C "$path" symbolic-ref --short -q HEAD 2>/dev/null \
  || git -C "$path" rev-parse --short HEAD 2>/dev/null) \
  || exit 0

if [[ -n $(git -C "$path" status --porcelain 2>/dev/null) ]]; then
  printf '󰊢 %s *' "$branch"
else
  printf '󰊢 %s' "$branch"
fi
