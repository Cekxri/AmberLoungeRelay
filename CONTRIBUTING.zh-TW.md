# 貢獻指南 ~ 拉張椅子坐下吧 :3

謝謝你想幫忙。幾條簡單的規矩讓吧檯保持乾淨。

**English version: [CONTRIBUTING.md](CONTRIBUTING.md)**

## 語言

- **以 English (UK) 為主。** colour、licence、behaviour、customise、organise —— 原始碼註解與主要
  `README.md` 都採這個風格。
- **繁體中文（臺灣）為第二語言。** 使用者文件放在 `README.zh-TW.md`；行為有變動時請讓兩份同步。

## 環境設定

```bash
git clone https://github.com/Cekxri/CiderCC-UwU.git
cd CiderCC-UwU
npm start          # 不需要安裝步驟 —— 沒有任何相依套件
```

推送前的好用檢查：

```bash
node --check proxy.mjs                # 語法
curl http://127.0.0.1:3050/health     # 酒吧有開
curl http://127.0.0.1:3050/v1/models  # 模型清單
```

## 我們在意的事

- **不要在日誌裡留下祕密。** 日誌不出現 API key、key 片段、錯誤內容或 stack trace。
  新增日誌時只記名稱、大小與狀態碼。
- **預設即隱私。** 提示詞內容不應該落進日誌檔。
- **保持零依賴。** `proxy.mjs` 就是整個產品，「不用 npm install」是特色。
- **不要弄壞協定。** `docs/tool-namespaces.md` 的細節是熬夜換來的；若改動工具轉換方式，
  請在 PR 說明並同步更新該文件。
- **設定要能相容。** 新開關請用環境變數並給合理預設，讓既有 `config.json` 繼續可用。

## Commit 訊息

簡短、描述性、現在式。偶爾來個 `:3` 也很歡迎。

## 測試你的改動

1. `node --check proxy.mjs`
2. 啟動代理並打 `/health`。
3. 實際呼叫你改到的端點（`/v1/chat/completions`、`/v1/messages` 或 `/v1/responses`）。
4. 若動到工具，觀察日誌：`Tool entries (kept vs ignored)`、`CC tool history`、
   `Executed internal web tools`、`Repaired incomplete tool history`。

## 授權

送出貢獻即代表你同意以 MIT 授權釋出，並同意本專案掛名。原始作品屬於
[MAXeaglet/commandcode-proxy](https://github.com/MAXeaglet/commandcode-proxy) —— 請保留這份致謝。UwU
