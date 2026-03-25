#!/bin/bash
# Bidirectional sync between WSL and Windows OpenClaw workspace
# Usage: bidirectional-sync.sh <wsl-workspace-path> <windows-workspace-path>
# 
# If you don't pass arguments, it uses defaults below.
# Edit the DEFAULTS below to match your paths.

set -euo pipefail

# --------------------------
# DEFAULT PATHS - EDIT ME!
# --------------------------
# Change these to match your actual installation
DEFAULT_WSL_WS="$HOME/.openclaw/workspace"
# Your Windows workspace path from WSL: example /mnt/c/home/xenon/.openclaw/workspace
DEFAULT_WIN_WS="/mnt/c/Users/$USER/.openclaw/workspace"

# Use arguments if provided, otherwise defaults
WSL_WS="${1:-$DEFAULT_WSL_WS}"
WIN_WS="${2:-$DEFAULT_WIN_WS}"

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

# WSL → Windows
echo "1. Sync WSL → Windows..."
rsync -av --update $EXCLUDE_ARGS "$WSL_WS/" "$WIN_WS/"

# Windows → WSL
echo ""
echo "2. Sync Windows → WSL..."
rsync -av --update $EXCLUDE_ARGS "$WIN_WS/" "$WSL_WS/"

echo ""
echo "✅ Sync completed at $(date '+%Y-%m-%d %H:%M:%S')"
exit 0
