#!/usr/bin/env bash
# group-toggle-dir.sh

DIR="$1"

ACTIVE_JSON="$(hyprctl activewindow -j 2>/dev/null)"
[ -z "$ACTIVE_JSON" ] && exit 0

GROUP_LEN="$(echo "$ACTIVE_JSON" | jq '.grouped | length')"

if [ "$GROUP_LEN" -gt 0 ]; then
    # Window is grouped → remove from group
    hyprctl dispatch movefocus "$DIR"
#else
    # Window not grouped → move into group in direction
    #hyprctl dispatch moveintogroup "$DIR"
fi
