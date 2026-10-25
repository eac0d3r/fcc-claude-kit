# Playbook

A runbook to reproduce the setup from scratch. `install.sh` does steps 1 and 2 for you; the rest is manual because it involves accounts and secrets.

## 1. Install

```bash
./install.sh --with-copilot     # drop the flag to skip the Copilot CLI
```

It installs: FCC `6.16.15` (via `uv tool`), `fcc-profile` in `~/.local/bin`, example profiles in `~/.config/fcc-profile/profiles/` (existing ones are not overwritten), Copilot CLI `1.0.83` (optional), `HOST=127.0.0.1` and the FCC patch.

## 2. Load the alias

```bash
echo 'source /path/to/fcc-claude-kit/shell/fcc.sh' >> ~/.zshrc   # or ~/.bashrc
source ~/.zshrc
type fcc-claude    # should say: alias for fcc-profile run
```

## 3. Start the server and open the Admin UI

```bash
fcc-server
```

Open http://127.0.0.1:8082/admin. (`fcc-profile run` also starts the server in the background if it is down.)

## 4. Connect the providers (manual)

| Provider | Where to get access | Notes |
|---|---|---|
| NVIDIA NIM | build.nvidia.com -> API key | paste it in Providers -> NVIDIA NIM |
| OpenRouter | openrouter.ai/keys -> **Create API Key** | do **not** use a *Management Key*: it lists models but inference returns `401 User not found` |
| GitHub Copilot | Providers -> GitHub Copilot -> Connect (device login) | needs Copilot CLI **1.0.83** in PATH; never run `copilot update`; needs an active plan/quota |

## 5. Activate a profile and validate

```bash
fcc-profile list
fcc-profile use nvidia-free
fcc-profile doctor
cd /some/project && echo hi > probe.txt
fcc-claude -- -p "Use Read on probe.txt and answer with its content only" --model sonnet --allowedTools Read
```

The real model name (e.g. `glm-5.3-flash-NIM-sonnet`) appears in the Claude Code header.

## 6. Maintenance

- Upgraded FCC (`uv tool upgrade` / `fcc-update`)? Run `fcc-profile patch --check`; if it fails, run `fcc-profile patch`. If it reports "incompatible", the FCC version changed: review `PATCH_OLD`/`PATCH_NEW` in `bin/fcc-profile`.
- Changed `VERSIONS`? Run `tests/smoke.sh` and a real `fcc-claude` call per provider.
- A model disappeared from the catalog? `fcc-profile doctor` flags it; `fcc-profile models <term>` shows the current ones.
