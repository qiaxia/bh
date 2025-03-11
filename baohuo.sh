#!/bin/sh

# 设置 Telegram 机器人信息
TELEGRAM_BOT_TOKEN="717G5XrZ9s"
CHAT_ID="66933"

# 发送 Telegram 消息的函数
send_telegram_message() {
    message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message"
}

# 获取当前系统信息
HOSTNAME=$(hostname)
USER=$(whoami)
TIME=$(date '+%Y-%m-%d %H:%M:%S')

# 检查是否有 nezha-dashboard 进程在运行
if ! pgrep -f "sing-box" > /dev/null; then
    echo "进程未运行，启动中..."
    
    # 转到用户主目录
    cd ~/sb2
    
    # 启动 s9.sh
    nohup /
    
    echo "dashboard 已启动"

    # 仅当启动了 `s8.sh` 才发送 Telegram 通知
    message="Serv00-play通知  🖥️ 主机：$HOSTNAME  👤 用户：$USER  ⏰ 时间：$TIME  📢 通知内容：节点 重启成功."
    send_telegram_message "$message"
else
    echo "nezha-dashboard 进程正在运行，未重启"
fi
