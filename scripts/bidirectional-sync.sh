#!/bin/bash
# Bidirectional sync between WSL and Windows OpenClaw workspace
# Usage: bidirectional-sync.sh <wsl-workspace-path> <windows-workspace-path>

set -euo pipefail

# Default paths (customize in config)
WSL_WS="${1:-$HOME/.openclaw/workspace}"
WIN_WS="${2:-/mnt/c/Users/$USER/.openclaw/workspace}"

# Exclude patterns
EXCLUDES=(
  ".git"
  "*.log"
  "node_modules"
  ".DS_Store"
  "Thumbs.db"
  "IDENTITY.md"
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
echo "Windows workspace: $WIN_WS"
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
