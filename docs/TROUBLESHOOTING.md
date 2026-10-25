# Known issues

| Symptom | Cause | Fix |
|---|---|---|
| `400 Native Messages supports only leading system messages` (Copilot) | Claude Code >= 2.1 sends `role: system` messages after the user turn; FCC 6.16.15's native path only accepts them at the start | `fcc-profile patch` (promotes those messages to the `system` field), then restart `fcc-server`. Consider reporting upstream if it persists on newer FCC versions |
| `422 ... messages.N.content.str` (NVIDIA NIM) | Claude Code's *tool search* injects text blocks into `tool_result` that NIM rejects | Already handled: `fcc-profile run` sets `ENABLE_TOOL_SEARCH=false` |
| `401 User not found` (OpenRouter) | The key is a *Management Key* | Create a regular **API Key** |
| `402 quota_exceeded` (Copilot) | Plan quota exhausted | Wait for renewal or use another provider |
| `/model` lists ~800 models | Gateway model discovery is on (FCC's original `fcc-claude`) | Use this kit's `fcc-claude` alias (`fcc-profile run`) |
| Copilot "disconnected" after a server restart | FCC connection state | Reconnect (device login) in the Admin UI |
| Alias not found | `.zshrc` is only read when a terminal starts | `source ~/.zshrc`; check with `type fcc-claude` |
| Claude Code effort setting ignored | Effort is decided by the profile (`REASONING_*`); `fcc-profile run` sets `CLAUDE_CODE_EFFORT_LEVEL=unset` | Edit the tier's `effort` in the profile and run `fcc-profile use` |

## How the model alias works

Claude Code >= 2.1 ignores `ANTHROPIC_DEFAULT_*_MODEL_NAME` when talking to a gateway. So `fcc-profile run` pins `ANTHROPIC_DEFAULT_<TIER>_MODEL` to an id that contains the alias and ends with the tier name (`glm-5.3-NIM-opus`). FCC routes by substring (`fable > opus > haiku > sonnet`); tier words from earlier in that order that appear inside an alias get an invisible character so they do not hijack routing.
