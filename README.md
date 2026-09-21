# vscode-vim

Personal VSCode Vim config — LazyVim-style keybindings via [VimCode](https://github.com/wojukasz/VimCode) with custom overrides.

## Setup

1. Install extensions:
   ```
   code --install-extension vscodevim.vim
   code --install-extension VSpaceCode.whichkey
   code --install-extension eamodio.gitlens
   code --install-extension hoovercj.vscode-settings-cycler
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
