#!/bin/bash

################################################################################
# Strapi 自动备份和提交脚本
# 功能：检查 data.db 和 uploads 变化，自动备份并提交到 Git
################################################################################

# ==================== 配置区 ====================

# 自动获取项目目录（脚本所在目录的父目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

DB_FILE="$PROJECT_DIR/data/data.db"
UPLOAD_DIR="$PROJECT_DIR/public/uploads"
BACKUP_DIR="$PROJECT_DIR/backup"

COMMIT_MSG="Auto backup: $(date '+%Y-%m-%d %H:%M:%S')"

# ==================== 函数定义 ====================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 检查文件变化
check_changes() {
    local has_changes=0

    # 创建备份目录
    mkdir -p "$BACKUP_DIR"

    # 检查数据库文件
    if [ -f "$DB_FILE" ]; then
        local current_md5=$(md5sum "$DB_FILE" | awk '{print $1}')
        local md5_file="$BACKUP_DIR/data.db.md5"

        if [ -f "$md5_file" ]; then
            local last_md5=$(cat "$md5_file")
            if [ "$current_md5" != "$last_md5" ]; then
                log "📦 检测到数据库变化"
                cp "$DB_FILE" "$BACKUP_DIR/data.db"
                echo "$current_md5" > "$md5_file"
                has_changes=1
            fi
        else
            log "📦 首次备份数据库"
            cp "$DB_FILE" "$BACKUP_DIR/data.db"
            echo "$current_md5" > "$md5_file"
            has_changes=1
        fi
    fi

    # 检查上传文件
    if [ -d "$UPLOAD_DIR" ]; then
        local current_md5=$(find "$UPLOAD_DIR" -type f -exec md5sum {} \; 2>/dev/null | md5sum | awk '{print $1}')
        local md5_file="$BACKUP_DIR/uploads.md5"

        if [ -f "$md5_file" ]; then
            local last_md5=$(cat "$md5_file")
            if [ "$current_md5" != "$last_md5" ]; then
                log "📁 检测到上传文件变化"
                cd "$UPLOAD_DIR"
                zip -r "$BACKUP_DIR/uploads.zip" . -x "*.gitkeep" -x "*.DS_Store" >/dev/null
                echo "$current_md5" > "$md5_file"
                has_changes=1
            fi
        else
            log "📁 首次备份上传文件"
            cd "$UPLOAD_DIR"
            zip -r "$BACKUP_DIR/uploads.zip" . -x "*.gitkeep" -x "*.DS_Store" >/dev/null
            echo "$current_md5" > "$md5_file"
            has_changes=1
        fi
    fi

    return $has_changes
}

# 提交到 Git
commit_to_git() {
    log "📤 提交到 Git..."

    cd "$PROJECT_DIR"

    # 添加备份文件
    git add backup/

    # 检查是否有变化
    if git diff --cached --quiet; then
        log "✅ 没有新的变化需要提交"
        return 0
    fi

    # 提交
    git commit -m "$COMMIT_MSG"

    # 推送
    log "🚀 推送到远程仓库..."
    git push

    log "✅ 提交完成"
}

# ==================== 主程序 ====================

main() {
    log "=========================================="
    log "🔄 Strapi 自动备份检查"
    log "=========================================="

    if check_changes; then
        commit_to_git
    else
        log "✅ 没有检测到变化"
    fi

    log "=========================================="
}

# 执行
main
