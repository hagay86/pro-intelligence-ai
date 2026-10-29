# Runs Maven anywhere that runs containers (Render, Fly.io, Railway, a VPS…)
FROM node:22-slim
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund
COPY server.js ./
COPY public ./public
ENV NODE_ENV=production \
    PORT=3000 \
    DATA_DIR=/data \
    AI_MODE=api
RUN mkdir -p /data
VOLUME ["/data"]
EXPOSE 3000
CMD ["node", "--experimental-sqlite", "server.js"]
