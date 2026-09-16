#!/bin/sh
# Pick a herdr workspace and move the active pane into it as a new tab.
: "${HERDR_ACTIVE_PANE_ID:?not running inside a herdr pane}"

choice=$(herdr workspace list \
  | jq -r '.result.workspaces[] | "\(.workspace_id)\t\(.label)"' \
  | fzf --delimiter='\t' --with-nth=2 --prompt='move pane to workspace> ') || exit 0
ws_id=${choice%%$'\t'*}

exec herdr pane move "$HERDR_ACTIVE_PANE_ID" --new-tab --workspace "$ws_id" --focus