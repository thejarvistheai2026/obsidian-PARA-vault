# MEMORY.md - Long-term Knowledge

## PARA Structure

```
Mac-Mini-Obsidian-Vault/
├── 1. openclaw/          ← Agent workspace (configs, memory, workflows)
├── 2. the-brain/         ← Knowledge base (projects, areas, resources, archive)
├── 3. code/              ← Code projects (newsletter-system, skills, etc.)
├── 4. CRM/               ← People, contacts, relationships
└── .obsidian/            ← Obsidian config
```

## GitHub Backup System

| Source | Repo | URL |
|--------|------|-----|
| `1. openclaw/` | `openclaw-obsidian-workspace-backup` | https://github.com/thejarvistheai2026/openclaw-obsidian-workspace-backup |
| `2. the-brain/` | `PARA-Obsidian-vault-backup` | https://github.com/thejarvistheai2026/PARA-Obsidian-vault-backup |
| `4. CRM/` | `obsidian-crm` | https://github.com/thejarvistheai2026/obsidian-crm |
| `3. code/newsletter-system/` | `jarvis-newsletter-system` | https://github.com/thejarvistheai2026/jarvis-newsletter-system |

**Backup:** Daily at 23:00 via LaunchAgent → `1. openclaw/.scripts/daily-backup.sh`

## Newsletter System

**Location:** `3. code/newsletter-system/`
**Output:** `2. the-brain/3. resources/Newsletters/`
**Database:** `3. code/newsletter-system/data/state.db`
**Schedule:** Sundays + Thursdays

**Key paths (hardcoded):**
- `NEWSLETTERS_DIR` → `2. the-brain/3. resources/Newsletters`
- `DB_FILE` → `3. code/newsletter-system/data/state.db`

## Key Decisions (2026-03-02)

1. **No symlinks** — cause Obsidian Sync conflicts
2. **Separate repos** — recoverable pieces, not one giant repo
3. **Scripts use hardcoded paths** — numbered folders don't change
4. **Sanitized OpenClaw config** — tokens redacted in backups

## Workflows

**YouTube Transcripts:** `1. openclaw/workflows/youtube-transcript.sh`
- Saves to: `2. the-brain/3. resources/[Subject]/`
- Auto-detects subject from video title

## Obsidian Best Practices

**Plugins to install:**
1. Templater — templates
2. QuickAdd — quick capture
3. Dataview — queries
4. Calendar — daily notes nav

**Naming:** `YYYY-MM-DD - description-with-hyphens.md`

## Recovery

If vault is lost:
1. Clone all 4 repos above
2. Place in correct numbered folders
3. Update OpenClaw config workspace path
4. Run newsletter scripts to verify paths
