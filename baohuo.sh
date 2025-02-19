#!/bin/sh

# 检查是否有 nezha-dashboard 进程在运行
if ! pgrep -f "nezha-dashboard" > /dev/null; then
  echo "nezha-dashboard 进程未运行，启动中..."
  
  # 切换到 nezha_app/dashboard 目录并后台启动 nezha-dashboard
  cd ~/nezha_app/dashboard || { echo "无法进入 nezha_app/dashboard 目录"; exit 1; }
  nohup ./nezha-dashboard > /dev/null 2>&1 &
  
  echo "nezha-dashboard 已启动"
else
  echo "nezha-dashboard 已在运行"
fi
