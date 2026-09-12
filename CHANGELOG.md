# Changelog :3

All the pours, in order. This project follows [Semantic Versioning](https://semver.org/).

**Traditional Chinese version: [CHANGELOG.zh-TW.md](CHANGELOG.zh-TW.md)**

## [Unreleased]

### Fixed

- **Key fragments never reach the log.** The `Fingerprint generated for key` line printed the first eight
  characters of your API key; it now prints an irreversible short hash instead. The README already promised
  this — now the code keeps the promise.
- **`logLevel` filters for real.** It was accepted and documented but never read, so every level was written;
  `error`, `warn`, `info` and `debug` now behave as documented (default `info`), and the startup line reports
  the active level.
- **Config table tells the truth.** `emptySystemPlaceholder` was missing from the `config.json` table even
  though the code honours it, and `projectSlug` / `PROJECT_SLUG` now say what they are — accepted for
  compatibility, with the slug sent upstream randomised on purpose.
- **Changelog headings render again.** A missing blank line in both changelogs had glued the `1.0.0` heading
  onto the previous list item, so GitHub swallowed it.
- **The Windows banner follows the port.** `scripts/start.cmd` printed `3050` even when `PROXY_PORT` moved the
  relay elsewhere; it now shows the port actually in use.
- **Docs and packaging accuracy.** The Docker examples used an uppercase image tag (`CiderCC-UwU:latest`),
  which Docker rejects — they now use the lowercase `cidercc-uwu:latest`.
- **UK spelling everywhere.** Internal helpers `normalize*` are now `normalise*`, matching the project's
  English (UK) convention.
- **Traditional Chinese typo.** A stray simplified character in `README.zh-TW.md` is fixed.
- **Windows scripts behave as one set.** `scripts/start.cmd` and `scripts/start-background.cmd` now honour
  `PROXY_PORT`, matching `scripts/stop.cmd`, so all three move together when you pour onto another port.
- **`scripts/stop.cmd` follows your port.** It resolves the listening port from `PROXY_PORT`, then `PORT`,
  then `config.json`, instead of assuming 3050.
- **The background launcher hands off and returns.** `scripts/start-background.cmd` now exits cleanly once the
  detached node process owns the port, so the console comes straight back.

### Added

- **Docker build in CI.** The workflow builds the image and polls `/health` inside the container, so the
  Dockerfile cannot rot unnoticed.

## [1.0.0] — 2026-09-12

First public release of **Cider CC UwU**, a heavily patched fork of
[MAXeaglet/commandcode-proxy](https://github.com/MAXeaglet/commandcode-proxy).

### Added

- **Tool-namespace bridge.** Namespace tool declarations (`{"type":"namespace", ...}`) are expanded into
  flat function tools on the way up, and the `namespace` field is restored on the way back down, so MCP
  tools (and Computer Use via `node_repl`/`@oai/sky`) actually execute in modern Codex-App clients.
- **Inline `web_search` / `web_fetch`.** The relay injects both tools and executes them against Command
  Code's own `/alpha/web-search` and `/alpha/web-fetch` routes, then feeds the results back to the model.
  Loop depth is configurable via `CC_MAX_WEB_ROUNDS`.
- **Incomplete-history repair.** Tool calls with no matching result (interrupted turns) get a synthesised
  result, and orphaned tool results are dropped, so a poisoned conversation can continue.
- **Image-aware tool results.** Image payloads inside tool output are re-sent as proper images instead of
  pages of base64, keeping the context window sane.
- **Reasoning-effort clamping.** `ultra` → `max`, `minimal`/`none`/`off` → `low`, unknown values dropped.
- **Anthropic image support** on `/v1/messages` (base64 and URL sources, including images inside tool results).
- **`tool_choice: "none"` handling** that works with the upstream's stricter validation.
- **Runtime switches:** `CC_SEND_NAMESPACE_FIELD`, `CC_REJECT_NAMESPACE_TOOLS`, `CC_NAMESPACE_ALIAS_PROBE`,
  `CC_MAX_TOOL_OUTPUT_CHARS`, `CC_MAX_WEB_ROUNDS`.
- **Windows helper scripts** (`scripts/*.cmd`) with a port-owner-aware stop.
- **UK English + Traditional Chinese (Taiwan) documentation.**

### Fixed

- Oversized tool output no longer explodes the upstream context limit (truncation with a configurable cap).
- Image parts inside a multi-tool turn no longer split the tool-result group (which made the upstream
  answer `Tool results are missing for tool calls ...`).
- Context-limit errors that are only caused by the completion budget are retried once with a smaller
  `max_tokens` instead of failing outright.
- The stop script now kills whatever actually owns the port, rather than trusting a possibly stale PID file.

### Notes

- `tool_search` is intentionally not implemented; tools are exposed directly instead.
- The relay remains stateless — `previous_response_id` is rejected on purpose.

## [0.x] — legacy

Everything before this fork: the original `commandcode-proxy` by MAXeaglet. Thank you for the bar. UwU
