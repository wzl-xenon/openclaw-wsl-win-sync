---
name: openclaw-wsl-win-sync
description: Bidirectional real-time sync between WSL and Windows OpenClaw workspaces on the same machine. Use when you run OpenClaw in both WSL and Windows and need to keep workspace, skills, and memory in sync automatically.
---

# openclaw-wsl-win-sync

## Overview

Automatic bidirectional synchronization between WSL OpenClaw and Windows OpenClaw workspaces on the same machine. Integrates with OpenClaw heartbeat to sync every 30 minutes.

## Quick Start

```bash
{baseDir}/scripts/bidirectional-sync.sh [wsl-workspace-path] [windows-workspace-path]
```

- Default WSL path: `~/.openclaw/workspace`
- Default Windows path (WSL mount): `/mnt/c/Users/$USER/.openclaw/workspace`
- Override by passing arguments if your paths differ (your actual path might be `/mnt/c/home/xenon/.openclaw/workspace` for non-standard installs)

## What gets synced

- ✅ `workspace/` - All files including AGENTS.md, SOUL.md, USER.md, MEMORY.md, memory/
- ✅ `workspace/skills/` - All workspace skills
- ❌ Excludes: 
  - `*.log`, `node_modules/`, `.DS_Store`, `Thumbs.db`
  - `IDENTITY.md` - **保留各自独立身份**，两边可以有不同的名称/标识

这样设计：两边共享工作内容、技能、记忆，但各自保留独立的Agent身份，符合使用习惯。

## Automatic Sync with Heartbeat

Add this entry to your `HEARTBEAT.md` in WSL workspace to sync every 30 minutes:

```markdown
## WSL ↔ Windows OpenClaw Sync
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

This ensures automatic real-time synchronization with the default heartbeat interval.

## How it works

- Uses `rsync` with `-av --update` for efficient incremental sync
- Runs bidirectionally: WSL → Windows **and** Windows → WSL
- Only transfers changed files, very fast
- Works out of the box with standard WSL2 setup

## Customization

Edit the `EXCLUDES` array in `scripts/bidirectional-sync.sh` to add additional exclude patterns.

## Scripts

- `bidirectional-sync.sh` - Main sync script

## Cross-Instance Conversation (Auto Dialogue)

This skill supports **automatic cross-instance conversation** between WSL and Windows. Both instances check for new messages on each heartbeat and reply automatically, creating a natural dialogue between the two agents.

### How it works

- Uses the shared `cross-conversation.md` file in workspace to exchange messages
- Each heartbeat checks for new messages from the other side
- If new messages found, generate a reply and append to the file
- Next heartbeat on the other side picks up the reply and responds
- Conversation flows naturally with 30-minute intervals (matches heartbeat schedule)

### Enable auto dialogue

1. Add this entry to your HEARTBEAT.md:
```markdown
## Cross-Instance Conversation
Run cross-instance dialogue check:
`~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/start-cross-talk.sh`
```

2. Create `cross-config.json` in your workspace root:
```json
{
  "this_side": "wsl", // or "windows"
  "enabled": true
}
```

3. Done - next heartbeat will start the conversation automatically.

See [references/CROSS_TALK.md](references/CROSS_TALK.md) for full details.

## Requirements

- WSL2 with Windows path mounting enabled (`/mnt/c/`)
- `rsync` installed in WSL (preinstalled on most WSL distributions)
- OpenClaw already initialized on both sides
