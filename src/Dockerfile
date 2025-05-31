FROM  node:18.15.0-alpine AS base

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

FROM node:18.15.0-alpine AS production

ENV NODE_ENV=production

RUN addgroup -S devsuGroup && \
    adduser -S devsu -G devsuGroup && \
    mkdir -p /app/databases && \
    chown -R devsu:devsuGroup /app/databases

WORKDIR /app

COPY --from=base /app .

USER devsu

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 http://localhost:8000/health || exit 1

CMD ["node", "index.js"]