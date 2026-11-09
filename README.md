# vscode-vim

Personal VSCode Vim config — LazyVim-style keybindings via [VimCode](https://github.com/wojukasz/VimCode) with custom overrides.

## Setup

### macOS / Linux

```sh
git clone https://github.com/RyanAHayden/lazycode ~/lazycode
~/lazycode/setup.sh
```

Installs VS Code, the extensions in `extensions.txt` and (macOS) the JetBrainsMono Nerd Font, turns off macOS
press-and-hold so held keys repeat, and symlinks `config/settings.json` and `config/keybindings.json` into VS Code's
User folder (an existing file is kept as `*.bak`), so changes made in VS Code show up here to commit. Safe to re-run.

Device-only extras that don't belong in the repo (work logins, servers, extensions) go in `~/.config/lazycode/`
(`%APPDATA%\lazycode\` on Windows):

| File | Effect |
|---|---|
| `settings.json` | JSON object appended to `config/settings.json` (its keys win). VS Code's `settings.json` is then built from both instead of symlinked: edit the two sources and re-run, edits made in VS Code are overwritten (previous file kept as `settings.json.bak`) |
| `extensions.txt` | more extensions to install |
| `mcp.json` | VS Code's MCP servers |
[hypr-mac](https://github.com/RyanAHayden/hypr-mac) runs it; its Karabiner Ctrl→Cmd rule leaves Ctrl+D/E/I/J/K/L/N/O/R/U/V/W/Y
as real Ctrl in VS Code for these bindings.

### Windows

```powershell
git clone https://github.com/RyanAHayden/lazycode
powershell -ExecutionPolicy Bypass -File lazycode\setup.ps1
```

Same as `setup.sh`, but copies the config files instead of symlinking them (symlinks need admin or Developer Mode),
so re-run it after pulling or editing the repo.

## Key bindings

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `<Tab>` | which-key popup |
| `<leader>af` | Toggle Copilot chat |
| `<leader>ac` | Inline chat |
| `Shift+H/L` | Previous/next buffer |
| `Ctrl+h/j/k/l` | Navigate splits (falls through to panels at edge) |
| `gd` / `gr` | Go to definition / references |
| `<leader>ff` | Find files |
| `<leader>/` | Search in workspace |
| `<leader>gg` | Git status |
