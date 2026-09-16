<div align="center">

# herdr-config

My config for **herdr**, the terminal multiplexer — catppuccin theming with auto light/dark,
two pane-helper scripts, and the keybindings that tie them together.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)](./config.toml)
[![Theme](https://img.shields.io/badge/theme-catppuccin-8839ef)](https://github.com/catppuccin)

**Auto light/dark catppuccin · two-pane flips · fzf workspace picker**

[What's in the box](#-whats-in-the-box) · [Theme](#-theme) · [Install](#-install) · [The scripts](#-the-scripts) · [What stays private](#-what-stays-private)

</div>

> [!TIP]
> **Try the pane flip first.** Drop `flip-pane.sh` into `~/.config/herdr`, bind it, and press
> `prefix+f` on any two-pane tab. The running process survives the flip — read
> [The scripts](#-the-scripts) to see how.

A terminal multiplexer's config is usually either dump-all-the-things or a `.zshrc` graveyard.
This one is small on purpose: one TOML file, two shell scripts, and a fence around everything
herdr regenerates at runtime. The keybinding blocks below are the managed style herdr's plugins
write — markers like `>>> herdr-file-viewer keys` are generated, so edits to your own blocks
should stay outside them.

```toml
[[keys.command]]
key = "prefix+f"
type = "shell"
command = "~/.config/herdr/flip-pane.sh"
description = "flip pane split orientation"
```

<a id="whats-in-the-box"></a>

## ✨ What's in the box

| File | What it does |
| --- | --- |
| `config.toml` | Keybindings, catppuccin auto light/dark, sidebar tuning, per-workspace colors |
| `flip-pane.sh` | Flips the focused split from side-by-side to stacked — and back |
| `move-pane.sh` | fzf picker that moves the active pane into any workspace as a new tab |
| `.gitignore` | The privacy fence — everything herdr regenerates at runtime stays local |

**Keybindings** (the two script bindings plus the plugin-managed blocks):

| Key | Runs | What you get |
| --- | --- | --- |
| `prefix+f` | `flip-pane.sh` (shell) | Flip the focused pane's split orientation |
| `prefix+shift+m` | `move-pane.sh` (80%×60% popup) | Move pane to workspace, with a picker |
| `prefix+shift+z` | `furkankly.zoetrope.open` (plugin) | Session graph overlay |
| `prefix+shift+f` | `herdr-file-viewer.open-file-viewer` (plugin) | File viewer beside the focused pane |

Two more zoetrope placements (`prefix+shift+v` split, `prefix+shift+c` tab) ship commented-out
in `config.toml` — uncomment one and run `herdr server reload-config`.

<a id="theme"></a>

## 🎨 Theme

Catppuccin with `auto_switch = true`: `catppuccin-latte` for light, `catppuccin` for dark, with
custom row backgrounds (`#ccd0da` light, `#313244` dark) matching the palette exactly. The
sidebar colors each workspace by name — ten workspaces, ten catppuccin accents:

| Workspace | Accent | Hex |
| --- | --- | --- |
| `67-sus-95-clean` | sapphire | `#209fb5` |
| `agents` | teal | `#179299` |
| `collie` | peach | `#fe640b` |
| `context-monorepo` | blue | `#1e66f5` |
| `goose-phone-app` | flamingo | `#dd7878` |
| `onyx-rs` | sky | `#04a5e5` |
| `opencode` | lavender | `#7287fd` |
| `personal-ai-setup` | yellow | `#df8e1d` |
| `scratch` | mauve | `#8839ef` |
| `ultraopen` | green | `#40a02b` |

UI tuning worth stealing: `status_indicators = "symbols"`, `sidebar_width = 40` (max 46),
`redraw_on_focus_gained = false`, and `zero row_gap` on both sidebar sections.

<a id="install"></a>

## 📦 Install

1. Clone into place:
   ```bash
   git clone https://github.com/PhillipChaffee/herdr-config ~/.config/herdr
   ```
2. The theme, UI, and script bindings load on herdr's next start — no build, no dependencies
   beyond the scripts' own tools below.
3. The plugin keybinding blocks (`zoetrope`, `herdr-file-viewer`) are written by those plugins'
   `setup-keys` runs, not by this repo — install the plugins with `herdr plugin add` and their
   managed blocks reappear.

<a id="scripts"></a>

## 🛠️ The scripts

**`flip-pane.sh`** — flips the focused pane's split orientation within its tab
(side-by-side ↔ stacked). It works only on two-pane, non-zoomed tabs and exits unchanged
otherwise. The trick that makes it feel native: the running process survives, because the pane
is moved out to a temporary tab and back with the opposite split direction — reusing the
original split ratio. Needs `python3` (for the layout JSON) and the `herdr` CLI.

**`move-pane.sh`** — pick a herdr workspace with `fzf` and the active pane becomes a new tab
in it. `herdr workspace list | jq | fzf`, then `exec herdr pane move … --focus`. Needs `jq`
and `fzf`.

<a id="privacy"></a>

## 🔒 What stays private

A config directory is full of files that should never be public, so this repo ships with a
deliberate `.gitignore` and nothing else. Everything below was audited (pattern scanning for
secret-shaped content, never printing contents) before the first push:

| Excluded | Why |
| --- | --- |
| `*.log` | A multiplexer's logs can contain terminal transcripts — including anything typed |
| `*.sock`, `session.json`, `sessions/` | Live sockets, local paths, agent session IDs |
| `config.toml.bak*`, other backups | Backups can hold credentials deleted from the live file |
| `plugins/`, `plugins.json` | Vendored checkouts of other people's repos (herdr re-fetches them) plus plugin runtime state, including a local `.env` |

The repo you are reading is six files: the config, two scripts, the fence, a README, and a
license. If herdr adds new runtime files, they are ignored by default until proven clean.

## ⚖️ License

MIT — see [LICENSE](./LICENSE).