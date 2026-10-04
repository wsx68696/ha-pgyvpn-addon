#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"

if [ ! -r "$OPTIONS_FILE" ]; then
    echo "找不到 Home Assistant 配置文件：$OPTIONS_FILE" >&2
    exit 1
fi

PGY_USERNAME="$(jq -er '.username | strings | select(length > 0)' "$OPTIONS_FILE")" || {
    echo "请在 Add-on 配置中填写蒲公英账号或 UID。" >&2
    exit 1
}
PGY_PASSWORD="$(jq -er '.password | strings | select(length > 0)' "$OPTIONS_FILE")" || {
    echo "请在 Add-on 配置中填写蒲公英密码。" >&2
    exit 1
}
export PGY_USERNAME PGY_PASSWORD

if [ ! -c /dev/net/tun ]; then
    echo "容器内未找到 /dev/net/tun；请确认 HAOS 内核启用了 TUN 设备。" >&2
    exit 1
fi

# Keep the vendor client configuration and logs across app rebuilds/updates.
mkdir -p /data/pgyvpn /data/oray-log /etc/oray /var/log
if [ -d /etc/oray/pgyvpn ] && [ ! -L /etc/oray/pgyvpn ]; then
    cp -a /etc/oray/pgyvpn/. /data/pgyvpn/ 2>/dev/null || true
    rm -rf /etc/oray/pgyvpn
fi
if [ -d /var/log/oray ] && [ ! -L /var/log/oray ]; then
    cp -a /var/log/oray/. /data/oray-log/ 2>/dev/null || true
    rm -rf /var/log/oray
fi
ln -sfn /data/pgyvpn /etc/oray/pgyvpn
ln -sfn /data/oray-log /var/log/oray

if [ ! -x /usr/share/pgyvpn/script/pgystart ]; then
    echo "蒲公英客户端启动程序不存在：/usr/share/pgyvpn/script/pgystart" >&2
    exit 1
fi

echo "正在启动蒲公英客户端。账号信息不会输出到日志。"
exec /usr/share/pgyvpn/script/pgystart
