#!/usr/bin/env bash

DIR="$1"  # l r u d

ACTIVE_JSON="$(hyprctl activewindow -j 2>/dev/null)"
[ -z "$ACTIVE_JSON" ] && exit 0

ACTIVE_ID="$(echo "$ACTIVE_JSON" | jq -r '.address')"
GROUP="$(echo "$ACTIVE_JSON" | jq '.grouped')"
GROUP_LEN="$(echo "$GROUP" | jq 'length')"

# ---------- NOT GROUPED ----------
if [ "$GROUP_LEN" -eq 0 ]; then
    # Try entering a group
    # if hyprctl dispatch moveintogroup "$DIR" 2>/dev/null; then
    #     exit 0
    # fi

    # Fallback: normal move
    # hyprctl dispatch movewindow "$DIR"
    hyprctl dispatch movefocus "$DIR"
    exit 0
fi

# ---------- GROUPED ----------
# Find index of active window in group
INDEX="$(echo "$GROUP" | jq "index(\"$ACTIVE_ID\")")"
LAST_INDEX=$((GROUP_LEN - 1))

case "$DIR" in
    l|u)
        if [ "$INDEX" -eq 0 ]; then
            # Spill out of group
	    hyprctl dispatch movefocus "$DIR"
        else
            # Move within group
            hyprctl dispatch changegroupactive b
        fi
        ;;
    r|d)
        if [ "$INDEX" -eq "$LAST_INDEX" ]; then
            # Spill out of group
	    hyprctl dispatch movefocus "$DIR"
        else
            # Move within group 
            hyprctl dispatch changegroupactive f
        fi
        ;;
esac
