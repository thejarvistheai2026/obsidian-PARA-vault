# Link Queue System

**Purpose:** Drop links anytime, process them in batches when convenient.

## How It Works

1. **Add links** to the queue (anytime, any amount)
2. **Process queue** when ready (batch process all pending links)
3. **Review results** — all captured content saved to vault

## Files

| File | Purpose |
|------|---------|
| `queue/pending.json` | Links waiting to be processed |
| `queue/processed.json` | Links already captured |
| `queue/failed.json` | Links that couldn't be processed |
| `scripts/queue-add.sh` | Add a link to the queue |
| `scripts/queue-process.sh` | Process all pending links |

## Usage

### Add a Link to Queue

```bash
# Add single link
./workflows/scripts/queue-add.sh "https://x.com/example/status/123"

# Add with note
./workflows/scripts/queue-add.sh "https://example.com/article" "Important thread on AI"
```

### Process the Queue

```bash
# Process all pending links
./workflows/scripts/queue-process.sh

# Process with limit (e.g., first 5)
./workflows/scripts/queue-process.sh --limit 5
```

### Check Queue Status

```bash
# See how many links are pending
cat workflows/queue/pending.json | jq '.links | length'

# See what's in the queue
cat workflows/queue/pending.json | jq '.links[].url'
```

## Queue Entry Format

```json
{
  "links": [
    {
      "url": "https://x.com/example/status/123",
      "added": "2026-03-14T10:00:00Z",
      "note": "Optional context",
      "source": "discord-capture-content",
      "priority": "normal"
    }
  ]
}
```

## Processing Behavior

- Links processed in FIFO order (first in, first out)
- Each link gets the full content capture treatment
- Images/screenshots saved to `attachments/`
- Markdown saved to `2. the-brain/3. resources/Articles/`
- Failed links logged for retry

## Automation Options

**Option 1: Manual batch processing**
- You add links throughout the day
- Run process script when convenient
- Review captured content

**Option 2: Scheduled processing**
- Set up cron to process queue every hour
- Links captured automatically
- You review when you want

**Option 3: Triggered processing**
- Process queue via heartbeat
- Or process on-demand via command

## Discord Integration (Active)

### How It Works

**When you drop a link in #capture-content:**
1. I automatically detect URLs
2. Add them to the queue (`workflows/queue/pending.json`)
3. Reply with acknowledgment: *"✓ Added to queue (X pending)"*
4. Process batch when convenient
5. Post summary of results

### Commands

**Check queue status:**
```
@AvaBot queue status
```

**Process the queue:**
```
@AvaBot process queue
```

**Process N links:**
```
@AvaBot process queue 5
```

### Status Updates

After processing, I'll post:
```
Queue processed!
✓ Successfully captured: 12
✗ Failed: 2
⏳ Remaining in queue: 3

Failed links:
- https://... (403 error)
- https://... (timeout)

All captured content saved to:
2. the-brain/3. resources/Articles/
```

### Daily Summary (Optional)

Can set up automatic daily summary:
```
📊 Daily Capture Summary (2026-03-14)
Links added: 24
Processed: 20
Failed: 2
Pending: 4

Top captures:
- Startup Secrets: Seize Your Story
- Community-Led Growth is the Ultimate Moat
- Building a B2B Startup From 0 to 1
...
```

This way you can drop 20 links in 2 minutes, and I'll work through them over the next hour.
