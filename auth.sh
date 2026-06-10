#!/bin/bash

set -euo pipefail

ZONE="replaceteamdtest.entrycl.net"

ZONEFILE="/etc/nsd/replaceteamdtest.entrycl.net.zone"

VALIDATION="${CERTBOT_VALIDATION}"

DOMAIN="${CERTBOT_DOMAIN}"

# _acme-challenge.<CERTBOT_DOMAIN> の形で FQDN を構築
# 例: www.replaceteamdtest.entrycl.net → _acme-challenge.www.replaceteamdtest.entrycl.net
# 例: replaceteamdtest.entrycl.net    → _acme-challenge.replaceteamdtest.entrycl.net
RECORD="_acme-challenge.${DOMAIN}."

# 念のため既存の同名TXTを削除（DOMAIN単位で限定削除）
sudo sed -i "/^_acme-challenge\\.${DOMAIN//./\\.}[[:space:]].*TXT/d" "$ZONEFILE"

# serialを+1
sudo awk 'BEGIN { changed=0 }

{
  if (!changed && $1 ~ /^[0-9]{8,10}$/) {
    $1 = $1 + 1
    changed=1
  }
  print
}' "$ZONEFILE" | sudo tee "${ZONEFILE}.tmp" > /dev/null

sudo mv "${ZONEFILE}.tmp" "$ZONEFILE"

# TXTレコードを追加（FQDN形式でドットを末尾に付ける）
echo "${RECORD} 300 IN TXT \"${VALIDATION}\"" | sudo tee -a "$ZONEFILE" > /dev/null

# ゾーンチェック
sudo nsd-checkzone "$ZONE" "$ZONEFILE"

# NSDへ反映
sudo nsd-control reload "$ZONE"

# localhostで反映確認（最大60秒待機）
for i in {1..30}; do
  if dig @localhost "${RECORD}" TXT +short | grep -q "$VALIDATION"; then
    echo "TXT record is visible on localhost."
    break
  fi
  sleep 2
done

# 外部DNS反映待ち
sleep 30
