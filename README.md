# fcc-claude-kit

Claude Code CLI com **dois modos** no mesmo computador:

- `claude` — padrão, usando sua assinatura Anthropic. Este kit não o altera.
- `fcc-claude` — o mesmo Claude Code roteado pelo [Free Claude Code (FCC)](https://github.com/alishahryar1/free-claude-code) para **NVIDIA NIM**, **OpenRouter** e **GitHub Copilot**, com **profiles** de modelos.

Só o Claude Code CLI é usado como harness (nada de Codex, Aider, OpenCode…).

> Projeto independente. Não é afiliado nem endossado pela Anthropic nem pelo FCC. O FCC é AGPL-3.0 e **não** é distribuído aqui: o `install.sh` o baixa do PyPI numa versão fixada.

## O que o kit adiciona ao FCC

| Recurso | Como |
|---|---|
| Profiles (criar, listar, editar, excluir, ativar) | `fcc-profile new/list/show/edit/rm/use/current` |
| Modelo por tier (fable, opus, sonnet, haiku) + effort | campos `model` e `effort` de cada tier |
| Alias com o nome do modelo real | aparece no cabeçalho, statusline e `/model` do Claude Code |
| `/model` enxuto (sem os ~800 modelos do catálogo) | `fcc-claude` desliga o gateway discovery |
| Compatibilidade Copilot + Claude Code recente | `fcc-profile patch` (ver [TROUBLESHOOTING](docs/TROUBLESHOOTING.md)) |
| Diagnóstico | `fcc-profile doctor` |

## Instalação

Pré-requisitos: macOS ou Linux, `uv`, `python3`, `curl`, Claude Code; `npm` só se usar Copilot.

```bash
git clone <URL-deste-repo> fcc-claude-kit && cd fcc-claude-kit
./install.sh --dry-run            # veja o que será feito
./install.sh [--with-copilot]
```

Depois siga o [PLAYBOOK](docs/PLAYBOOK.md): carregar o alias, cadastrar as chaves na Admin UI do FCC e ativar um profile.

## Uso

```bash
fcc-profile list
fcc-profile use nvidia-free
fcc-claude                              # Claude Code via FCC com o profile ativo
fcc-claude -p openrouter-free           # escolhe e ativa outro profile
fcc-claude -p nvidia-free -- --model haiku   # args do claude depois de --
```

Criar um profile (`SPEC` = `provider/modelo[@effort][=alias]`; effort padrão `high`):

```bash
fcc-profile models glm                  # ids disponíveis no catálogo do FCC
fcc-profile new meu --model nvidia_nim/z-ai/glm-5.3 \
  --sonnet nvidia_nim/z-ai/glm-5.3-flash --haiku nvidia_nim/nvidia/nemotron-3.5-super-vl-120b-a12b
```

`fable` repete o `opus` quando não informado. Os profiles ficam em `~/.config/fcc-profile/profiles/*.json` (sem segredos).

## Segurança e privacidade

- Chaves de API ficam só em `~/.fcc/.env` (criado pelo FCC). Este repo nunca as guarda.
- O FCC escuta em `0.0.0.0` por padrão; `fcc-profile init` fixa `HOST=127.0.0.1`.
- Com os providers, o código do seu projeto é enviado a terceiros; free tiers podem usá-lo para treino.
- Um único server FCC atende todas as sessões: `fcc-profile use` troca o profile para todas as abertas.

## Desinstalar

`./uninstall.sh` (mantém suas chaves e profiles) ou `./uninstall.sh --purge` (apaga `~/.fcc`).

## Licença

MIT (veja `LICENSE`). O FCC mantém sua própria licença (AGPL-3.0).
