# vscode-vim Repository Context

## Purpose
This repo configures VSCode to use VimCode (Vim emulation) with LazyVim keybindings. It syncs configuration between repo and local VSCode user settings.

## Setup
- **Extension**: VimCode (vscodevim.vim)
- **Philosophy**: LazyVim-style bindings adapted to VSCode
- **Config location**: `config/` folder
  - `settings.json` - Vim mode bindings, editor config, which-key menus
  - `keybindings.json` - VSCode-level keybindings (Ctrl, Alt, Shift, special chars)

## Critical Rules Before Adding Any Binding

1. **ALWAYS verify the command exists in local VSCode first**
   - CHECK FIRST https://code.visualstudio.com/docs/getstarted/keybindings
   - Use Keyboard Shortcuts UI (Ctrl+K Ctrl+S) to search for commands
   - Don't make up command names - ask user or verify they exist

2. **Check existing config** to see how similar bindings are done
   - Use `grep_search` to find existing patterns
   - Look for the binding you're modifying first

3. **Vim-level vs VSCode-level**
   - Capital keys like `K` → `settings.json` (vim.normalModeKeyBindingsNonRecursive)
   - Ctrl/Alt/Shift/special chars → `keybindings.json`
   - VSCode keybindings have NO access to vim context (only VSCode contexts work)

## Workflow for Adding Bindings

1. Search existing config for similar binding: `grep_search` for key + concept
2. Verify command exists in VSCode: check Keyboard Shortcuts UI or ask user
3. Find the right file based on key type (see rule #3 above)
4. Add binding with proper context and comment

## Config Sync
Task: "Copy settings to User Folder" - syncs repo config to VSCode user settings
