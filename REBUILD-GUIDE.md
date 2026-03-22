# Strapi 部署脚本使用指南

## 📋 两种部署方式

### 🚀 rebuild-fast.sh（推荐日常使用）

**适用场景：**
- ✅ 只修改了业务代码
- ✅ 修改了配置文件
- ✅ 修改了 Dockerfile 或 docker-compose.yml（需要使用 rebuild.sh）

**特点：**
- ⚡ 超快：30秒 - 1分钟
- 💻 不占用 CPU
- 🔄 仅重启容器，不重建镜像

**使用：**
```bash
chmod +x rebuild-fast.sh
./rebuild-fast.sh
```

---

### 🔨 rebuild.sh（完整重建）

**适用场景：**
- ✅ 修改了 `package.json` 或 `package-lock.json`
- ✅ 新增或删除了 npm 依赖
- ✅ 修改了 Dockerfile
- ✅ 第一次部署
- ✅ 遇到缓存问题

**特点：**
- 🐌 较慢：5-15 分钟
- 💻 占用 CPU 和内存
- 🔄 重新构建镜像，利用 Docker 缓存

**使用：**
```bash
./rebuild.sh
```

---

## 🎯 性能对比

| 操作 | rebuild-fast.sh | rebuild.sh（优化后）| rebuild.sh（旧版 --no-cache）|
|------|-----------------|-------------------|--------------------------|
| **代码修改** | ⚡ 30秒 | ⚡ 1-2分钟 | 🐌 10-15分钟 |
| **依赖修改** | ❌ 不适用 | ⚡ 3-5分钟 | 🐌 10-15分钟 |
| **CPU 占用** | 🟢 极低 | 🟡 中等 | 🔴 极高 |
| **网络流量** | 🟢 无 | 🟡 低（仅变化部分）| 🔴 高（全量下载）|

---

## 💡 最佳实践

### 日常开发流程

```bash
# 1. 修改代码
vim src/api/...

# 2. 快速部署
./rebuild-fast.sh

# 3. 查看日志
docker-compose logs -f strapi
```

### 添加新依赖流程

```bash
# 1. 安装依赖
npm install new-package

# 2. 完整重建
./rebuild.sh

# 3. 等待构建完成（3-5分钟）
```

---

## 🔧 已优化的改进

### Dockerfile 优化
- ✅ 合并 npm config 命令减少层数
- ✅ 使用 `npm ci` 替代 `npm i`（更快更可靠）
- ✅ 利用 Docker 层缓存（package.json 不变则不重新安装依赖）

### rebuild.sh 优化
- ✅ 移除 `--no-cache` 参数
- ✅ 从 10-15 分钟 缩短到 3-5 分钟

---

## 🎉 总结

| 情况 | 使用脚本 |
|------|----------|
| 90% 的日常修改 | `./rebuild-fast.sh` |
| 添加依赖 | `./rebuild.sh` |
| 修改 Dockerfile | `./rebuild.sh` |
| 第一次部署 | `./rebuild.sh` |

**节省时间，告别卡顿！** 🚀
