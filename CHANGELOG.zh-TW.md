# 版本紀錄 :3

每一杯的配方，按時間排列。本專案遵循 [Semantic Versioning](https://semver.org/)。

**English version: [CHANGELOG.md](CHANGELOG.md)**

## [Unreleased]

### 修正

- **上游把串流切斷時，不再回報成功。** 以前即使上游沒送結尾的 `finish` 事件就斷線，代理照樣回
  `response.completed`，導致「輸出到一半卻沒有任何錯誤」。現在會記下 `Upstream stream ended without finish`，
  而且只要已經輸出過文字，就會送出 `error` 事件讓使用者看得見；每一輪的結束原因（`stop`、`length`…）也會寫進日誌。
- **每次啟動都會留下日誌檔。** `scripts/start.cmd`（雙擊捷徑用的那支）原本只把輸出留在視窗裡，關掉就沒了；
  現在兩支啟動腳本都會預設把 `LOG_FILE` 指到 `logs/relay.log`（你自己有設定就照你的）。
- **圖片與提示訊息不再切斷工具呼叫群組。** 同一輪呼叫多個工具時，App 會在結果之間插入 `<image_resize_notice>`
  （或圖片本身），上游就會回 `Tool results are missing for tool calls ...`，對話卡在 502。現在代理會追蹤
  這一組還沒回結果的 call id，等整組到齊才把扣住的圖片與 system/developer 提示放出去。
  （用真實 529 項歷史重現：修前 502、修後 200。）
- **金鑰片段不再進日誌。** `Fingerprint generated for key` 這行原本會印出 API key 的前八個字元，
  現在改成不可逆的短雜湊。README 早就承諾過這件事 —— 現在程式真的做到了。
- **`logLevel` 真的會過濾。** 它一直被接受、也被寫進文件，但程式從沒讀過；現在 `error`、`warn`、
  `info`、`debug` 會照文件運作（預設 `info`），啟動那行也會回報目前等級。
- **設定表照實寫。** `emptySystemPlaceholder` 明明程式有支援、卻漏在 `config.json` 表格外；
  `projectSlug`／`PROJECT_SLUG` 也改成照實描述 —— 只為相容而保留，送上上游的 slug 是刻意隨機化的。
- **CHANGELOG 標題重新渲染。** 兩份 CHANGELOG 都少了一個空行，害 `1.0.0` 標題被前一條清單吃掉，
  GitHub 上根本看不到那個標題。
- **Windows 橫幅會跟著埠跑。** `scripts/start.cmd` 之前即使 `PROXY_PORT` 換了埠、橫幅還是印 `3050`；
  現在會顯示實際使用的埠。
- **文件與封裝正確性。** Docker 範例用了大寫 image tag（`CiderCC-UwU:latest`），Docker 會直接拒絕；
  已改為小寫 `cidercc-uwu:latest`。
- **統一英式拼字。** 內部函式 `normalize*` 更名為 `normalise*`，符合本專案的 English (UK) 慣例。
- **繁中錯字。** `README.zh-TW.md` 裡混入的簡體字已修正。
- **Windows 三支腳本行為一致。** `scripts/start.cmd` 與 `scripts/start-background.cmd` 現在也認
  `PROXY_PORT`，跟 `scripts/stop.cmd` 對齊；要換到別的埠時三個會一起移動。
- **`scripts/stop.cmd` 會跟著你的埠。** 它依序從 `PROXY_PORT`、`PORT`、`config.json` 解析出真正
  在監聽的埠，不再寫死 3050。
- **背景啟動器交棒後就返回。** `scripts/start-background.cmd` 把 node 交給背景行程後會乾淨結束，
  主控台會立刻回到你手上。

### 新增

- **說清楚反代「不擁有」什麼。** `docs/tool-namespaces.md` 現在解釋 `tool_search` 是客戶端工具、反代不維護
  任何工具清單（App 之後的工具變動會自動透傳），以及真正需要改反代的三種情況。
- **CI 會建 Docker 映像。** 工作流程會建置映像並在容器內輪詢 `/health`，Dockerfile 不會悄悄爛掉。

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
