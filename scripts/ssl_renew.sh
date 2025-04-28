#!/bin/bash
# 必须在项目根目录执行

set -eo pipefail

# 获取脚本所在绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

# 定义关键参数
DOMAIN="ca.chanchun.net"
LOG_FILE="$PROJECT_ROOT/logs/ssl_renew.log"
LOCK_FILE="$PROJECT_ROOT/logs/ssl_renew.lock"

# 创建日志目录
mkdir -p "$PROJECT_ROOT/logs"

# 记录带时间戳的日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 尝试加锁，防止脚本重复运行
exec 200>"$LOCK_FILE"
flock -n 200 || { log "已有另一个续期任务正在运行，退出"; exit 1; }

log "开始证书续期流程"

# Step 1: 进入项目目录
cd "$PROJECT_ROOT" || exit 1

# Step 2: 执行证书续期
docker-compose run --rm -v "${PROJECT_ROOT}/nginx.conf:/etc/nginx/nginx.conf:ro" certbot renew --webroot -w /var/www/html --quiet --post-hook "echo 触发Nginx重载" >> "$LOG_FILE" 2>&1

# Step 3: 重载Nginx配置
docker-compose exec -T web nginx -s reload >> "$LOG_FILE" 2>&1
log "Nginx配置已重载"

log "流程完成"
