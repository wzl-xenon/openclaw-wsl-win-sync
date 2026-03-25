#!/bin/bash
# Cross-instance conversation between WSL and Windows OpenClaw
# Usage: cross-talk.sh <local-port> <remote-host> <remote-port> <remote-token>

set -euo pipefail

LOCAL_PORT="${1:-18790}"
REMOTE_HOST="${2:-127.0.0.1}"
REMOTE_PORT="${3:-18789}"
REMOTE_TOKEN="${4:-}"

CONV_FILE="cross-conversation.md"
LAST_LINE=0

echo "=== OpenClaw Cross-Instance Conversation ==="
echo "Local: port $LOCAL_PORT"
echo "Remote: $REMOTE_HOST:$REMOTE_PORT"
echo "Conversation file: $CONV_FILE"
echo ""

# Check if conversation file exists
if [ ! -f "$CONV_FILE" ]; then
    echo "Creating new conversation file..."
    cat > "$CONV_FILE" << EOF
# Cross-Instance Conversation between WSL and Windows

EOF
    LAST_LINE=0
fi

# Count lines to check for new messages
TOTAL_LINES=$(wc -l < "$CONV_FILE")

if [ "$TOTAL_LINES" -le "$LAST_LINE" ]; then
    echo "No new messages from remote."
    exit 0
fi

# If there are new messages, extract the last one and send to local agent
# For now, just report new messages
echo "Found $((TOTAL_LINES - LAST_LINE)) new lines."
echo ""
tail -n +$((LAST_LINE + 1)) "$CONV_FILE"

exit 0
