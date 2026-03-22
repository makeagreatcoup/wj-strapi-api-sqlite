# 使用官方Node.js镜像作为基础镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 增加Node.js堆大小限制
ENV NODE_OPTIONS=--max-old-space-size=4096

# 先只复制 package 文件（利用 Docker 缓存）
COPY package*.json ./

# 配置 npm 镜像并安装依赖
RUN npm config set registry https://registry.npmmirror.com && \
    npm config set strict-ssl false && \
    npm ci --legacy-peer-deps

# 复制项目代码（只在代码变化时重新构建）
COPY . .

# 构建项目
RUN npm run build

# 暴露端口
# EXPOSE 3000

# 启动应用
CMD ["npm", "run", "develop"]
