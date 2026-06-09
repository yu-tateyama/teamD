#!/bin/bash

WAR_SRC="/tmp/dash-replace.war"
WAR_DST="/usr/local/tomcat/webapps/ROOT.war"
LOG_FILE="/usr/local/support/logs/auto-deploy.log"

# ログディレクトリの作成
mkdir -p /usr/local/support/logs

# /tmp/dash-replace.warの存在チェック
if [ ! -f "${WAR_SRC}" ]; then
  exit 0
fi

# タイムスタンプの比較
if [ "${WAR_SRC}" -nt "${WAR_DST}" ]; then

  echo "$(date) デプロイ開始: ${WAR_SRC} → ${WAR_DST}" >> ${LOG_FILE}

  # WARファイルのコピー
  cp -a ${WAR_SRC} ${WAR_DST}

  # コピーの成否確認
  if [ $? -ne 0 ]; then
    echo "$(date) [ERROR] コピー失敗" >> ${LOG_FILE}
    exit 1
  fi

  echo "$(date) デプロイ完了" >> ${LOG_FILE}

else
  echo "$(date) 更新なし。スキップ。" >> ${LOG_FILE}
fi
