# Problemas conhecidos

| Sintoma | Causa | Solução |
|---|---|---|
| `400 Native Messages supports only leading system messages` (Copilot) | O Claude Code ≥ 2.1 envia mensagens `role: system` depois do turno do usuário; o caminho nativo do FCC 6.16.15 só aceita no início | `fcc-profile patch` (promove essas mensagens ao campo `system`) e reinicie o `fcc-server`. Vale reabrir uma issue no FCC se persistir em versões novas |
| `422 ... messages.N.content.str` (NVIDIA NIM) | O *tool search* do Claude Code injeta blocos de texto em `tool_result` que a NIM rejeita | Já tratado: `fcc-profile run` define `ENABLE_TOOL_SEARCH=false` |
| `401 User not found` (OpenRouter) | Chave é *Management Key* | Crie uma **API Key** comum |
| `402 quota_exceeded` (Copilot) | Cota do plano esgotada | Aguarde a renovação ou use outro provider |
| `/model` lista ~800 modelos | Gateway discovery ligado (`fcc-claude` original do FCC) | Use o alias `fcc-claude` do kit (`fcc-profile run`) |
| Copilot "disconnected" depois de reiniciar o server | Estado de conexão do FCC | Reconecte (device login) na Admin UI |
| Alias não carregou | `.zshrc` lido só ao abrir o terminal | `source ~/.zshrc`; `type fcc-claude` |
| Effort do Claude Code ignorado | O effort é decidido pelo profile (`REASONING_*`); `fcc-profile run` define `CLAUDE_CODE_EFFORT_LEVEL=unset` | Edite o `effort` do tier no profile e rode `fcc-profile use` |

## Como o alias funciona

O Claude Code ≥ 2.1 ignora `ANTHROPIC_DEFAULT_*_MODEL_NAME` com gateway. Então o `fcc-profile run` fixa `ANTHROPIC_DEFAULT_<TIER>_MODEL` num id que contém o alias e termina com o nome do tier (`glm-5.3-NIM-opus`). O FCC roteia por substring (`fable > opus > haiku > sonnet`); palavras de tiers anteriores dentro do alias recebem um caractere invisível para não desviar a rota.
