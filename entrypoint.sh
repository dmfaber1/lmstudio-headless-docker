#!/bin/bash
set -e

mkdir -p /mnt/models
mkdir -p /root/.lmstudio

# Remap render/video group GIDs to match the host device GIDs so that
# GPU device nodes passed in via --device /dev/dri are accessible.
for dev_node in /dev/dri/renderD128 /dev/dri/card0; do
    [ -e "$dev_node" ] || continue
    DEV_GID=$(stat -c '%g' "$dev_node")
    case "$dev_node" in
        */renderD128) GROUP_NAME=render ;;
        */card0)      GROUP_NAME=video  ;;
        *)            continue ;;
    esac
    if getent group "$GROUP_NAME" > /dev/null 2>&1; then
        groupmod -g "$DEV_GID" "$GROUP_NAME" 2>/dev/null || true
    else
        groupadd -g "$DEV_GID" "$GROUP_NAME" 2>/dev/null || true
    fi
    usermod -aG "$GROUP_NAME" root 2>/dev/null || true
done

# Re-exec with updated groups so lms inherits render/video GIDs
if [ -z "$GROUPS_REFRESHED" ]; then
    export GROUPS_REFRESHED=1
    exec su -s /bin/bash root -c "PATH=$PATH exec $0 $*"
fi

SETTINGS=/root/.lmstudio/settings.json

if [ -f "$SETTINGS" ]; then
    jq '.downloadsFolder = "/mnt/models"' "$SETTINGS" > /tmp/settings.json && mv /tmp/settings.json "$SETTINGS"
else
    echo '{"downloadsFolder": "/mnt/models"}' > "$SETTINGS"
fi

lms server start --port 1234
exec tail -f /dev/null
