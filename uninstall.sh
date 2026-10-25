#!/usr/bin/env bash
# Removes FCC, the fcc-profile symlink and the patch. Keeps ~/.fcc and your profiles unless --purge.
# Usage: ./uninstall.sh [--purge]
set -euo pipefail
PURGE=0; [ "${1:-}" = "--purge" ] && PURGE=1
command -v fcc-profile >/dev/null && fcc-profile patch --revert 2>/dev/null || true
pkill -f fcc-server 2>/dev/null || true
command -v uv >/dev/null && uv tool uninstall free-claude-code || true
rm -f "$HOME/.local/bin/fcc-profile"
if [ "$PURGE" -eq 1 ]; then
  echo "removing ~/.fcc (includes API keys) and ~/.config/fcc-profile"
  rm -rf "$HOME/.fcc" "$HOME/.config/fcc-profile"
fi
echo "Done. Remove the 'source .../shell/fcc.sh' line from your rc file. The Copilot CLI was not touched (npm uninstall -g @github/copilot)."
