# 版本紀錄 :3

每一杯的配方，按時間排列。本專案遵循 [Semantic Versioning](https://semver.org/)。

**English version: [CHANGELOG.md](CHANGELOG.md)**

## [1.0.0] — 2026-09-12

**Cider CC UwU** 的第一個公開版本，是
[MAXeaglet/commandcode-proxy](https://github.com/MAXeaglet/commandcode-proxy) 的重度修補分支。

### 新增

- **工具 namespace 橋接。** 把 namespace 工具宣告（`{"type":"namespace", ...}`）展開成扁平 function
  工具送上上游，並在回傳時把 `namespace` 欄位補回去，讓新版 Codex App 的 MCP 工具（以及透過
  `node_repl`／`@oai/sky` 的 Computer Use）真的能執行。
- **內建 `web_search` / `web_fetch`。** 代理注入這兩個工具，並以 Command Code 自己的
  `/alpha/web-search` 與 `/alpha/web-fetch` 執行，再把結果餵回模型。迴圈深度以 `CC_MAX_WEB_ROUNDS` 控制。
- **殘缺歷史修補。** 沒有對應結果的工具呼叫（回合被中斷）會補上一筆說明，孤兒工具結果則丟棄，
  讓被卡死的對話能繼續。
- **圖片型工具結果。** 工具輸出裡的圖片會以真正的圖片重送，不再用一大坨 base64 撐爆上下文。
- **思考等級收斂。** `ultra` → `max`，`minimal`／`none`／`off` → `low`，無法識別的值直接丟棄。
- **Anthropic 端點支援圖片**（base64 與 URL，含 tool result 內的圖片）。
- **`tool_choice: "none"` 處理**，相容上游較嚴格的驗證。
- **執行期開關：** `CC_SEND_NAMESPACE_FIELD`、`CC_REJECT_NAMESPACE_TOOLS`、`CC_NAMESPACE_ALIAS_PROBE`、
  `CC_MAX_TOOL_OUTPUT_CHARS`、`CC_MAX_WEB_ROUNDS`。
- **Windows 輔助腳本**（`scripts/*.cmd`），停止腳本會找出真正佔用埠的進程。
- **English UK ＋ 繁體中文文件。**

### 修正

- 超長工具輸出不再撐爆上游上下文（可設定截斷上限）。
- 多工具回合中的圖片不再把工具結果群組切斷（那會讓上游回報 `Tool results are missing for tool calls ...`）。
- 只因 completion 預算而超限的情況，會自動降低 `max_tokens` 重試一次。
- 停止腳本改為殺掉真正佔用連接埠的進程，而不是信任可能過期的 PID 檔。

### 備註

- `tool_search` 刻意不實作；工具現在都直接提供。
- 代理維持無狀態 —— `previous_response_id` 會刻意拒絕。

## [0.x] — 早期

本分支之前的一切：MAXeaglet 的原始 `commandcode-proxy`。謝謝那間酒吧。UwU
