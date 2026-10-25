#!/usr/bin/env bash
# Verificação sem rede: sintaxe + doctor offline. Para o teste real, use `fcc-profile run -p <profile> -- -p "oi"`.
set -euo pipefail
cd "$(dirname "$0")/.."
bash -n install.sh uninstall.sh tests/smoke.sh
python3 -I -m py_compile bin/fcc-profile
for f in profiles/examples/*.json; do python3 -I -c 'import json,sys; d=json.load(open(sys.argv[1])); assert "/" in d["model"] and d["tiers"]' "$f"; done
grep -rEn 'sk-or-|nvapi-|ghp_' --exclude-dir=.git --exclude=smoke.sh . && { echo "possível segredo no repo" >&2; exit 1; } || true
echo "smoke ok"
