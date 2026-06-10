#!/bin/bash

set -euo pipefail

ZONE="replaceteamdtest.entrycl.net"

ZONEFILE="/etc/nsd/replaceteamdtest.entrycl.net.zone"

DOMAIN="${CERTBOT_DOMAIN}"

# 対象ドメインの _acme-challenge TXT レコードのみ削除
# FQDN形式（末尾ドットあり・なし両方に対応）
sudo sed -i "/^_acme-challenge\\.${DOMAIN//./\\.}\\.\\?[[:space:]].*TXT/d" "$ZONEFILE"

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

# ゾーンチェック
sudo nsd-checkzone "$ZONE" "$ZONEFILE"

# NSDへ反映
sudo nsd-control reload "$ZONE"
