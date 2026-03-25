#!/bin/bash
# Send real-time message to the other instance via Gateway API
# Usage: send-realtime-message.sh "message text"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")/../.."
CONFIG_FILE="$WORKSPACE/cross-config.json"

# Load config
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config not found: $CONFIG_FILE"
    exit 1
fi

THIS_SIDE=$(grep -o '"this_side": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
REMOTE_PORT=$(grep -o '"remote_port": *[0-9]*' "$CONFIG_FILE" | cut -d: -f2 | tr -d ' ')
REMOTE_TOKEN=$(grep -o '"remote_token": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
REMOTE_HOST=$(grep -o '"remote_host": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
if [ -z "$REMOTE_HOST" ]; then
    REMOTE_HOST="127.0.0.1"
fi

if [ -z "$REMOTE_PORT" ] || [ -z "$REMOTE_TOKEN" ]; then
    echo "Missing remote_port or remote_token in cross-config.json"
    exit 1
fi

REMOTE_URL="http://$REMOTE_HOST:$REMOTE_PORT/api/gateway/message"

MESSAGE="$*"

# Send message via OpenClaw Gateway API
echo "Sending message to port $REMOTE_PORT..."
curl -X POST "$REMOTE_URL" \
    -H "Authorization: Bearer $REMOTE_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"message\": \"$MESSAGE\"}"

echo ""
echo "Message sent"
exit 0
