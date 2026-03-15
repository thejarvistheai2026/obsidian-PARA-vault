# WORKFLOW-PROTOCOLS.md

**Purpose:** Ensure quality work and clear communication

---

## Protocol 1: Trust, But Verify

**Rule:** Never assume success based on exit codes or output messages. Actually verify the result.

### When to Verify

| Task Type | Verification Method |
|-----------|---------------------|
| **File created** | Check file exists AND has content (`ls -la` + `head` or `wc -l`) |
| **Config edited** | Read back the changed section to confirm it took effect |
| **Service started** | Check process is running (`ps`, `pgrep`) AND responding |
| **Git commit/push** | Verify with `git log` or check remote status |
| **Backup created** | Confirm file exists, has size, and is readable |
| **Download/Install** | Check the binary/file exists and is executable |

### Verification Template

After claiming something worked, always add:

```
✅ Verified: [what you checked]
- File exists: yes/no
- Has content: X bytes / Y lines
- [Other relevant check]
```

### Example

**❌ Without verification:**
> "Created backup script."

**✅ With verification:**
> "Created backup script."
> "✅ Verified:"
> "- File exists: /path/to/script.sh"
> "- Has content: 1,114 bytes, 36 lines"
> "- Is executable: yes (chmod +x applied)"

---

## Protocol 2: Recap + Next Step

**Rule:** After every operation or group of related operations, provide:
1. **What was done** (bullet summary)
2. **Current status** (working/broken/pending)
3. **Next step** (what happens next OR what I need from you)

### Template

```
---

## ✅ COMPLETE: [Task Name]

**What was done:**
- [Action 1]
- [Action 2]
- [Action 3]

**Current status:** [working / needs verification / failed / pending]

**Next step:** [what happens next]

---
```

### Examples

**When I'm done and waiting for you:**
> ---
> 
> ## ✅ COMPLETE: System scan
> 
> **What was done:**
> - Checked 5 services
> - Found 2 issues (discrawl down, newsletter script error)
> - Verified all GitHub repos are synced
> 
> **Current status:** Ready for fixes
> 
> **Next step:** Your call — want me to fix discrawl first, or something else?
> 
> ---

**When there's more work to do:**
> ---
> 
> ## ✅ COMPLETE: Config backup script created
> 
> **What was done:**
> - Created backup script
> - Created LaunchAgent (runs at 23:30 daily)
> - Loaded into launchctl
> 
> **Current status:** ✅ Loaded and ready
> 
> **Next step:** Testing — I'll run the script now to verify it works
> > *[proceeds to run script]*
> 
> ---

**When something failed:**
> ---
> 
> ## ❌ ISSUE: Discrawl binary missing
> 
> **What was done:**
> - Checked discrawl directory
> - Found `bin/` folder is empty
> - Attempted to locate binary — not found
> 
> **Current status:** 🔴 Discrawl is down (no binary)
> 
> **Next step:** Need to rebuild from source. Approve? (This will take ~5 minutes)
> 
> ---

---

## Combined Example

**User:** "Create a backup script."

**My response:**

> I need to create a backup script and LaunchAgent. This will:
> - Create `/path/to/backup.sh`
> - Set up daily runs at 23:30
> - Load into launchctl
> 
> Approve?

**User:** "Yes"

**[I do the work]**

**My response:**

> ---
> 
> ## ✅ COMPLETE: Backup script created
> 
> **What was done:**
> - Created `backup-openclaw-config.sh` (1,170 bytes)
> - Created LaunchAgent plist (runs at 23:30 daily)
> - Loaded into launchctl
> 
> **Verification:**
> - ✅ Script exists and is executable
> - ✅ LaunchAgent loaded (`launchctl list` shows it)
> - ✅ Logs will write to `.scripts/config-backup.log`
> 
> **Current status:** ✅ Ready — first run tonight at 23:30
> 
> **Next step:** Test run now to confirm it works? (Or move on to something else?)
> 
> ---

---

## Why This Matters

**Trust but verify:**
- Exit code 0 doesn't mean the file has content
- "Created" doesn't mean it's correct
- Assumptions lead to debugging later

**Recap + next step:**
- You know exactly what happened
- You know if I'm waiting or still working
- You can make informed decisions
- No ambiguity about state

---

**Last updated:** 2026-03-15
**Applies to:** All work, all the time
