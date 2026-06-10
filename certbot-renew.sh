#!/bin/bash
LOG_TAG="certbot"

logger -t "$LOG_TAG" "===== Certbot renewal started ====="

certbot renew --quiet 2>&1 | logger -t "$LOG_TAG"

RESULT=${PIPESTATUS[0]}

if [ $RESULT -eq 0 ]; then
    logger -t "$LOG_TAG" "Certificate renewal completed successfully"
else
    logger -t "$LOG_TAG" "Certificate renewal failed (exit code: $RESULT)"
fi

logger -t "$LOG_TAG" "===== Certbot renewal finished ====="
