# SETUP.md - System Configuration

**Owner:** Franco  
**AI Assistant:** Javis  
**Last Updated:** 2026-02-15

---

## 🖥️ Hardware & OS

- **Device:** Mac mini M4 (2024)
- **OS:** macOS 26.3 (Darwin)
- **Architecture:** arm64
- **Node.js:** v22.22.0
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
│   ├── openclaw-config/                # Sanitized config backup
│   ├── Emergency-Backup/               # This folder
│   └── workflows/                      # Automation scripts
├── 2. the-brain/                       # Knowledge base
│   ├── 1. projects/
│   ├── 2. areas/
│   ├── 3. resources/                   # Articles, Newsletters
│   └── 4. archive/
├── 3. code/                            # Code projects
│   └── newsletter-system/              # Newsletter automation
│       ├── scripts/                    # Gmail, RSS, digest scripts
│       ├── data/state.db               # SQLite database
│       └── config/sources.conf         # RSS feed config
└── 4. CRM/                             # People & contacts
```

---

## 🧠 Agent Configuration

### Main Agent (default)
- **Model:** Claude Sonnet 4.5 (`anthropic/claude-sonnet-4-5`)
- **Context Window:** 200k tokens
- **Workspace:** `/Users/jarvis/.openclaw/workspace`
- **Thinking Level:** low
- **Compaction Mode:** safeguard
- **Heartbeat:** Every 30 minutes (main session)

### Workspace Files (in `~/Mac-Mini-Obsidian-Vault/1. openclaw/`)
- `AGENTS.md` - Agent behavior rules
- `SOUL.md` - Personality & core values
- `USER.md` - Info about Franco
- `IDENTITY.md` - Javis's identity
- `MEMORY.md` - Long-term memories
- `TOOLS.md` - Local tool notes
- `HEARTBEAT.md` - Heartbeat task list
- `BOOTSTRAP.md` - Onboarding script
- `SKILL.md` - Skill usage patterns
- `STYLE.md` - Communication style
- `Emergency-Backup/TROUBLESHOOTING.md` - Emergency recovery guide
- `Emergency-Backup/SETUP.md` - This file

---

## 📱 Messaging Channels

### iMessage (✅ Working)
- **CLI:** `imsg` (via Homebrew: `steipete/tap/imsg`)
- **CLI Path:** `/opt/homebrew/bin/imsg`
- **Paired Number:** +16138893035 (Franco's iPhone)
- **DM Policy:** pairing (approved)
- **Group Policy:** allowlist
- **Status:** ✅ Connected and working

### Discord (⚠️ In Setup)
- **App ID:** 1472606548797948146
- **Bot Token:** [REDACTED - stored in keychain]
- **Server ID:** 1467505736090386557
- **DM Policy:** pairing
- **Group Policy:** allowlist (server above)
- **Require Mention:** No (responds to all messages in allowed server)
- **Status:** ⚠️ Setup in progress (2026-02-15)

---

## 🔧 Skills Installed

### gws (Google Workspace CLI)
- **Binary:** `/opt/homebrew/bin/gws` (via npm: `@googleworkspace/cli`)
- **Account:** jarvistheai2026@gmail.com
- **Project:** upheld-hope-486013-p3
- **Services:** Gmail, Drive, Calendar, Contacts, Docs, Sheets, Chat, Meet, Forms, Keep
- **Auth:** OAuth with encrypted credentials in `~/.config/gws/credentials.enc`
- **Status:** ✅ Working
- **Note:** Replaces gog (deprecated)

### imsg (iMessage)
- **Binary:** `/opt/homebrew/bin/imsg`
- **Messages.app:** Signed in
- **Permissions:** Full Disk Access + Automation (Messages.app)
- **Status:** ✅ Working

### weather
- **Status:** Installed (no API key required)

### healthcheck
- **Status:** Installed

### skill-creator
- **Status:** Installed

---

## 🔐 Authentication

### Anthropic (Claude)
- **Provider:** anthropic
- **Mode:** api_key
- **Profile:** `anthropic:default`
- **API Key:** (stored in environment or config - not shown here)

---

## ⚙️ Tools Configuration

### Tool Profiles
- **Profile:** full (all tools available)

### Web Tools
- **web_search:** Enabled (Brave Search API)
- **web_fetch:** Enabled (lightweight HTTP fetch)

### Media Understanding
- **Image Understanding:** Enabled
- **Audio Understanding:** Enabled
- **Video Understanding:** Enabled

### Exec/Shell
- **Host:** gateway (runs on Mac mini)
- **Security:** allowlist
- **Ask Mode:** off

### Filesystem
- **Workspace-only:** false (can access files outside workspace)

---

## 🔄 Update Configuration

- **Channel:** stable
- **Check on Start:** true
- **Update Method:** pnpm (via npm registry)

---

## 💾 Backup System

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
**Error Log:** `/tmp/openclaw-backup-error.log`

### Newsletter Automation (Sundays + Thursdays 9:00 AM)
**LaunchAgent:** `~/Library/LaunchAgents/com.openclaw.newsletter.plist`
**Working Directory:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/newsletter-system`
**Log:** `/tmp/openclaw/newsletter.log`

### Recovery Process
If vault is lost:
1. Clone all 4 repos above
2. Place in correct numbered folders
3. Update OpenClaw config workspace path
4. Run newsletter scripts to verify paths

---

## 🚨 Security Notes

### File Permissions
- Config file should be `600` (owner read/write only):
  ```bash
  chmod 600 ~/.openclaw/openclaw.json
  ```

### Sensitive Data Locations
- `~/.openclaw/openclaw.json` - Contains API keys, bot tokens, auth tokens
- Environment variables - May contain API keys

### Gateway Access
- **Bind:** loopback (127.0.0.1 only)
- **Public Access:** No (local machine only)
- **Auth Required:** Yes (token-based)

---

## 🐛 Known Issues & Workarounds

### Discord Setup Challenges (2026-02-15)
- **Issue:** Bot not receiving messages despite being connected
- **Likely Cause:** Missing MESSAGE CONTENT INTENT in Developer Portal
- **Fix:** Enable MESSAGE CONTENT INTENT + re-invite with proper permissions

### Web UI Disconnects During Restarts
- **Issue:** WebSocket disconnects during gateway restarts
- **Workaround:** Refresh browser page after restart completes
- **Alternative:** Use iMessage to reach Javis when web UI is down

---

## 📊 Resource Usage

### Typical Memory Usage
- Gateway process: ~400-500 MB RAM
- Node.js: v22.22.0

### Log Rotation
- Daily logs: `/tmp/openclaw/openclaw-YYYY-MM-DD.log`
- Automatic rotation: Yes (daily)

---

## 🆘 Emergency Contacts

### When OpenClaw is Down
1. **iMessage:** Text +16138893035 (Franco's paired number)
2. **Discord:** (once working) Message in server 1467505736090386557
3. **Terminal:** Check `TROUBLESHOOTING.md` for recovery commands

### When Stuck with Config Issues
- Backup: `cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup`
- Validate: `openclaw config get`
- Logs: `tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log`

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

---

**Maintained by:** Javis  
**Created:** 2026-02-15
