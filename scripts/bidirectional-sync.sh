#!/bin/bash
# Bidirectional sync between WSL and Windows OpenClaw workspace
# Usage: bidirectional-sync.sh <wsl-workspace-path> <windows-workspace-path> [master]
# 
# If you don't pass arguments, it uses defaults below.
# Edit the DEFAULTS below to match your paths.
#
# Master mode options:
#   empty / default → bidirectional sync (default)
#   wsl → WSL is master, only sync WSL → Windows
#   windows → Windows is master, only sync Windows → WSL

set -euo pipefail

# --------------------------
# DEFAULT PATHS - EDIT ME!
# --------------------------
# Change these to match your actual installation
DEFAULT_WSL_WS="$HOME/.openclaw/workspace"
# Your Windows workspace path from WSL: example /mnt/c/your-username/.openclaw/workspace
DEFAULT_WIN_WS="/mnt/c/Users/$USER/.openclaw/workspace"
DEFAULT_MASTER="bidirectional"

# Use arguments if provided, otherwise defaults
WSL_WS="${1:-$DEFAULT_WSL_WS}"
WIN_WS="${2:-$DEFAULT_WIN_WS}"
MASTER_MODE="${3:-$DEFAULT_MASTER}"

# Exclude patterns
EXCLUDES=(
  ".git"
  "*.log"
  "node_modules"
  ".DS_Store"
  "Thumbs.db"
  "IDENTITY.md"
  "SOUL.md"
)

build_exclude_args() {
  local args=()
  for exc in "${EXCLUDES[@]}"; do
    args+=("--exclude=$exc")
  done
  echo "${args[@]}"
}

echo "=== OpenClaw Bidirectional Sync (WSL ↔ Windows) ==="
echo "WSL workspace: $WSL_WS"
echo "Windows workspace (from WSL): $WIN_WS"
echo ""
echo "💡 TIP: If paths are wrong, edit the DEFAULT_WSL_WS and DEFAULT_WIN_WS at the top of this script."
echo ""

# Check if Windows path exists
if [ ! -d "$WIN_WS" ]; then
  echo "⚠️  Windows workspace $WIN_WS does not exist"
  echo "   It will be created during sync"
  mkdir -p "$WIN_WS"
fi

EXCLUDE_ARGS=$(build_exclude_args)

# Sync based on master mode
case "$MASTER_MODE" in
  "wsl")
    echo "🔒 Master mode: WSL is master → WSL always wins conflicts"
    echo ""
    echo "1. Sync WSL → Windows..."
    # WSL files always overwrite Windows (master always wins)
    rsync -av --update --force $EXCLUDE_ARGS "$WSL_WS/" "$WIN_WS/"
    ;;
  "windows")
    echo "🔒 Master mode: Windows is master → Windows always wins conflicts"
    echo ""
    echo "1. Sync WSL → Windows (WSL changes sync over, newer overwrites older)..."
    rsync -av --update --force $EXCLUDE_ARGS "$WSL_WS/" "$WIN_WS/"
    echo ""
    echo "2. Sync Windows → WSL (Windows always wins any conflict)..."
    # Windows master always overwrites WSL
    rsync -av --update --force $EXCLUDE_ARGS "$WIN_WS/" "$WSL_WS/"
    ;;
  "bidirectional"|"")
    echo "🔄 Bidirectional mode: two-way sync, newer file always wins"
    echo ""
    # WSL → Windows
    echo "1. Sync WSL → Windows..."
    rsync -av --update --force $EXCLUDE_ARGS "$WSL_WS/" "$WIN_WS/"
    # Windows → WSL
    echo ""
    echo "2. Sync Windows → WSL..."
    rsync -av --update --force $EXCLUDE_ARGS "$WIN_WS/" "$WSL_WS/"
    ;;
  *)
    echo "⚠️  Unknown master mode: $MASTER_MODE"
    echo "   Valid modes: wsl, windows, bidirectional (default)"
    exit 1
    ;;
esac

echo ""
echo "✅ Sync completed at $(date '+%Y-%m-%d %H:%M:%S')"
exit 0
