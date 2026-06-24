# cmux

Config for the [cmux](https://cmux.com) terminal app.

- `.config/cmux/cmux.json` — JSONC settings. Sets `automation.socketControlMode:
  "automation"` so external processes (the Claude usage poller) can drive the socket
  to rename the usage "sentinel" workspaces.
- `.config/cmux/sidebars/usage.swift` — a custom sidebar (SwiftUI-interpreted) that
  pins a `CLAUDE USAGE` panel above the workspace list. Painted by the poller in
  `dcryan/tmux-agentbar` (see `claude-usage-meters`).

## ⚠️ Stow with `--no-folding`

cmux follows a symlinked **file** but **not** a symlinked **directory**. Plain
`stow cmux` (or `stow */`) folds `sidebars/` into a single directory symlink, which
cmux refuses — `cmux sidebar validate` then reports **"0 valid sidebars."** Always
stow this package so `sidebars/` stays a real dir with a symlinked file inside:

```
mkdir -p ~/.config/cmux/sidebars
stow --no-folding --restow cmux
```

## Activate / revert the sidebar

```
cmux sidebar validate usage   # check it parses
cmux sidebar select usage     # activate (or right-click the sidebar toggle → "usage")
```

To revert to the built-in sidebar, right-click the sidebar toggle and pick the default.
