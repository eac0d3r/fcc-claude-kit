#!/usr/bin/env bash
# Instala FCC (versão fixada) + fcc-profile + patch. Idempotente. Não toca em chaves de API.
# Uso: ./install.sh [--with-copilot] [--dry-run]
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=VERSIONS
. "$KIT/VERSIONS"
WITH_COPILOT=0; DRY=0
for arg in "$@"; do
  case "$arg" in
    --with-copilot) WITH_COPILOT=1 ;;
    --dry-run) DRY=1 ;;
    -h|--help) sed -n '2,3p' "$0"; exit 0 ;;
    *) echo "opção desconhecida: $arg" >&2; exit 2 ;;
  esac
done

run() { echo "+ $*"; [ "$DRY" -eq 1 ] || "$@"; }
need() { command -v "$1" >/dev/null 2>&1 || { echo "erro: '$1' não encontrado. $2" >&2; exit 1; }; }
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]; }

echo "==> Pré-requisitos"
need curl "Instale curl."
need python3 "Instale Python 3."
need uv "Instale: https://docs.astral.sh/uv/getting-started/installation/"
need claude "Instale o Claude Code: https://claude.com/claude-code"
version_ge "$(uv --version | awk '{print $2}')" "$MIN_UV_VERSION" || { echo "erro: uv >= $MIN_UV_VERSION" >&2; exit 1; }
[ "$WITH_COPILOT" -eq 0 ] || need npm "O Copilot CLI é instalado via npm (instale Node.js)."

echo "==> FCC $FCC_VERSION"
if [ "$(uname -s)" = "Darwin" ]; then
  PY_ARGS=(--managed-python --python "$PYTHON_VERSION+gil")
else
  PY_ARGS=(--python "$PYTHON_VERSION")
fi
run env -u UV_PYTHON_PREFERENCE uv tool install --force --refresh-package free-claude-code \
  "${PY_ARGS[@]}" "free-claude-code==$FCC_VERSION"
run uv tool update-shell

echo "==> fcc-profile"
mkdir -p "$HOME/.local/bin"
run ln -sf "$KIT/bin/fcc-profile" "$HOME/.local/bin/fcc-profile"
run mkdir -p "$HOME/.config/fcc-profile/profiles"
for f in "$KIT"/profiles/examples/*.json; do
  dest="$HOME/.config/fcc-profile/profiles/$(basename "$f")"
  [ -e "$dest" ] && echo "= mantido: $dest" || run cp "$f" "$dest"
done

if [ "$WITH_COPILOT" -eq 1 ]; then
  echo "==> Copilot CLI $COPILOT_CLI_VERSION (exigido pelo FCC; não rode 'copilot update')"
  run npm install -g "@github/copilot@$COPILOT_CLI_VERSION"
fi

if [ "$DRY" -eq 0 ]; then
  export PATH="$HOME/.local/bin:$(uv tool dir --bin):$PATH"
  echo "==> Configuração segura e patch"
  fcc-profile init
  fcc-profile patch
fi

cat <<MSG

Instalado. Passos manuais (veja docs/PLAYBOOK.md):
  1. Carregue o alias:   echo 'source $KIT/shell/fcc.sh' >> ~/.zshrc   (ou ~/.bashrc)
  2. Suba o server:      fcc-server       e abra http://127.0.0.1:8082/admin
  3. Cadastre as chaves (NVIDIA NIM / OpenRouter) na Admin UI. $( [ "$WITH_COPILOT" -eq 1 ] && echo "Conecte o GitHub Copilot (device login)." )
  4. Ative um profile:   fcc-profile use nvidia-free
  5. Use:                fcc-claude
  6. Valide:             fcc-profile doctor
MSG
