# Strapi CMS Dockerfile
# 请将此文件放到 Strapi 项目的根目录

# 阶段 1: 依赖安装
FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# 复制 package 文件
COPY package.json package-lock.json* ./

# 安装依赖
RUN npm ci --ignore-scripts && npm cache clean --force

# 阶段 2: 构建
FROM node:20-alpine AS builder
WORKDIR /app

# 复制依赖
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 设置构建环境变量
ENV NODE_ENV=production
ENV CI=true

# 构建 Strapi（如果需要）
# RUN npm run build

# 阶段 3: 运行时
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV CI=true

# 创建非 root 用户
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 strapi

# 复制 node_modules
COPY --from=builder /app/node_modules ./node_modules

# 复制项目文件
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json* ./package-lock.json* ./yarn.lock* ./
COPY --from=builder /app/config ./config
COPY --from=builder /app/src ./src
COPY --from=builder /app/public ./public
# 如果有 build 目录，复制它
# COPY --from=builder /app/build ./build
# 复制数据库文件（如果使用 SQLite）
COPY --from=builder --chown=strapi:nodejs /app/.tmp ./.tmp 2>/dev/null || true

# 创建数据目录
RUN mkdir -p .tmp && chown -R strapi:nodejs /app

# 切换用户
USER strapi

# 暴露端口
EXPOSE 1337

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:1337/admin || exit 1

# 启动 Strapi
CMD ["node", "node_modules/@strapi/strapi/bin/strapi.js"]
