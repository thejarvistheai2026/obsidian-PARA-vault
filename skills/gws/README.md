# Google Workspace (gws) Skills

**Status:** ✅ Active  
**Replaces:** gog (deprecated)  
**Installed:** 2026-03-07  
**Skills Count:** 38  

## Overview

Google's official CLI for Workspace APIs with native OpenClaw support. Replaces the legacy `gog` tool.

**Key Advantages:**
- Live Discovery API (always current, no updates needed)
- 38 pre-built OpenClaw skills
- Structured JSON output
- MCP server support
- Model Armor safety integration

## Authentication

**Account:** jarvistheai2026@gmail.com  
**Project:** upheld-hope-486013-p3  
**Credentials:** `~/.config/gws/credentials.enc` (AES-256-GCM encrypted)

## Core Skills

### Gmail (6 skills)
- `gws-gmail` — Core Gmail operations
- `gws-gmail-send` — Send emails
- `gws-gmail-triage` — Inbox triage helper
- `gws-gmail-watch` — Watch for new messages

### Drive (3 skills)
- `gws-drive` — File management
- `gws-drive-upload` — Quick upload helper

### Calendar (3 skills)
- `gws-calendar` — Core calendar operations
- `gws-calendar-agenda` — Today's agenda helper
- `gws-calendar-insert` — Create events

### Documents (5 skills)
- `gws-docs` — Google Docs
- `gws-docs-write` — Write to docs
- `gws-sheets` — Google Sheets
- `gws-sheets-read` — Read sheets
- `gws-sheets-append` — Append rows
- `gws-slides` — Google Slides

### Communication (4 skills)
- `gws-chat` — Google Chat
- `gws-chat-send` — Send chat messages
- `gws-meet` — Google Meet

### Workflow (5 skills)
- `gws-workflow` — Core workflows
- `gws-workflow-standup-report` — Daily standup
- `gws-workflow-weekly-digest` — Weekly summary
- `gws-workflow-meeting-prep` — Meeting prep
- `gws-workflow-file-announce` — File announcements
- `gws-workflow-email-to-task` — Email → Tasks

### Safety (3 skills)
- `gws-modelarmor` — Safety filtering
- `gws-modelarmor-sanitize-prompt` — Sanitize prompts
- `gws-modelarmor-sanitize-response` — Sanitize responses

### Other
- `gws-forms` — Google Forms
- `gws-keep` — Google Keep
- `gws-tasks` — Google Tasks
- `gws-classroom` — Google Classroom
- `gws-events` — Events management
- `gws-people` — Contacts
- `gws-shared` — Shared utilities
- `gws-admin-reports` — Admin reports

## Quick Commands

```bash
# Gmail
gws gmail users.messages list --params '{"userId": "me", "maxResults": 10}'
gws gmail +triage --max 5
gws gmail +send --to "user@example.com" --subject "Hi" --body "Hello"

# Drive
gws drive files list --params '{"pageSize": 10}'
gws drive +upload --file ./document.pdf

# Calendar
gws calendar +agenda
gws calendar events list --params '{"calendarId": "primary", "maxResults": 10}'

# Sheets
gws sheets +read --spreadsheet-id SHEET_ID --range 'Sheet1!A1:C10'
gws sheets +append --spreadsheet-id SHEET_ID --range 'Sheet1' --values '["data1", "data2"]'
```

## Migration from gog

| gog (old) | gws (new) |
|-----------|-----------|
| `gog gmail search` | `gws gmail +triage` or `gws gmail users.messages list` |
| `gog gmail send` | `gws gmail +send` |
| `gog calendar events` | `gws calendar +agenda` |
| `gog drive files` | `gws drive files list` |

## Documentation

- **Official Repo:** https://github.com/googleworkspace/cli
- **OpenClaw Setup:** See MEMORY.md section "Google Workspace CLI (gws)"
- **COMMANDS.md:** Updated quick reference commands
- **SETUP.md:** System configuration details

## Troubleshooting

### Auth Issues
```bash
# Re-authenticate
gws auth login

# Check status
gws auth status
```

### Reset Everything
```bash
rm ~/.config/gws/credentials.enc
gws auth login
```

## Notes

- All skills symlinked from `gws-cli/skills/` directory
- Discovery API ensures commands always match current Google APIs
- Model Armor provides built-in safety filtering
