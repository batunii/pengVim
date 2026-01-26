#!/usr/bin/env bash

DIR="$1"  # l r u d

ACTIVE_JSON="$(hyprctl activewindow -j 2>/dev/null)"
[ -z "$ACTIVE_JSON" ] && exit 0

ACTIVE_ID="$(echo "$ACTIVE_JSON" | jq -r '.address')"
GROUP="$(echo "$ACTIVE_JSON" | jq '.grouped')"
GROUP_LEN="$(echo "$GROUP" | jq 'length')"

ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
ACTIVE_MON=$(hyprctl activewindow -j | jq -r '.monitor')

ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
ACTIVE_MON=$(hyprctl activewindow -j | jq -r '.monitor')

ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')

HAS_GROUP=$(hyprctl clients -j | jq --argjson ws "$ACTIVE_WS" '
  any(.[];
    (.workspace.id == $ws) and
    ((.grouped | length) > 0)
  )
')
echo "$HAS_GROUP"
if [ "$GROUP_LEN" -eq 0 ]; then
    if [ "$HAS_GROUP" = "true" ]; then
        if hyprctl dispatch moveintogroup "$DIR" 2>/dev/null; then
            exit 0
        fi
    fi

    hyprctl dispatch movewindow "$DIR"
    exit 0
fi







# ---------- NOT GROUPED ----------
# if [ "$GROUP_LEN" -eq 0 ]; then
#     # Try entering a group
#     if hyprctl dispatch moveintogroup "$DIR" 2>/dev/null; then
#         exit 0
#     fi

#     echo "Still here"
#     # Fallback: normal move
#     hyprctl dispatch movewindow "$DIR"
#     exit 0
# fi

# ---------- GROUPED ----------
# Find index of active window in group
INDEX="$(echo "$GROUP" | jq "index(\"$ACTIVE_ID\")")"
LAST_INDEX=$((GROUP_LEN - 1))

case "$DIR" in
    l|u)
        if [ "$INDEX" -eq 0 ]; then
            # Spill out of group
            hyprctl dispatch moveoutofgroup "$DIR"
        else
            # Move within group
            hyprctl dispatch movegroupwindow b
        fi
        ;;
    r|d)
        if [ "$INDEX" -eq "$LAST_INDEX" ]; then
            # Spill out of group
            hyprctl dispatch moveoutofgroup "$DIR"
        else
            # Move within group
            hyprctl dispatch movegroupwindow f
        fi
        ;;
esac
