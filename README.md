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
[hypr-mac](https://github.com/RyanAHayden/hypr-mac) runs it; its Karabiner Ctrl→Cmd rule leaves Ctrl+D/E/I/J/K/L/N/O/R/U/V/W/Y
as real Ctrl in VS Code for these bindings.

### Windows

1. Install the extensions in `extensions.txt`:
   ```powershell
   Get-Content extensions.txt | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object { code --install-extension $_ }
   ```

2. Copy config files:
   ```powershell
   Copy-Item config\settings.json $env:APPDATA\Code\User\
   Copy-Item config\keybindings.json $env:APPDATA\Code\User\
   ```

3. Reload VS Code.

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
