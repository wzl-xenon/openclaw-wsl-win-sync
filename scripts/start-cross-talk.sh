#!/bin/bash
# Start cross-instance conversation check
# Must be run from workspace root

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(pwd)"
CONV_FILE="$WORKSPACE/cross-conversation.md"
CONFIG_FILE="$WORKSPACE/cross-config.json"

# Check config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚠️  config file not found: $CONFIG_FILE"
    echo "Create it with:"
    cat << EOF
{
  "this_side": "wsl",     // or "windows"
  "enabled": true
}
EOF
    exit 1
fi

# Read config
THIS_SIDE=$(grep -o '"this_side": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
ENABLED=$(grep -o '"enabled": *[^,}]*' "$CONFIG_FILE" | cut -d: -f2 | tr -d ' ')

if [ "$ENABLED" != "true" ]; then
    echo "Cross-talk is disabled in config"
    exit 0
fi

if [ "$THIS_SIDE" != "wsl" ] && [ "$THIS_SIDE" != "windows" ]; then
    echo "Invalid this_side in config: must be 'wsl' or 'windows'"
    exit 1
fi

# Determine other side
if [ "$THIS_SIDE" = "wsl" ]; then
    OTHER_SIDE="Windows (XenClaw-Win 🪟)"
    MY_NAME="WSL (XenClaw 🤖)"
else
    OTHER_SIDE="WSL (XenClaw 🤖)"
    MY_NAME="Windows (XenClaw-Win 🪟)"
fi

# Check if conversation file exists, create if not
if [ ! -f "$CONV_FILE" ]; then
    echo "Creating new conversation file..."
    cat > "$CONV_FILE" << EOF
# Cross-Instance Conversation between WSL and Windows

This is an automatic conversation between the two OpenClaw instances on this machine.

---

EOF

    # If this is WSL, start the conversation
    if [ "$THIS_SIDE" = "wsl" ]; then
        DATE=$(date '+%Y-%m-%d %H:%M')
        cat >> "$CONV_FILE" << EOF

## $MY_NAME
- **$DATE**: Hello $OTHER_SIDE! We're now set up for automatic cross-instance conversation. Every time heartbeat runs, we'll check for new messages and reply. Nice to meet you! 😊

EOF
    fi
    echo "Created new conversation file at $CONV_FILE"
    exit 0
fi

# Count lines before
LINES_BEFORE=$(wc -l < "$CONV_FILE")

# Check if last message is from other side
LAST_SENDER=$(grep "^## " "$CONV_FILE" | tail -1 | cut -d' ' -f2-)
if echo "$LAST_SENDER" | grep -q "$THIS_SIDE"; then
    echo "Last message is from me, waiting for $OTHER_SIDE to reply..."
    exit 0
fi

echo "Found new message from $OTHER_SIDE, generating reply..."
echo ""

# If we get here, it's our turn to reply
# The agent will read the conversation and generate a reply, which we append
# This script exits, agent appends the reply to the file
# Next sync will take it to the other side

echo "Please read the conversation in $CONV_FILE and append your reply as:"
echo ""
echo "## $MY_NAME"
echo "- **$(date '+%Y-%m-%d %H:%M')**: <your reply here>"
exit 0
