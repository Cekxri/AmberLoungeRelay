# Cider CC UwU ~ the cosy little container bar :3
FROM node:22-alpine

LABEL org.opencontainers.image.title="Cider CC UwU" \
      org.opencontainers.image.description="Command Code -> OpenAI / Anthropic relay" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /app

COPY package.json ./
COPY proxy.mjs ./
COPY config.json ./
COPY README.md README.zh-TW.md CHANGELOG.md CHANGELOG.zh-TW.md CONTRIBUTING.md CONTRIBUTING.zh-TW.md ./

ENV PORT=3050 \
    HOST=0.0.0.0

EXPOSE 3050

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --spider -q http://127.0.0.1:3050/health || exit 1

CMD ["node", "proxy.mjs"]
