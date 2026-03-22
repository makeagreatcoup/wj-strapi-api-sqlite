# Strapi 自动备份到 Git

## 📋 功能

简单自动备份方案：
1. 检查 `data.db` 是否变化 → 复制到 `backup/` 目录
2. 检查 `uploads` 是否变化 → 打包成 `backup/uploads.zip`
3. 自动提交到 Git 并推送

## 🚀 使用方法

### 直接运行

```bash
# 在项目根目录
bash scripts/auto-commit.sh
```

### 配置定时任务

```bash
# 编辑 crontab
crontab -e

# 添加定时任务（例如每30分钟）
*/30 * * * * cd /你的项目路径 && bash scripts/auto-commit.sh >> /var/log/strapi-backup.log 2>&1
```

## 📁 目录结构

```
wj-strapi-api/
├── data/
│   └── data.db              # 原始数据库（不在 Git 中）
├── public/
│   └── uploads/             # 原始上传文件（不在 Git 中）
├── backup/                  # 备份目录（会提交到 Git）⭐
│   ├── data.db              # 数据库备份
│   ├── uploads.zip          # 上传文件压缩包
│   ├── data.db.md5          # 数据库变化标记
│   └── uploads.md5          # 上传文件变化标记
├── .gitignore               # 确保不包含 backup/
└── scripts/
    ├── auto-commit.sh       # 主备份脚本
    └── setup-auto-backup.sh # 设置脚本
```

**重要**：`backup/` 目录必须**提交到 Git**，不要添加到 `.gitignore`！

## 🔍 工作原理

```bash
1. 比较 MD5 值判断文件是否变化
   ↓
2. 有变化 → 复制/打包到 backup/
   ↓
3. git add backup/
4. git commit -m "Auto backup: 时间"
5. git push
```

## 📊 日志

```bash
# 查看日志（如果配置了）
tail -f /var/log/strapi-backup.log

# 或直接查看输出
bash scripts/auto-commit.sh
```

## ⚙️ 自定义配置

编辑 `scripts/auto-commit.sh`：

```bash
# 修改提交信息
COMMIT_MSG="你的提交信息"

# 修改备份目录
BACKUP_DIR="$PROJECT_DIR/backup"
```

## 🛑 停止自动备份

```bash
# 编辑 crontab
crontab -e

# 删除包含 auto-commit.sh 的那一行
# 保存退出
```

## 💡 注意事项

1. **首次运行**会备份所有文件
2. **只在变化时**才会提交到 Git
3. ⭐ `backup/` 目录需要提交到 Git，**不要添加到 `.gitignore`**

### ⚠️ .gitignore 配置

确保 `.gitignore` 中**不要**包含 `backup/`：

```bash
# 检查 .gitignore
cat .gitignore | grep backup

# 如果有，请删除这一行
sed -i '/^backup\/$/d' .gitignore
```

## 🔧 故障排查

### 查看详细错误

```bash
# 手动运行查看详细输出
bash scripts/auto-commit.sh
```
