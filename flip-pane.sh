# Flip the focused pane's split orientation within its tab (side-by-side <-> stacked).
# Works on two-pane tabs and exits unchanged otherwise. The running process
# survives: the pane is moved out to a temporary tab and back with the
# opposite split direction, reusing the original split ratio.
set -eu

PANE="${HERDR_ACTIVE_PANE_ID:?flip-pane needs pane context; bind it via [[keys.command]]}"

info=$(herdr pane layout --pane "$PANE" | python3 -c '
import json, sys
l = json.load(sys.stdin)["result"]["layout"]
panes = l["panes"]
splits = l.get("splits") or []
if len(panes) != 2 or len(splits) != 1 or l.get("zoomed"):
    sys.exit(3)
other = next(p["pane_id"] for p in panes if p["pane_id"] != sys.argv[1])
d = splits[0]["direction"]
print(l["tab_id"], other, "down" if d == "right" else "right", splits[0].get("ratio", 0.5))
' "$PANE") || {
  echo "flip-pane: not a two-pane split; nothing to flip" >&2
  exit 3
}

# shellcheck disable=SC2086 # tab/pane ids and numbers carry no spaces
set -- $info
tab=$1; other=$2; newdir=$3; ratio=$4

herdr pane move "$PANE" --new-tab > /dev/null
herdr pane move "$PANE" --tab "$tab" --split "$newdir" --target-pane "$other" --ratio "$ratio" > /dev/null