# HEARTBEAT.md

## Periodic Tasks

### Every 4 Hours (During Active Sessions)
- Update `self-review.md` with self-critique
  - What I did, what went well, what could be better, action items
  - Be honest about mistakes and areas to improve

### Daily (Once per day)
- Clean up old daily logs in `memory/`
  - Delete files older than 7 days
  - Command: `find memory/ -name "*.md" -mtime +7 -delete`

### Twice Daily (Morning & Evening)
- Check `active-tasks.md` for stale tasks
- Review if any completed tasks should move to `projects.md`
- Update QMD index if many new files added: `qmd update && qmd embed`

---

## State Tracking

Track last check times in `memory/heartbeat-state.json`:

```json
{
  "lastSelfReview": 1771168500,
  "lastDailyCleanup": 1771100000,
  "lastTaskReview": 1771168500
}
```

---

**Note:** These are batched checks, not every heartbeat. Rotate through them to avoid token burn.
