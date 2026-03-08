# SETUP.md - System Configuration

**Owner:** Franco  
**AI Assistant:** Jarvis  
**Last Updated:** 2026-03-08

---

## 🖥️ Hardware & OS

- **Device:** Mac mini M4 (2024)
- **OS:** macOS 26.3 (Darwin)
- **Architecture:** arm64
- **Node.js:** v22.22.0
- **Go:** 1.26.1
- **Shell:** zsh

---

## 🤖 OpenClaw Configuration

### Installation
- **Method:** Homebrew + pnpm
- **Version:** 2026.2.14 (stable channel)
- **Install Location:** `/opt/homebrew/lib/node_modules/openclaw`
- **Gateway Mode:** local (loopback only)
- **Gateway Port:** 18789
- **Gateway Bind:** 127.0.0.1 (localhost only)
- **Auth:** Token-based (stored in config)

### Gateway Service
- **Type:** macOS LaunchAgent
- **Plist:** `~/Library/LaunchAgents/ai.openclaw.gateway.plist`
- **Service Name:** `ai.openclaw.gateway`
- **Auto-start:** Yes (on login)

### ⚠️ CRITICAL: Gateway Restart Pattern
**For config changes, ALWAYS use:**
```bash
openclaw gateway restart   # ✅ Keeps LaunchAgent registered
```

**DANGER - Never use during normal operation:**
```bash
openclaw gateway stop      # ❌ UNLOADS the LaunchAgent from macOS!
openclaw gateway start     # ❌ Starts in foreground, NOT as a service
```

**Why this matters:**
- `stop` unregisters the service from macOS LaunchAgents
- `start` runs manually in the foreground (no auto-restart on crash)
- Result: Gateway won't auto-start on boot, won't auto-restart if it crashes

**If you accidentally used stop/start:**
```bash
openclaw gateway install   # Re-installs the LaunchAgent
openclaw gateway restart
```

**Documented:** 2026-03-08 (learned the hard way during Discord debugging)

---

## 📂 Key File Paths

### OpenClaw
```
~/.openclaw/                           # OpenClaw home
~/.openclaw/openclaw.json              # Main config (SENSITIVE - contains tokens)
~/.openclaw/agents/main/               # Main agent directory
~/.openclaw/agents/main/sessions/      # Session storage
/tmp/openclaw/                         # Runtime data
/tmp/openclaw/openclaw-YYYY-MM-DD.log  # Daily logs
/opt/homebrew/lib/node_modules/openclaw/skills/  # Bundled skills
```

### Workspace (Obsidian Vault)
```
~/Mac-Mini-Obsidian-Vault/              # Vault root
├── 1. openclaw/                        # Agent workspace
│   ├── AGENTS.md, SOUL.md, USER.md     # Core agent files
│   ├── .scripts/daily-backup.sh        # Daily backup script
│   ├── .scripts/daily-status-report.sh # Status report script
│   ├── .scripts/qmd-maint.sh           # QMD maintenance
│   ├── openclaw-config/                # Sanitized config backup
│   ├── Emergency-Backup/               # This folder
│   ├── discord-capture/                # Discord bot
│   │   ├── bot.js                      # Main bot
│   │   ├── generate-retro.sh           # Retro generator
│   │   ├── extract-insights.sh         # Insight extractor
│   │   └── raw/                        # Message captures
│   └── workflows/                      # Automation scripts
├── 2. the-brain/                       # Knowledge base
│   ├── 1. projects/
│   ├── 2. areas/
│   ├── 3. resources/                   # Articles, Newsletters
│   └── 4. archive/
├── 3. code/                            # Code projects
│   ├── discrawl/                       # Discord archive (Go)
│   └── discord-insights/               # AI-extracted learnings
├── 4. CRM/                             # People & contacts
└── .obsidian/                          # Obsidian config
```

### External Data
```
~/.discrawl/                            # Discrawl
├── config.toml                         # Bot configuration
└── discrawl.db                         # SQLite (2,539+ messages)

~/.cache/qmd/                          # QMD
├── index.sqlite                        # Search index (36.4 MB)
└── models/                             # GGUF embeddings
    ├── embeddinggemma-300M-Q8_0
    ├── qwen3-reranker-0.6b-q8_0
    └── qmd-query-expansion-1.7B-q4_k_m
```

---

## 🧠 Agent Configuration

