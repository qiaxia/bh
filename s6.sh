#!/bin/sh

INPUT_FILE="proxies.txt"
OUTPUT_FILE="valid_proxies.txt"
TEST_URL="https://google.com/"
THREADS=50
TG_CHAT_ID="6011866933"
TG_BOT_TOKEN="7172063031:AAE6UAxmLqVYW6-TUNSvoOzNG5XrZ9s"

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

TEMP_FILE=$(mktemp /tmp/proxies.XXXXXX)

PROXIES=()
while IFS= read -r line; do
    PROXIES+=("$line")
done < "$INPUT_FILE"

check_proxy() {
    proxy=$1
    if curl -s --max-time 10 --socks5-hostname "$proxy" "$TEST_URL" > /dev/null; then
        echo "${GREEN}[✔] 可用: $proxy${RESET}"
        echo "$proxy" >> "$TEMP_FILE"
    else
        echo "${RED}[✖] 不可用: $proxy${RESET}"
    fi
}

export TEST_URL TEMP_FILE GREEN RED RESET

pkg info parallel > /dev/null 2>&1 || pkg install -y parallel
printf "%s\n" "${PROXIES[@]}" | parallel -j $THREADS check_proxy {}

mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "验证完成，可用代理已保存至 $OUTPUT_FILE"

curl -F "chat_id=$TG_CHAT_ID" -F "document=@$OUTPUT_FILE" "https://api.telegram.org/bot$TG_BOT_TOKEN/sendDocument"

echo "已发送 $OUTPUT_FILE 至 Telegram"
