# openclaw-wsl-win-sync

[English](#english) | [中文说明](#中文说明)

---

## 中文说明

双向实时同步：同一台机器上 WSL 和 Windows 两端的 OpenClaw 工作区。

### 🤔 为什么需要这个？

如果你和我一样，既想在 WSL 里获得更好的网络开发体验，又需要在 Windows 原生体验桌面应用（飞书/微信等），同时让 OpenClaw 能正常调用 Windows 原生能力，那就可以两端都跑 OpenClaw，这个工具帮你自动同步工作区、技能、记忆，让你在两边都能无缝工作。

### ✨ 特性

- ✅ **支持多种同步模式**：
  - 双向同步（哪边新覆盖哪边）
  - 主从模式（双向同步 + 冲突主端裁决）→ 灵活适配你的工作流
- ✅ 基于 `rsync` 只同步变更文件，速度极快
- ✅ 支持和 OpenClaw Heartbeat 集成，每 30 分钟自动同步
- ✅ 支持**跨实例对话**：WSL 和 Windows 两个 OpenClaw 实例可以通过共享文件自动对话，实现双实例协作
- ✅ 智能排除：自动排除日志、缓存文件，保留各自独立的 `IDENTITY.md` 和 `SOUL.md`（两端可以各有各的身份和个性）
- ✅ 开箱即用，适配标准 WSL2 配置

### 🚀 快速开始

1. 克隆到你的 OpenClaw 工作区：
```bash
cd ~/.openclaw/workspace/skills
git clone https://github.com/wzl-xenon/openclaw-wsl-win-sync
```

2. **配置默认路径**：  
打开 `scripts/bidirectional-sync.sh`，修改开头的 `DEFAULT_WSL_WS` 和 `DEFAULT_WIN_WS` 为你自己的实际路径：
```bash
# --------------------------
# DEFAULT PATHS - EDIT ME!
# --------------------------
DEFAULT_WSL_WS="$HOME/.openclaw/workspace"
DEFAULT_WIN_WS="/mnt/c/your-windows-path/.openclaw/workspace"
```

修改之后，直接运行脚本不需要传参数了：
```bash
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

你也可以每次运行传参数：
```bash
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh /path/to/wsl-workspace /path/to/windows-workspace-from-wsl
```

**主从模式**（推荐单端主要修改场景）：指定第三个参数设置主端，冲突时主端总是覆盖：
```bash
# Windows 为主 → 双向同步，发生冲突时 Windows 总是覆盖 WSL（类似 git 中 Windows 是主分支）
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh /path/to/wsl /path/to/windows windows

# WSL 为主 → 双向同步，发生冲突时 WSL 总是覆盖 Windows
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh /path/to/wsl /path/to/windows wsl
```

**工作逻辑：**
- 双向同步，两端修改都能同步过去
- 如果同一文件两边都修改了，**主端版本总是覆盖从端**，保证主端权威
- 适合：主工作区在一端，偶尔在从端修改，最终以主端为准

3. 配置自动同步，在两端的 `HEARTBEAT.md` 加入（根据你的模式调整）：

**双向同步（默认）：**
```markdown
## WSL ↔ Windows OpenClaw Sync
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

**Windows 为主（只同步 Windows → WSL）：**
```markdown
## WSL ↔ Windows OpenClaw Sync (Windows is master)
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh ~/.openclaw/workspace /mnt/c/path/to/windows-workspace windows
```

这样每次 Heartbeat（默认30分钟）自动同步一次，保证两边始终一致。

### 💬 跨实例自动对话

本技能支持 WSL 和 Windows 两个 OpenClaw 实例之间自动对话。每次心跳检查新消息并自动回复，实现自然对话，两个实例可以互相交流，非常好玩！

详情参考：[references/CROSS_TALK.md](references/CROSS_TALK.md)

### 📂 同步内容

- ✅ 同步：`AGENTS.md`, `USER.md`, `MEMORY.md`, `memory/`, `skills/` 所有工作区共享内容
- ❌ 排除：`*.log`, `node_modules/`, `.DS_Store`, `Thumbs.db`, `.git`
- ❌ 不同步：
  - `IDENTITY.md`：保留两端各自独立身份
  - `SOUL.md`：保留两端各自独立的核心个性配置

这样设计：两边共享工作内容、技能、记忆，但各自保留独立的身份和个性，更灵活。

### 依赖要求

- WSL2 开启 Windows 路径挂载（默认开启，`/mnt/c/` 可访问即可）
- WSL 安装 `rsync`（绝大多数 WSL 发行版默认已经安装）
- 两端都已经初始化 OpenClaw 工作区

---

## English

Bidirectional real-time sync between WSL and Windows OpenClaw workspaces on the same machine.

### 🤔 Why this project?

If you like me want better network and development experience in WSL, but also need native Windows integration (Feishu/WeChat and other desktop apps for OpenClaw on Windows), you can run OpenClaw on both sides. This tool automatically keeps your workspace, skills, and memory in sync so you can work seamlessly on both ends.

### ✨ Features

- ✅ **Multiple sync modes:** 
  - Bidirectional sync (newer always wins)
  - Master-slave (bidirectional + master always resolves conflicts)
  — flexible for different workflows
- ✅ Uses `rsync` for efficient sync, only changed files are transferred
- ✅ Integrates with OpenClaw heartbeat, auto-sync every 30 minutes
- ✅ Supports **cross-instance conversation**: two OpenClaw instances (WSL + Windows) can talk automatically via shared file, enabling multi-instance collaboration
- ✅ Smart excludes: excludes logs/caches, keeps `IDENTITY.md` and `SOUL.md` separate on each side (allowing different identities and personalities for different environments)
- ✅ Works out of the box with standard WSL2 setup

### 🚀 Quick Start

1. Clone to your OpenClaw workspace:
```bash
cd ~/.openclaw/workspace/skills
git clone https://github.com/wzl-xenon/openclaw-wsl-win-sync
```

2. **Configure default paths:**  
Open `scripts/bidirectional-sync.sh` and edit `DEFAULT_WSL_WS` and `DEFAULT_WIN_WS` at the top to match your actual paths:
```bash
# --------------------------
# DEFAULT PATHS - EDIT ME!
# --------------------------
DEFAULT_WSL_WS="$HOME/.openclaw/workspace"
DEFAULT_WIN_WS="/mnt/c/your-windows-path/.openclaw/workspace"
```

After editing, you can just run the script without arguments:
```bash
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

You can also pass arguments each time:
```bash
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh /path/to/wsl-workspace /path/to/windows-workspace-from-wsl
```

**Master-slave mode** (recommended if you mostly edit on one side): specify third argument to set master, master always wins conflicts:
```bash
# Windows is master → bidirectional sync, Windows always overwrites WSL on conflict (like Windows is the main branch in git)
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh /path/to/wsl /path/to/windows windows

# WSL is master → bidirectional sync, WSL always overwrites Windows on conflict
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh /path/to/wsl /path/to/windows wsl
```

**How it works:**
- Bidirectional sync, changes on both sides sync to the other
- If the same file is modified on both sides, **master version always overwrites slave**, keeping master authoritative
- Best for: you do most work on one side, occasionally work on the slave, final authority stays with master

3. Enable auto-sync by adding this to `HEARTBEAT.md` (adjust for your mode):

**Bidirectional sync (default):**
```markdown
## WSL ↔ Windows OpenClaw Sync
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh
```

**Windows as master (only sync Windows → WSL):**
```markdown
## WSL ↔ Windows OpenClaw Sync (Windows is master)
~/.openclaw/workspace/skills/openclaw-wsl-win-sync/scripts/bidirectional-sync.sh ~/.openclaw/workspace /mnt/c/path/to/windows-workspace windows
```

Now every heartbeat (every ~30min) will sync automatically, keeping both sides consistent.

### 💬 Cross-Instance Auto-Conversation

This skill supports automatic conversation between two OpenClaw instances. Each heartbeat checks for new messages and replies automatically, enabling natural dialogue and collaboration between the two instances. It's really fun and useful!

See details here：[references/CROSS_TALK.md](references/CROSS_TALK.md)

### 📂 What Gets Synced

- ✅ Synced: `AGENTS.md`, `USER.md`, `MEMORY.md`, `memory/`, `skills/` — all shared workspace content
- ❌ Excluded: `*.log`, `node_modules/`, `.DS_Store`, `Thumbs.db`, `.git`
- ❌ Not synced:
  - `IDENTITY.md` — keep separate identities for each environment
  - `SOUL.md` — keep independent personality/core config on each side

This design lets both sides share work content, skills, and memory, while keeping independent identity and personality configurations — more flexible for different use cases.

### Requirements

- WSL2 with Windows path mounting enabled (default enabled, just need `/mnt/c/` accessible)
- `rsync` installed in WSL (preinstalled on most WSL distributions)
- OpenClaw initialized on both sides

### License

MIT
