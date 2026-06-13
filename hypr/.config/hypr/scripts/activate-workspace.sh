#!/bin/bash
# Activate a Hyprland workspace using Lua-compatible dispatcher
# Usage: activate-workspace.sh <workspace_id>

hyprctl dispatch "hl.dsp.focus({ workspace = $1 })"
