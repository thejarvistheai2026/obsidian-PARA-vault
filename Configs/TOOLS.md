# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## Email Permissions

**Allowlist for sending emails on request:**

| Name | Email | Status |
|------|-------|--------|
| Kyle | Kyle.r.johnstone@gmail.com | ✅ Whitelisted |

---

## Franco's Environment

### Obsidian Setup
- **Vault location:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/`
- **Structure:**
  - `Daily/` — Daily notes
  - `Emergency-Backup/` — Recovery info
  - `openclaw/` — This workspace (meta!)
    - `11. Web Resources/` — Saved links and articles (numbered folder)
- **Daily notes:** Stored in `Daily/YYYY-MM-DD.md`
- **Templates:** `.obsidian/templates/` (Links Template.md available)
- **Saved links go to:** `openclaw/11. Web Resources/`

### OpenClaw Workspace
- **Location:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/openclaw/`
- **Contains:** AGENTS.md, SOUL.md, USER.md, projects, memory system

### QMD (Semantic Search)
**Tool:** `qmd` — semantic + full-text search for your vault
- **Collection config:** `~/.config/qmd/index.yml`
- **Current collection:** `obsidian` → `/Users/jarvis/Mac-Mini-Obsidian-Vault` (**/*.md)
- **Usage:** `qmd query "search term"` or `qmd search "term"`
- **Update index:** `qmd update && qmd embed`
- **Status:** `qmd status`

---

## Web Fetching Tips

### X.com / Twitter Links
X blocks direct scraping. Use **r.jina.ai** as a proxy:
- Format: `https://r.jina.ai/http://x.com/[handle]/status/[id]`
- Example: `https://r.jina.ai/http://x.com/atlasforgeai/status/2026380335249002843`

This extracts the text content without hitting X's anti-scraping measures.

---

Add whatever helps you do your job. This is your cheat sheet.
