# herdr-config

Configuration for **herdr**, a terminal workspace manager for AI coding agents:
keybindings, theming, pane scripts, and plugin-managed blocks.

## Language

**Space**:
A herdr workspace — the sidebar's unit of organization, holding tabs and panes
rooted at one directory. herdr's UI says "spaces"; its CLI spells the same
thing "workspace" (`herdr workspace …`).
_Avoid_: project, session

**Review pane**:
The split pane the `reviewr` plugin opens beside a space's root pane, showing
the working diff of the space's checkout.
_Avoid_: diff pane, review tab