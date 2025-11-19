#!/bin/sh
set -e

# 检查 HTTP_PORT 是否设置，否则默认为 80
if [ -z "$HTTP_PORT" ]; then
  echo "--> HTTP_PORT not set, defaulting to 80"
  TARGET_PORT=80
else
  echo "--> HTTP_PORT is set to: $HTTP_PORT"
  TARGET_PORT=$HTTP_PORT
fi

# 创建一个临时文件
CONF_TMP=$(mktemp)

# 使用 awk 替换监听端口。这比 sed 更健壮。
awk -v port="$TARGET_PORT" '{gsub(/listen\s+[0-9]+;/, "listen " port ";")}1' /etc/nginx/nginx.conf > "$CONF_TMP"

# 替换原始配置文件
mv "$CONF_TMP" /etc/nginx/nginx.conf

# echo "--> Nginx configuration updated to listen on port $TARGET_PORT. New configuration:"
# echo "--------------------"
# cat /etc/nginx/nginx.conf
# echo "--------------------"

echo "--> Starting Nginx..."
# 执行传递给脚本的命令 (例如, nginx -g 'daemon off;')
exec "$@"

