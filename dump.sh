#!/bin/bash


# 各種変数の定義（変更が必要な場合はここだけ修正する）
DUMP_DIR="/usr/local/dump/backup"
LOG_FILE="/usr/local/dump/dump.log"
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="dash_replace"
DB_USER="postgres"
DUMP_FILE="${DUMP_DIR}/hr_dash_$(date +%Y%m%d).dmp"

# ダンプ出力先ディレクトリが存在しない場合は作成
mkdir -p ${DUMP_DIR}

# 開始時刻をログに追記（>>: 追記　>: 上書き）
start_time=$(date +%s)
echo "$(date) dump開始" >> ${LOG_FILE}

# pg_dumpでデータベースをバックアップ
# --dbname: 接続先URL（パスワードは.pgpassから自動取得）
# -F c: カスタム形式（pg_restoreでリストア可能なバイナリ形式）
# -f: 出力先ファイルパス
/usr/bin/pg_dump \
  --dbname=postgresql://${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_NAME} \
  -F c \
  -f ${DUMP_FILE}

# 経過時間を計算してログに追記
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "$(date) dumpにかかった時間: ${elapsed_time} 秒" >> ${LOG_FILE}

# 世代管理：30日以上前のダンプファイルを自動削除
# -mtime +30: 最終更新から30日以上経過したファイル
find ${DUMP_DIR} -name "hr_dash_*.dmp" -mtime +30 -delete
echo "$(date) 古いダンプファイルを削除しました" >> ${LOG_FILE}
