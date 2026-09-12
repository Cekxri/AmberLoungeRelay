# Tool namespaces, and how this relay bridges them

A field note from the debugging sessions that produced this fork. If a tool ever answers
`unsupported call`, this is the document you want. :3

## The problem

Modern Codex-App builds changed how MCP and app tools are declared. Instead of a flat list of function
tools, they arrive as **namespaces**:

```json
{
  "type": "namespace",
  "name": "mcp__node_repl",
  "description": "Node REPL tools",
  "tools": [
    { "name": "js", "description": "Run JavaScript", "parameters": { "type": "object", "properties": {} } },
    { "name": "js_reset", "description": "Reset the JS kernel", "parameters": { "type": "object", "properties": {} } }
  ]
}
```

Two separate problems follow from that.

### 1. The upstream only accepts flat, safe names

The Command Code generation endpoint validates tool names against `^[a-zA-Z0-9_-]+$` and does not
understand the `namespace` type at all. A namespace entry has to be expanded into its sub-tools, and any
name containing characters such as `::` has to be encoded safely before it goes upstream.

### 2. The client dispatches on `name` **plus** `namespace`

When the model answers with a tool call, the client looks up its executor using both fields:

```json
{ "type": "function_call", "name": "js", "namespace": "mcp__node_repl", "call_id": "call_00_..." }
```

Send only the flat `name` and the client shrugs: every tool comes back as `unsupported call`, no matter
how creative your naming gets (`js`, `mcp__node_repl__js`, `mcp__node_repl::js` — we tried them all).
Add the `namespace` field back and they spring to life.

## What the relay does

1. **Expand.** During the inbound translation, namespace entries are walked (up to a safe depth) and each
   sub-tool becomes a flat function tool. A map of `tool name → namespace` is kept for the current request.
2. **Normalise.** Model answers are accepted in any of the shapes a model might produce: the bare `js`,
   `ns::tool`, or `ns__tool`. All of them resolve to a `(name, namespace)` pair.
3. **Restore.** Outbound `function_call` items carry the resolved `name` and `namespace`, in both the
   streaming and non-streaming paths.
4. **Stay configurable.** `CC_SEND_NAMESPACE_FIELD=0` drops the field again (for clients that stop wanting
   it), and `CC_REJECT_NAMESPACE_TOOLS=1` refuses namespace tools outright, which makes some clients fall
   back to a flat tool list.

## Web tools are a different animal

`web_search` and `web_fetch` are not provider-side tools. Command Code's own CLI executes them by calling
the service's routes:

```
POST /alpha/web-search   { "query": "...", "numResults": 5, "allowedDomains": [...], "blockedDomains": [...] }
POST /alpha/web-fetch    { "url": "https://...", "format": "markdown" }
```

So the relay plays the CLI's part: when a client asks for `web_search`, the relay injects
`web_search` **and** `web_fetch`, and — whenever the model calls one of them — executes the matching route
using the same session and fingerprint headers as generation requests, then feeds the formatted result back
as a tool message. The client never sees these internal calls; `CC_MAX_WEB_ROUNDS` (default 3) caps how
many search rounds one request may run.

## Debugging checklist

| Check | Where to look |
|---|---|
| Which tools arrived, and what was kept? | the `Tool entries (kept vs ignored)` log line |
| Which tool calls the model made | the `CC tool history` log line |
| Whether internal web tools ran | `Executed internal web tools { round, tools, chars }` |
| Whether history was repaired | `Repaired incomplete tool history { repaired, droppedOrphanResults }` |
| Upstream complaints | `CC API error` / `CC stream error event` lines |

Pull up a stool, set `logLevel` to `info`, and the story is all there. :3
