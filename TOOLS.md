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

## Vault Paths (Critical)

**Articles / Captured Content:**
- **ALWAYS save to:** `2. the-brain/3. resources/Articles/`
- **Format:** `descriptive-title.md` (NO date prefix)
- **NOT** directly in `3. resources/` — must be in the `Articles/` subfolder
- The `captured:` field in YAML frontmatter tracks the date instead

---

## Web Development Defaults

**UI Framework:** ShadCN/UI (built on Tailwind + Radix)
- Install: `npx shadcn@latest init`
- Add components: `npx shadcn add [component]`
- Default base color: `neutral` or `slate` (ask if preference unclear)

**Styling:** Tailwind CSS — always use unless there's a specific reason not to

**Component Priority:**
1. ShadCN built-ins first (Button, Card, Dialog, etc.)
2. Custom ShadCN-style components second
3. Third-party only if necessary

**Why:** Consistency, accessibility out-of-the-box, easy to customize

### ShadCN CLI v4 Features (for agents)

**Design System Presets:**
- Use `--preset [code]` to scaffold with a custom design system
- Presets pack colors, fonts, radius, icons into one string
- Create presets at shadcn/create, preview live, then use the code

**Safe Operations:**
- `--dry-run` — preview what gets added without writing files
- `--diff` — check for updates before merging (great for updating primitives)
- `--view` — inspect registry payload before installing

**Project Scaffolding:**
- Templates: `shadcn init --template [next|vite|laravel|react-router|astro|tanstack]`
- Monorepo: `shadcn init --monorepo`
- Dark mode included (Next.js/Vite templates)
- Choose primitives: `--base radix` (default) or `--base base-ui`

**Agent Context:**
- Reference `shadcn/skills` for coding agent guidelines on component patterns
- Use `shadcn info` to get project context (framework, components, CSS vars)
- Use `shadcn docs [component]` to get component docs/examples from CLI

**Third-party Components:**
- Install from any registry: `shadcn add @owner/component`
- Examples: `@clerk/sign-in`, `@magicui/marquee`, `tailark/hero`

---

## Active Systems (2026-03-08)

### Discord Retrospective Capture (Observer Bot)
- **Bot:** the-observer#9526  
- **Capture:** 24/7 continuous → `raw/YYYY-MM-DD.jsonl`
- **Retros:** Sun/Thu @ 22:00 → `memory/discord-retro/*.md`
- **Insight Extraction:** Auto-saves key learnings → `3. code/discord-insights/`
- **Docs:** `discord-capture/README.md`
- **Scripts:** `generate-retro.sh`, `extract-insights.sh`
- **Start:** `cd discord-capture && node bot.js`

### Discrawl (Discord Archive)
- **Purpose:** Complete Discord message backup to SQLite
- **Location:** `3. code/discrawl/`
- **Database:** `~/.discrawl/discrawl.db` (2,539+ messages indexed)
- **Search:** Local FTS5 (no API calls needed)
- **Commands:**
  ```bash
  cd /Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl
  ./bin/discrawl search "topic"      # Search messages
  ./bin/discrawl sync --since DATE   # Incremental sync
  ./bin/discrawl tail                # Live update mode
  ./bin/discrawl status              # Archive stats
  ```
- **LaunchAgent:** `ai.thejarvis.openclaw.discrawl-tail` (auto-starts on boot)
- **Tail mode logs:** `tail.log`, `tail.error`
- **Start manually:** `cd discrawl && ./bin/discrawl tail --repair-every 30m`

### QMD - Local Search Engine
- **Collections:** `brain` (2. the-brain), `crm` (4. CRM)
- **Indexed:** 388 files | 2342 vectors
- **Daily Update:** @ 06:55 (incremental index update)
- **Weekly Refresh:** Sunday @ 06:55 (full re-embedding)
- **LaunchAgent:** `ai.thejarvis.openclaw.qmd-maint`
- **Scripts:** `.scripts/qmd-maint.sh`
- **Logs:** `memory/qmd-logs/`

Commands:
```bash
qmd search "keyword" -c brain      # Fast BM25 keyword search
qmd vsearch "concept" -c brain     # Semantic vector search
qmd query "question" -c crm          # Hybrid + LLM re-ranking (best)
qmd update                           # Incremental update
qmd embed -f                         # Full re-embedding (weekly)
```

### Daily Status Report
- **Schedule:** Daily @ 07:00 (EST)
- **Recipient:** +16138893035 (iMessage)
- **LaunchAgent:** `ai.thejarvis.openclaw.daily-status`
- **Logs:** `daily-status.log`, `daily-status.error`
- **Docs:** `.scripts/daily-status-report.md`

### Google Workspace (gws)
- **Tool:** `gws` (replaces gog)
- **Auth:** jarvistheai2026@gmail.com
- **Skills:** 38 in `skills/` directory
- **Docs:** `skills/gws/README.md`
- **Test:** `gws gmail +triage --max 5`

### Discord Complete Awareness System

Three systems work together for full Discord visibility:

| System | Purpose | Location | Data |
|--------|---------|----------|------|
| **Observer Bot** | Live capture + AI retros | `discord-capture/` | JSONL → AI retro |
| **Discrawl** | Full archive + search | `3. code/discrawl/` | SQLite (2,539+ msgs) |
| **Insights** | Key learnings extraction | `3. code/discord-insights/` | Markdown → QMD index |

**Data flow:** Discord → Observer (real-time) + Discrawl (archive) → AI retro → Insights folder → QMD

**Search options:**
```bash
# Discord history (complete archive)
cd discrawl && ./bin/discrawl search "topic"

# AI-extracted insights (key learnings)
qmd query "lessons" -c discord-insights

# Combined with your knowledge
qmd query "topic"  # Searches brain + crm + discord-insights
```

### Complete Schedule

| Time | Sun | Mon | Tue | Wed | Thu | Fri | Sat |
|------|-----|-----|-----|-----|-----|-----|-----|
| **06:55** | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD | 🔍 QMD |
| **07:00** | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status |
| **22:00** | 💬 Retro/Extract | | | | 💬 Retro/Extract | | |
| **23:00** | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup |
| **24/7** | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer | 💬 Observer |
| **24/7** | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl | 📚 Discrawl |

**Notes:**
- 🔍 QMD: Daily incremental, Sunday = full re-embedding
- 📊 Status: Daily iMessage (includes QMD + Discord stats)
- 💬 Retro/Extract: Generates AI retro + extracts insights to `discord-insights/`
- 💬 Observer: Discord bot capturing messages 24/7 → `raw/YYYY-MM-DD.jsonl`
- 📚 Discrawl: SQLite archive (2,539 messages) + live tail for new messages
- 📰 News: Disabled (missing `run-scheduled.sh`)

---

Add whatever helps you do your job. This is your cheat sheet.
