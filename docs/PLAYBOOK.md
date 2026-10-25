# Playbook

Roteiro para reproduzir a solução do zero. Os passos 1–2 o `install.sh` faz; o resto é manual porque envolve contas e segredos.

## 1. Instalar

```bash
./install.sh --with-copilot     # sem a flag, pula o Copilot CLI
```

Instala: FCC `6.16.15` (via `uv tool`), `fcc-profile` em `~/.local/bin`, profiles de exemplo em `~/.config/fcc-profile/profiles/` (não sobrescreve os seus), Copilot CLI `1.0.83` (opcional), `HOST=127.0.0.1` e o patch do FCC.

## 2. Carregar o alias

```bash
echo 'source /caminho/para/fcc-claude-kit/shell/fcc.sh' >> ~/.zshrc   # ou ~/.bashrc
source ~/.zshrc
type fcc-claude    # deve dizer: alias for fcc-profile run
```

## 3. Subir o server e abrir a Admin UI

```bash
fcc-server
```

Abra http://127.0.0.1:8082/admin. (O `fcc-profile run` também sobe o server sozinho em segundo plano.)

## 4. Conectar os providers (manual)

| Provider | Onde obter | Atenção |
|---|---|---|
| NVIDIA NIM | build.nvidia.com → API key | cole em Providers → NVIDIA NIM |
| OpenRouter | openrouter.ai/keys → **Create API Key** | **não** use *Management Key*: ela lista modelos mas dá `401 User not found` na inferência |
| GitHub Copilot | Providers → GitHub Copilot → Connect (device login) | exige Copilot CLI **1.0.83** no PATH; não rode `copilot update`; exige cota/plano ativo |

## 5. Ativar um profile e validar

```bash
fcc-profile list
fcc-profile use nvidia-free
fcc-profile doctor
cd /algum/projeto && echo oi > probe.txt
fcc-claude -- -p "Use Read para ler probe.txt e responda só o conteúdo" --model sonnet --allowedTools Read
```

O nome do modelo real (ex.: `glm-5.3-flash-NIM-sonnet`) aparece no cabeçalho do Claude Code.

## 6. Manutenção

- Atualizou o FCC (`uv tool upgrade`/`fcc-update`)? Rode `fcc-profile patch --check`; se falhar, `fcc-profile patch`. Se disser "incompatível", a versão mudou: revise `PATCH_OLD`/`PATCH_NEW` em `bin/fcc-profile`.
- Mudou `VERSIONS`? Rode `tests/smoke.sh` e um `fcc-claude` real por provider.
- Modelo sumiu do catálogo? `fcc-profile doctor` aponta; `fcc-profile models <termo>` mostra os atuais.
