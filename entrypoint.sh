#!/usr/bin/env bash
set -euo pipefail

export PATH="$PATH:/root/.local/bin:/root/.lmstudio/bin:/opt/lmstudio/bin"

echo "Starting LM Studio headless server on 0.0.0.0:1234 ..."

if command -v lms >/dev/null 2>&1; then
  exec lms server start --host 0.0.0.0 --port 1234
fi

echo "ERROR: 'lms' command not found on PATH: $PATH"
echo "The installer may have changed install location or binary name."
echo "Try: docker run --rm -it <image> bash -lc 'ls -la /root && find / -maxdepth 4 -name lms 2>/dev/null'"
exit 1