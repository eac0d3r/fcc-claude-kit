# fcc-claude-kit

Claude Code CLI with **two modes** on the same machine:

- `claude`: the stock Claude Code on your Anthropic subscription. This kit never touches it.
- `fcc-claude`: the same Claude Code routed through [Free Claude Code (FCC)](https://github.com/alishahryar1/free-claude-code) to **NVIDIA NIM**, **OpenRouter** and **GitHub Copilot**, with switchable model **profiles**.

Claude Code CLI is the only harness used (no Codex, Aider, OpenCode, etc.).

> Independent project, not affiliated with or endorsed by Anthropic or the FCC project. FCC is AGPL-3.0 and is **not** redistributed here: `install.sh` downloads a pinned version from PyPI.

## What the kit adds on top of FCC

| Feature | How |
|---|---|
| Profiles (create, list, edit, delete, activate) | `fcc-profile new/list/show/edit/rm/use/current` |
| Per-tier model (fable, opus, sonnet, haiku) + effort | `model` and `effort` fields of each tier |
| Alias showing the real model name | shown in the Claude Code header, statusline and `/model` ("currently ...") |
| Lean `/model` (no ~800-model catalog) | `fcc-claude` turns gateway model discovery off |
| Copilot + recent Claude Code compatibility | `fcc-profile patch` (see [TROUBLESHOOTING](docs/TROUBLESHOOTING.md)) |
| Diagnostics | `fcc-profile doctor` |

## Install

Requirements: macOS or Linux, `uv`, `python3`, `curl`, Claude Code; `npm` only if you use Copilot.

```bash
git clone https://github.com/eac0d3r/fcc-claude-kit.git && cd fcc-claude-kit
./install.sh --dry-run            # preview what will happen
./install.sh [--with-copilot]
```

Then follow the [PLAYBOOK](docs/PLAYBOOK.md): load the shell alias, add your API keys in the FCC Admin UI, activate a profile.

## Usage

```bash
fcc-profile list
fcc-profile use nvidia-free
fcc-claude                                   # Claude Code via FCC with the active profile
fcc-claude -p openrouter-free                # pick and activate another profile
fcc-claude -p nvidia-free -- --model haiku   # claude args go after --
```

Create a profile (`SPEC` = `provider/model[@effort][=alias]`; default effort is `high`):

```bash
fcc-profile models glm                       # model ids available in the FCC catalog
fcc-profile new mine --model nvidia_nim/z-ai/glm-5.3 \
  --sonnet nvidia_nim/z-ai/glm-5.3-flash --haiku nvidia_nim/nvidia/nemotron-3.5-super-vl-120b-a12b
```

`fable` repeats `opus` when not given. Profiles are stored in `~/.config/fcc-profile/profiles/*.json` (no secrets). Set `FCC_PROFILE_HOME` to relocate them.

## Example profiles

Each profile maps Claude Code's four tiers to real models. A tier is `{model, effort, alias}`: `model` is `provider/model-id` from the FCC catalog, `effort` is one of `inherit|client|off|low|medium|high|xhigh|max`, and `alias` is the name shown in the Claude Code header. More examples live in [`profiles/examples`](profiles/examples) and are copied to `~/.config/fcc-profile/profiles/` by `install.sh`.

**OpenRouter** (`openrouter-free.json`, free-tier models; needs a regular OpenRouter API key):

```json
{
  "model": "open_router/minimax/minimax-m3.1-flash:free",
  "effort": "high",
  "tiers": {
    "opus": {
      "model": "open_router/minimax/minimax-m3.1-flash:free",
      "effort": "high",
      "alias": "minimax-m3.1-flash:free · OR"
    },
    "sonnet": {
      "model": "open_router/nvidia/nemotron-3.5-super-vl:free",
      "effort": "high",
      "alias": "nemotron-3.5-super-vl:free · OR"
    },
    "haiku": {
      "model": "open_router/xingchen-agi/xing4.0-29b-a4b:free",
      "effort": "high",
      "alias": "xing4.0-29b-a4b:free · OR"
    },
    "fable": {
      "model": "open_router/minimax/minimax-m3.1-flash:free",
      "effort": "high",
      "alias": "minimax-m3.1-flash:free · OR"
    }
  }
}
```

**GitHub Copilot** (`copilot-claude.json`; needs Copilot CLI 1.0.83 and an active plan, see the [PLAYBOOK](docs/PLAYBOOK.md)):

```json
{
  "model": "github_copilot/claude-sonnet-5.5",
  "effort": "high",
  "tiers": {
    "opus": {
      "model": "github_copilot/claude-opus-5.5",
      "effort": "high",
      "alias": "claude-opus-5.5 · Copilot"
    },
    "sonnet": {
      "model": "github_copilot/claude-sonnet-5.5",
      "effort": "high",
      "alias": "claude-sonnet-5.5 · Copilot"
    },
    "haiku": {
      "model": "github_copilot/claude-haiku-5.5",
      "effort": "high",
      "alias": "claude-haiku-5.5 · Copilot"
    },
    "fable": {
      "model": "github_copilot/claude-opus-5.5",
      "effort": "high",
      "alias": "claude-opus-5.5 · Copilot"
    }
  }
}
```

Model availability changes over time. Check ids with `fcc-profile models <term>` and run `fcc-profile doctor` to flag profiles that point to models that no longer exist.

## Security and privacy

- API keys live only in `~/.fcc/.env` (created by FCC). This repo never stores them.
- FCC listens on `0.0.0.0` by default; `fcc-profile init` pins `HOST=127.0.0.1`.
- With these providers your project's code is sent to third parties; free tiers may use it for training.
- A single FCC server serves every session: `fcc-profile use` switches the profile for all open `fcc-claude` sessions.

## Uninstall

`./uninstall.sh` (keeps your keys and profiles) or `./uninstall.sh --purge` (deletes `~/.fcc`).

## License

MIT (see `LICENSE`). FCC keeps its own license (AGPL-3.0).
