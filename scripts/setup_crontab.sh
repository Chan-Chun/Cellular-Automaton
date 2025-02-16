#!/bin/bash
# 在项目根目录执行此脚本

# 获取项目根目录
PROJECT_ROOT=$(pwd)

# 生成crontab条目
CRON_JOB="0 3 * * * cd $PROJECT_ROOT && ./scripts/ssl_renew.sh"

# 检查是否已存在任务
if ! crontab -l | grep -q "$CRON_JOB"; then
    # 添加到当前用户的crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "定时任务已添加"
else
    echo "定时任务已存在，无需重复添加"
fi

# 设置脚本可执行权限
chmod +x "$PROJECT_ROOT/scripts/ssl_renew.sh"
