#!/usr/bin/env bash
# Sets up VS Code the same way on macOS (run from hypr-mac) and Linux (run from dotfiles): installs it and the
# extensions in extensions.txt, and symlinks config/settings.json + keybindings.json into its User folder, so edits
# made in VS Code land in this repo. Windows: see the README. Safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname)" = Darwin ]; then
	[ -d "/Applications/Visual Studio Code.app" ] || brew install --cask visual-studio-code
	brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1 || brew install --cask font-jetbrains-mono-nerd-font
	CODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
	USR="$HOME/Library/Application Support/Code/User"
	# hold j/k to repeat instead of popping the accent menu
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
else
	command -v code >/dev/null || yay -S --needed visual-studio-code-bin
	CODE=code
	USR="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User"
fi

echo "==> lazycode: settings + keybindings into $USR"
mkdir -p "$USR"
for f in settings.json keybindings.json; do
	t="$USR/$f"
	[ "$(readlink "$t" 2>/dev/null)" = "$REPO/config/$f" ] && continue
	[ -e "$t" ] && mv "$t" "$t.bak" && echo "  kept the old $f as $f.bak"
	ln -s "$REPO/config/$f" "$t"
done

echo "==> lazycode: extensions"
have=$("$CODE" --list-extensions 2>/dev/null)
grep -v -e '^#' -e '^$' "$REPO/extensions.txt" | while read -r e; do
	grep -qixF "$e" <<<"$have" || "$CODE" --install-extension "$e" >/dev/null 2>&1
done
