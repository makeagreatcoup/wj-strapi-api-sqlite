# 使用官方Node.js镜像作为基础镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 增加Node.js堆大小限制
ENV NODE_OPTIONS=--max-old-space-size=4096

# 复制package.json和package-lock.json（或npm-shrinkwrap.json）以便安装依赖
COPY package*.json ./


# 安装依赖包
RUN npm config set registry https://registry.npmmirror.com
RUN npm config set strict-ssl false

RUN npm i --legacy-peer-deps

# 将当前目录内容复制到容器的工作目录中
COPY . .

# 如果项目使用TypeScript，则添加编译步骤
RUN npm run build

# 清理不必要的文件，尤其是开发依赖
# RUN rm -rf node_modules && npm ci --only=production

# 暴露端口
# EXPOSE 3000
 
# 设置环境变量（如果需要）
# ENV NODE_ENV=development

# 启动应用
CMD ["npm", "run", "develop"]
