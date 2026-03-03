# lessons.md - Mistakes Library

*Every mistake, documented once, never repeated*

## Lesson 001 — Didn't check TOOLS.md before asking about environment
**Date:** 2026-02-16
**What happened:** Asked Franco about Obsidian vault location even though he's told me before
**Why it failed:** I have a TOOLS.md file specifically for his environment, but I didn't check it first
**Lesson:** Always check TOOLS.md before asking "where is X?" or "do you have Y?"
**Action:** Added explicit rule to AGENTS.md

---

## Lesson 002 — DigitalOcean App Platform gets wedged
**Date:** 2026-02-16
**What happened:** Spent 6 hours debugging why website returned 404 on all routes. Build succeeded, server started, but no pages served.
**Why it failed:** The DO app was in a broken state where compiled `.next` folder wasn't in runtime container. Tried: standalone mode, custom server.js, debug endpoints, config files — nothing worked.
**Lesson:** When DO App Platform acts weird (build OK but runtime 404), **destroy and recreate the app immediately**. Don't debug for hours — the platform state can get corrupted.
**Action:** Documented in active-tasks.md and daily log. Use "nuke and rebuild" as first resort for DO deployment issues.

---

## Lesson Template (copy for new lessons)
```
## Lesson XXX — [Brief description]
**Date:** YYYY-MM-DD
**What happened:** 
**Why it failed:** 
**Lesson:** 
**Action:** 
```

---
## Lesson 003 — Ollama Cloud models can fail silently with outdated versions
**Date:** 2026-02-27
**What happened:** All Ollama cloud models (Kimi, Minimax) returned TLS certificate errors and model not found (404). OpenClaw sessions completely failed, taking me offline everywhere.
**Why it failed:** Ollama was on version 0.16.3 (outdated). Latest is 0.17.4. The older version had SSL certificate verification bugs that broke Ollama Cloud connectivity. Also, the model name in config was wrong — used "kimi" instead of "kimi-k2.5:cloud".
**Lesson:** 
1. Keep Ollama updated — cloud models depend on it
2. Check exact model names — "kimi" ≠ "kimi-k2.5:cloud"
3. Test models directly via curl before relying on them in OpenClaw
4. When Ollama cloud fails, fall back to Anthropic immediately (it's the lifeline)
**Action:** 
1. Set up periodic Ollama version checks
2. Document exact working model names in config
3. Always maintain Anthropic as fallback for critical sessions

---
*Review before making similar decisions*
