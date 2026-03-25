# openclaw-wsl-win-sync

[English](#english) | [中文说明](#中文说明)

---

## 中文说明

双向实时同步：同一台机器上 WSL 和 Windows 两端的 OpenClaw 工作区。

### 🤔 为什么需要这个？

如果你和我一样，既想在 WSL 里获得更好的网络开发体验，又需要在 Windows 原生体验桌面应用（飞书/微信等，同时让 OpenClaw 能正常调用Windows原生能力，那就可以两端都跑 OpenClaw，这个工具帮你自动同步工作区、技能、记忆，让你在两边都能无缝工作。

### ✨ 特性

- ✅ 双向实时增量同步，两边修改都会同步
- ✅ 基于 `rsync` 只同步变更文件，速度极快
- ✅ 支持和 OpenClaw Heartbeat 集成，每 30 分钟自动同步
- ✅ 支持**跨实例对话**：WSL 和 Windows 两个 OpenClaw 实例可以通过共享文件自动对话，实现双实例协作
- ✅ 智能排除：自动排除日志、缓存文件，保留各自独立的 `IDENTITY.md`（两端可以各有各的身份标识
- ✅ 开箱即用，适配标准 WSL2 配置

### 🚀 快速开始

1. 克隆到你的 OpenClaw 工作区：
```bash
cd ~/.openclaw/workspace/skills
git clone https://github.com/wzl-xenon/openclaw-wsl-win-sync
```

2. 手动同步：
```bash
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh [wsl-workspace-path] [windows-workspace-path]
```

默认路径：
- WSL 工作区：`~/.openclaw/workspace`
- Windows 工作区（WSL 挂载）：`/mnt/c/home/xenon/.openclaw/workspace`（根据你的实际情况修改）

3. 配置自动同步，在你 WSL 和 Windows 两端的 `HEARTBEAT.md` 加入：
```markdown
## WSL ↔ Windows OpenClaw Sync
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

这样每次 Heartbeat（默认30分钟）自动同步一次，保证两边始终一致。

### 💬 跨实例自动对话

本技能支持 WSL 和 Windows 两个 OpenClaw 实例之间自动对话。每次心跳检查新消息并自动回复，实现自然对话，两个实例可以互相交流，非常好玩！

详情参考：[references/CROSS_TALK.md](references/CROSS_TALK.md)

### 📂 同步内容

- ✅ 同步：`AGENTS.md`, `SOUL.md`, `USER.md`, `MEMORY.md`, `memory/`, `skills/` 所有工作区内容
- ❌ 排除：`*.log`, `node_modules/`, `.DS_Store`, `Thumbs.db`
- ❌ 不同步 `IDENTITY.md`：**保留两端各自独立身份，符合使用习惯

### Requirements

- WSL2 开启 Windows 路径挂载（默认开启，`/mnt/c/` 可访问即可）
- WSL 安装 `rsync`（绝大多数 WSL 发行版默认已经安装
- 两端都已经初始化 OpenClaw 工作区

---

## English

Bidirectional real-time sync between WSL and Windows OpenClaw workspaces on the same machine.

### 🤔 Why this project?

If you like me want better network and development experience in WSL, but also need native Windows integration (Feishu/WeChat and other desktop apps for OpenClaw on Windows, you can run OpenClaw on both sides. This tool automatically keeps your workspace, skills, and memory in sync so you can work seamlessly on both ends.

### ✨ Features

- ✅ Bidirectional incremental sync, changes on either side are synced to the other
- ✅ Uses `rsync` for efficient sync, only changed files are transferred
- ✅ Integrates with OpenClaw heartbeat, auto-sync every 30 minutes
- ✅ Supports **cross-instance conversation**: two OpenClaw instances (WSL + Windows) can talk automatically via shared file, enabling multi-instance collaboration
- ✅ Smart excludes: excludes logs/caches, keeps `IDENTITY.md` separate on each side (allowing different identities for different environments)
- ✅ Works out of the box with standard WSL2 setup

### 🚀 Quick Start

1. Clone to your OpenClaw workspace:
```bash
cd ~/.openclaw/workspace/skills
git clone https://github.com/wzl-xenon/openclaw-wsl-win-sync
```

2. Manual sync:
```bash
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh [wsl-workspace-path] [windows-workspace-path]
```

Default paths:
- WSL workspace: `~/.openclaw/workspace`
- Windows workspace (from WSL): `/mnt/c/home/xenon/.openclaw/workspace` (change to your actual path)

3. Enable auto-sync by adding this to `HEARTBEAT.md` on **both** WSL and Windows:
```markdown
## WSL ↔ Windows OpenClaw Sync
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

Now every heartbeat (every ~30min) will sync automatically, keeping both sides consistent.

### 💬 Cross-Instance Auto-Conversation

This skill supports automatic conversation between two OpenClaw instances. Each heartbeat checks for new messages and replies automatically, enabling natural dialogue and collaboration between the two instances. It's really fun and useful!

See details here：[references/CROSS_TALK.md](references/CROSS_TALK.md)

### 📂 What Gets Synced

- ✅ Synced: `AGENTS.md`, `SOUL.md`, `USER.md`, `MEMORY.md`, `memory/`, `skills/` — everything in your workspace
- ❌ Excluded: `*.log`, `node_modules/`, `.DS_Store`, `Thumbs.db`
- ❌ Not synced: `IDENTITY.md` — keep separate identities for each environment, it just works better that way

### Requirements

- WSL2 with Windows path mounting enabled (default enabled, just need `/mnt/c/` accessible)
- `rsync` installed in WSL (preinstalled on most WSL distributions)
- OpenClaw initialized on both sides

### License

MIT
