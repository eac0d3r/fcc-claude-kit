#!/usr/bin/env bash
# Remove FCC, o symlink do fcc-profile e o patch. Mantém ~/.fcc e seus profiles, salvo com --purge.
# Uso: ./uninstall.sh [--purge]
set -euo pipefail
PURGE=0; [ "${1:-}" = "--purge" ] && PURGE=1
command -v fcc-profile >/dev/null && fcc-profile patch --revert 2>/dev/null || true
pkill -f fcc-server 2>/dev/null || true
command -v uv >/dev/null && uv tool uninstall free-claude-code || true
rm -f "$HOME/.local/bin/fcc-profile"
if [ "$PURGE" -eq 1 ]; then
  echo "removendo ~/.fcc (inclui chaves de API) e ~/.config/fcc-profile"
  rm -rf "$HOME/.fcc" "$HOME/.config/fcc-profile"
fi
echo "Pronto. Remova a linha 'source .../shell/fcc.sh' do seu rc. O Copilot CLI não foi tocado (npm uninstall -g @github/copilot)."
