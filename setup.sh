#!/usr/bin/env bash
# Sets up VS Code the same way on macOS (run from hypr-mac) and Linux (run from dotfiles): installs it and the
# extensions in extensions.txt, and symlinks config/settings.json + keybindings.json into its User folder, so edits
# made in VS Code land in this repo. Windows: setup.ps1. Safe to re-run.
#
# Device-only extras (work logins, servers, extensions) live outside the repo in ~/.config/lazycode:
#   settings.json   a JSON object appended to config/settings.json; settings.json is then built, not symlinked
#   extensions.txt  more extensions to install
#   mcp.json        VS Code's MCP servers (symlinked)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/lazycode"

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
mkdir -p "$USR"

link() { # repo-file target
	[ "$(readlink "$2" 2>/dev/null)" = "$1" ] && return
	[ -e "$2" ] && mv "$2" "$2.bak" && echo "  kept the old $(basename "$2") as $(basename "$2").bak"
	ln -s "$1" "$2"
}

echo "==> lazycode: settings + keybindings into $USR"
link "$REPO/config/keybindings.json" "$USR/keybindings.json"
if [ -f "$LOCAL/settings.json" ]; then
	# both files are JSONC (comments, trailing commas), so splice them as text; later keys win in VS Code
	new=$(
		echo "// Built by ~/lazycode/setup.sh from config/settings.json + $LOCAL/settings.json: edit those and re-run."
		echo "// Changes made here are overwritten (the previous file is kept as settings.json.bak)."
		perl -0pe 's/\}\s*\z//; s/,?\s*\z/,\n/' "$REPO/config/settings.json"
		echo
		echo "  // ── device-only ($LOCAL/settings.json) ──"
		perl -0pe 's/\A\s*\{[ \t]*\n?//; s/\s*\}\s*\z//' "$LOCAL/settings.json"
		echo
		echo "}"
	)
	t="$USR/settings.json"
	if [ -L "$t" ] || [ ! -f "$t" ] || [ "$(cat "$t")" != "$new" ]; then
		[ -L "$t" ] && rm "$t"
		[ -f "$t" ] && cp "$t" "$t.bak"
		printf '%s\n' "$new" >"$t"
		echo "  built settings.json with device-only settings"
	fi
else
	link "$REPO/config/settings.json" "$USR/settings.json"
fi
[ -f "$LOCAL/mcp.json" ] && link "$LOCAL/mcp.json" "$USR/mcp.json"

echo "==> lazycode: extensions"
have=$("$CODE" --list-extensions 2>/dev/null)
cat "$REPO/extensions.txt" "$LOCAL/extensions.txt" 2>/dev/null | grep -v -e '^#' -e '^$' | while read -r e; do
	grep -qixF "$e" <<<"$have" || "$CODE" --install-extension "$e" >/dev/null 2>&1
done
