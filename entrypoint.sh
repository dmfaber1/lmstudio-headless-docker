#!/bin/bash
set -e

mkdir -p /mnt/models
mkdir -p /root/.lmstudio

SETTINGS=/root/.lmstudio/settings.json

if [ -f "$SETTINGS" ]; then
    jq '.downloadsFolder = "/mnt/models"' "$SETTINGS" > /tmp/settings.json && mv /tmp/settings.json "$SETTINGS"
else
    echo '{"downloadsFolder": "/mnt/models"}' > "$SETTINGS"
fi

lms server start --port 1234
exec tail -f /dev/null
