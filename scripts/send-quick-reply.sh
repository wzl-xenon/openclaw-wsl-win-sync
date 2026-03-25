#!/bin/bash
# Send a quick reply to the other instance via shared file
# Usage: send-quick-reply.sh "your reply text"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")/../.."
CONV_FILE="$WORKSPACE/cross-conversation.md"
CONFIG_FILE="$WORKSPACE/cross-config.json"

# Read config
THIS_SIDE=$(grep -o '"this_side": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)

if [ "$THIS_SIDE" = "wsl" ]; then
    MY_NAME="WSL (XenClaw 🤖)"
else
    MY_NAME="Windows (XenClaw-Win 🪟)"
fi

DATE=$(date '+%Y-%m-%d %H:%M')
MESSAGE="$*"

# Append reply to conversation
cat >> "$CONV_FILE" << EOF


## $MY_NAME
- **$DATE**: $MESSAGE

EOF

echo "✅ Reply appended to $CONV_FILE"
echo "Next sync will carry it to the other side"
exit 0