### Main Agent (default)
- **Model:** Claude Sonnet 4.5 (`anthropic/claude-sonnet-4-5`) or Kimi K2.5
- **Context Window:** 200k tokens
- **Workspace:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/`
- **Thinking Level:** low
- **Compaction Mode:** safeguard
- **Heartbeat:** Every 30 minutes (main session)

### Workspace Files
- `AGENTS.md` - Agent behavior rules
- `SOUL.md` - Personality & core values
- `USER.md` - Info about Franco (25 interview questions)
- `IDENTITY.md` - Jarvis's identity
- `MEMORY.md` - Long-term memories
- `TOOLS.md` - Local tool notes
- `HEARTBEAT.md` - Heartbeat task list
- `SKILL.md` - Skill usage patterns
- `STYLE.md` - Communication style

---

## 📱 Messaging Channels

### iMessage (✅ Working)
- **CLI:** `imsg` (via Homebrew: `steipete/tap/imsg`)
- **CLI Path:** `/opt/homebrew/bin/imsg`
- **Paired Number:** +16138893035 (Franco's iPhone)
- **DM Policy:** pairing (approved)
- **Group Policy:** allowlist
- **Status:** ✅ Connected and working

### Discord (✅ Working)
- **App ID:** 1472606548797948146
- **Bot Token:** [REDACTED - stored in keychain/config]
- **Server ID:** 1467505736090386557
- **Bot:** the-observer#9526
- **DM Policy:** pairing
- **Group Policy:** allowlist (server above)
- **Status:** ✅ Running (PID 68868)

---

## 🔧 Skills Installed

### Core Skills
- **gws** (Google Workspace CLI) - 38 skills
- **imsg** (iMessage) - `/opt/homebrew/bin/imsg`
- **weather** - no API key required
- **healthcheck** - security auditing
- **skill-creator** - create new skills

### gws (Google Workspace CLI)
- **Binary:** `/opt/homebrew/bin/gws` (via npm: `@googleworkspace/cli`)
- **Account:** jarvistheai2026@gmail.com
- **Credentials:** `~/.config/gws/credentials.enc`

**Available Skills (38):**
- **Email:** gws-gmail, gws-gmail-send, gws-gmail-triage, gws-gmail-watch
- **Files:** gws-drive, gws-drive-upload
- **Calendar:** gws-calendar, gws-calendar-agenda, gws-calendar-insert
- **Docs:** gws-docs, gws-docs-write
- **Sheets:** gws-sheets, gws-sheets-read, gws-sheets-append
- **Chat:** gws-chat, gws-chat-send
- **Meet:** gws-meet
- **Forms:** gws-forms
- **Keep:** gws-keep
- **Tasks:** gws-tasks
- **Classroom:** gws-classroom
- **Safety:** gws-modelarmor
- **Workflows:** gws-workflow-* (standup, digest, prep, announce)

---

## 🔄 Automation Systems

### Daily Git Backup (23:00)
**Script:** `~/Mac-Mini-Obsidian-Vault/1. openclaw/.scripts/daily-backup.sh`

| Source | GitHub Repo | URL |
|--------|-------------|-----|
| `1. openclaw/` | openclaw-obsidian-workspace-backup | https://github.com/thejarvistheai2026/openclaw-obsidian-workspace-backup |
| `2. the-brain/` | PARA-Obsidian-vault-backup | https://github.com/thejarvistheai2026/PARA-Obsidian-vault-backup |
| `4. CRM/` | obsidian-crm | https://github.com/thejarvistheai2026/obsidian-crm |
| `3. code/newsletter-system/` | jarvis-newsletter-system | https://github.com/thejarvistheai2026/jarvis-newsletter-system |

**LaunchAgent:** `~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-backup.plist`
**Log:** `/tmp/openclaw-backup.log`

### Daily Status Report (07:00)
**Script:** `~/Mac-Mini-Obsidian-Vault/1. openclaw/.scripts/daily-status-report.sh`
**LaunchAgent:** `~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-status.plist`
**Recipient:** +16138893035

**Reports On:**
- Discord Bot status (PID, capture count)
- QMD stats (files, vectors, last updated)
- Discrawl status
- Newsletter schedule/status
- Discord Retro status
- Daily Backup status
- OpenClaw Gateway status

### Discord Retrospectives (Sun/Thu @ 22:00)
**Script:** `~/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture/generate-retro.sh`
**LaunchAgent:** `~/Library/LaunchAgents/ai.thejarvis.openclaw.discord-retro.plist`
**Output:** `memory/discord-retro/YYYY-MM-DD.md`

### QMD Maintenance (Daily @ 06:55)
**Script:** `~/Mac-Mini-Obsidian-Vault/1. openclaw/.scripts/qmd-maint.sh`
**LaunchAgent:** `~/Library/LaunchAgents/ai.thejarvis.openclaw.qmd-maint.plist`
**Actions:**
- Daily: Incremental update
- Sunday: Full re-embedding

### Discrawl Tail (24/7)
**Script:** `~/Mac-Mini-Obsidian-Vault/3. code/discrawl/start-tail.sh`
**LaunchAgent:** `~/Library/LaunchAgents/ai.thejarvis.openclaw.discrawl-tail.plist`
**Database:** `~/.discrawl/discrawl.db`
**Status:** Live tail mode (PID 74447)

### Newsletters (Currently Disabled)
**Schedule:** Sundays + Thursdays @ 09:00
**LaunchAgent:** `~/Library/LaunchAgents/com.openclaw.newsletter.plist`
**Status:** ⚠️ Disabled (missing run-scheduled.sh)

---

## Complete Schedule

| Time | Sun | Mon | Tue | Wed | Thu | Fri | Sat |
|------|-----|-----|-----|-----|-----|-----|-----|
| **06:55** | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD |
| **07:00** | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status |
| **09:00** | 📰 News* | | | | 📰 News* | | |
| **22:00** | 💬 Retro | | | | 💬 Retro | | |
| **23:00** | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup |
| **24/7** | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer |
| **24/7** | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl |

*Newsletter currently disabled

---

## Discord Complete Awareness System

### 1. Observer Bot (Real-time Capture)
- **Bot:** the-observer#9526
- **PID:** 68868
- **Capture:** 24/7 → `discord-capture/raw/YYYY-MM-DD.jsonl`
- **Retros:** Sun/Thu @ 22:00
- **Insight Extraction:** Auto-extracts after each retro

### 2. Discrawl (Archive + Search)
- **Location:** `3. code/discrawl/`
- **Database:** `~/.discrawl/discrawl.db` (2,539+ messages)
- **Commands:**
  ```bash
  cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl"
  ./bin/discrawl search "keyword"
  ./bin/discrawl tail
  ./bin/discrawl status
  ```

### 3. Discord Insights → QMD
- **Location:** `3. code/discord-insights/`
- **Indexed:** Yes (updates daily @ 06:55)

---

## QMD - Local Search Engine

**Collections:**
| Collection | Path | Files |
|------------|------|-------|
| `brain` | `2. the-brain/` | 263 |
| `crm` | `4. CRM/` | 125 |
| `discord-insights` | `3. code/discord-insights/` | Auto |

**Total:** 388 files indexed, 2,342 vectors embedded

**Commands:**
```bash
qmd search "keyword" -c brain      # BM25 keyword search
qmd vsearch "concept" -c brain       # Semantic search
qmd query "question" -c crm            # Hybrid + LLM re-rank
```

---

## 🔐 Authentication

### Anthropic (Claude)
- **Provider:** anthropic
- **Mode:** api_key
- **Profile:** `anthropic:default`

### Ollama (Local)
- **Model:** kimi-k2.5:cloud
- **Running via:** Ollama local server

### Google Workspace
- **Account:** jarvistheai2026@gmail.com
- **Credentials:** `~/.config/gws/credentials.enc`

---

## 🔐 Security Notes

### File Permissions
```bash
# Config file should be 600 (owner read/write only)
chmod 600 ~/.openclaw/openclaw.json
```

### Sensitive Data Locations
- `~/.openclaw/openclaw.json` - Contains API keys, bot tokens, auth tokens
- `~/.config/gws/credentials.enc` - Google Workspace credentials
- `~/.discrawl/config.toml` - Discord bot token
- `discord-capture/config.json` - Bot credentials

### Gateway Access
- **Bind:** loopback (127.0.0.1 only)
- **Public Access:** No (local machine only)
- **Auth Required:** Yes (token-based)

---

## 🐛 Known Issues & Workarounds

### Newsletter System (Disabled)
- **Issue:** Missing `run-scheduled.sh` script
- **Status:** Can be re-enabled once script exists

### Discord Token Configuration
- Observer bot: 1479867210179543210 (intents enabled)
- Token stored in: `~/.discrawl/config.toml` and OpenClaw config

---

## 📊 Resource Usage

### Typical Memory Usage
- Gateway process: ~400-500 MB RAM
- Discord bot: ~100 MB
- Discrawl: ~50 MB
- QMD models: ~2 GB (disk), loaded on demand

### Log Rotation
- Daily logs: `/tmp/openclaw/openclaw-YYYY-MM-DD.log`
- QMD logs: `memory/qmd-logs/`
- Discord capture: `discord-capture/raw/`

---

## 🆘 Emergency Contacts

### When OpenClaw is Down
1. **iMessage:** Text +16138893035
2. **Terminal:** Check TROUBLESHOOTING.md for recovery commands

---

## 📝 Quick Reference Commands

```bash
# Check status
openclaw status

# View logs (live)
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log

# Restart gateway
openclaw gateway restart

# Check what's running
ps aux | grep openclaw

# Access web UI
open http://127.0.0.1:18789/

# Check channels
openclaw status | grep -A 10 "Channels"

# Validate config
openclaw config get

# Discord bot check
ps aux | grep "discord-capture/bot"

# QMD check
qmd status

# Discrawl check
cd "3. code/discrawl"
./bin/discrawl status
```

---

**For Other AI Assistants:**

When helping Franco with OpenClaw issues:
1. He's not a developer - provide full terminal commands (copy-paste ready)
2. Explain what each command does
3. Check logs at `/tmp/openclaw/openclaw-YYYY-MM-DD.log` when debugging
4. Config is at `~/.openclaw/openclaw.json` (always backup before editing)
5. Gateway runs as a LaunchAgent on macOS
6. This is a **local** setup (loopback only, no public access)
7. The Jarvis Playbook (Google Doc) has full documentation

---

**Maintained by:** Jarvis  
**Created:** 2026-02-15  
**Updated:** 2026-03-08
