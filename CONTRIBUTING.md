# Contributing ~ pull up a stool :3

Ta for wanting to help. A few house rules keep the bar tidy.

**Traditional Chinese version: [CONTRIBUTING.zh-TW.md](CONTRIBUTING.zh-TW.md)**

## Language

- **English (UK) first.** Colour, licence, behaviour, customise, organise. The source comments and the
  main `README.md` are written that way.
- **Traditional Chinese (Taiwan) second.** User-facing docs live in `README.zh-TW.md`; keep the two in
  step when you change behaviour.

## Getting set up

```bash
git clone https://github.com/Cekxri/CiderCC-UwU.git
cd CiderCC-UwU
npm start          # no install step — there are no dependencies
```

Handy checks before you push:

```bash
node --check proxy.mjs                # syntax
curl http://127.0.0.1:3050/health     # the bar is open
curl http://127.0.0.1:3050/v1/models  # model list
```

## What we are careful about

- **Never log secrets.** No API keys, no key fragments, no error bodies, no stack traces in `logs/`.
  If you add a log line, keep it to names, sizes and status codes.
- **Privacy by default.** Prompt content must not end up in the log file.
- **Keep it dependency-free.** `proxy.mjs` is the whole product; "no npm install" is a feature.
- **Don't break the wire.** The protocol details in `docs/tool-namespaces.md` were hard-won; if you change
  how tools are translated, say so in the pull request and update that document.
- **Config stays compatible.** New toggles should be environment variables with sane defaults, so existing
  `config.json` files keep working.

## Commit messages

Short and descriptive, present tense. The occasional `:3` is welcome.

## Testing your change

1. `node --check proxy.mjs`
2. Start the relay and hit `/health`.
3. Exercise the endpoint you touched (`/v1/chat/completions`, `/v1/messages` or `/v1/responses`).
4. If you touched tools, watch the log lines: `Tool entries (kept vs ignored)`, `CC tool history`,
   `Executed internal web tools`, `Repaired incomplete tool history`.

## Licensing

By contributing you agree that your work is licensed under the MIT Licence and may be attributed to this
project. The original work belongs to
[MAXeaglet/commandcode-proxy](https://github.com/MAXeaglet/commandcode-proxy) — keep that credit intact. UwU
