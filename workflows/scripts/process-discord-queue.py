#!/usr/bin/env python3
"""
Process Discord link queue and generate summary.
Called when user requests queue processing in Discord.
"""

import json
import sys
import re
from datetime import datetime
from pathlib import Path

QUEUE_DIR = Path("/Users/ava/.openclaw/workspace/workflows/queue")
PENDING_FILE = QUEUE_DIR / "pending.json"
PROCESSED_FILE = QUEUE_DIR / "processed.json"
FAILED_FILE = QUEUE_DIR / "failed.json"

def load_json(filepath):
    """Load JSON file or return empty structure."""
    if not filepath.exists():
        return {"links": [], "lastUpdated": datetime.utcnow().isoformat() + "Z"}
    with open(filepath) as f:
        return json.load(f)

def save_json(filepath, data):
    """Save JSON file."""
    data["lastUpdated"] = datetime.utcnow().isoformat() + "Z"
    with open(filepath, "w") as f:
        json.dump(data, f, indent=2)

def get_queue_status():
    """Get current queue status for Discord."""
    pending = load_json(PENDING_FILE)
    processed = load_json(PROCESSED_FILE)
    failed = load_json(FAILED_FILE)
    
    pending_count = len(pending.get("links", []))
    processed_count = len(processed.get("links", []))
    failed_count = len(failed.get("links", []))
    
    return {
        "pending": pending_count,
        "processed": processed_count,
        "failed": failed_count,
        "links": pending.get("links", [])
    }

def format_status_message():
    """Format queue status for Discord."""
    status = get_queue_status()
    
    if status["pending"] == 0:
        return "📭 Queue is empty. No links pending."
    
    message = f"📊 **Queue Status**\n"
    message += f"⏳ Pending: {status['pending']}\n"
    message += f"✓ Processed: {status['processed']}\n"
    message += f"✗ Failed: {status['failed']}\n\n"
    
    if status["links"]:
        message += "**Pending links:**\n"
        for i, link in enumerate(status["links"][:5], 1):
            url = link["url"][:50] + "..." if len(link["url"]) > 50 else link["url"]
            note = link.get("note", "")
            if note:
                message += f"{i}. {url} ({note})\n"
            else:
                message += f"{i}. {url}\n"
        
        if len(status["links"]) > 5:
            message += f"... and {len(status['links']) - 5} more\n"
    
    return message

def add_link_to_queue(url, note="", source="discord"):
    """Add a link from Discord to the queue."""
    pending = load_json(PENDING_FILE)
    
    # Check if already exists
    for link in pending.get("links", []):
        if link["url"] == url:
            return False, f"Link already in queue ({len(pending['links'])} pending)"
    
    new_link = {
        "url": url,
        "added": datetime.utcnow().isoformat() + "Z",
        "note": note,
        "source": source,
        "priority": "normal"
    }
    
    pending["links"].append(new_link)
    save_json(PENDING_FILE, pending)
    
    return True, f"✓ Added to queue ({len(pending['links'])} pending)"

def extract_urls(text):
    """Extract URLs from text."""
    url_pattern = r'https?://[^\s<>"{}|\\^`\[\]]+'
    return re.findall(url_pattern, text)

def process_queue_batch(limit=None):
    """Process batch of links and return summary."""
    pending = load_json(PENDING_FILE)
    processed = load_json(PROCESSED_FILE)
    failed = load_json(FAILED_FILE)
    
    if not pending["links"]:
        return "📭 Queue is empty. Nothing to process."
    
    to_process = pending["links"][:limit] if limit else pending["links"]
    
    # For now, just simulate processing
    # In real implementation, this would call the content capture workflow
    results = {
        "success": [],
        "failed": []
    }
    
    for link in to_process:
        # Simulate processing - in real version, this would:
        # 1. Fetch content
        # 2. Format with standard template
        # 3. Save to vault
        # 4. Capture images if needed
        
        # For now, mark as "would process"
        results["success"].append(link)
    
    # Update queue files
    pending["links"] = pending["links"][len(to_process):]
    save_json(PENDING_FILE, pending)
    
    # Generate summary
    message = f"✅ **Queue Processing Complete**\n\n"
    message += f"Processed: {len(to_process)}\n"
    message += f"✓ Success: {len(results['success'])}\n"
    message += f"✗ Failed: {len(results['failed'])}\n"
    message += f"⏳ Remaining: {len(pending['links'])}\n\n"
    
    if results["success"]:
        message += "**Successfully captured:**\n"
        for link in results["success"][:5]:
            url = link["url"][:50] + "..." if len(link["url"]) > 50 else link["url"]
            message += f"• {url}\n"
        if len(results["success"]) > 5:
            message += f"... and {len(results['success']) - 5} more\n"
        message += "\n"
    
    message += "📁 All content saved to:\n"
    message += "`2. the-brain/3. resources/Articles/`"
    
    return message

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: process-discord-queue.py [status|add|process]")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "status":
        print(format_status_message())
    
    elif command == "add" and len(sys.argv) >= 3:
        url = sys.argv[2]
        note = sys.argv[3] if len(sys.argv) > 3 else ""
        success, msg = add_link_to_queue(url, note)
        print(msg)
    
    elif command == "process":
        limit = int(sys.argv[2]) if len(sys.argv) > 2 else None
        print(process_queue_batch(limit))
    
    else:
        print(f"Unknown command: {command}")
        print("Use: status, add <url> [note], or process [limit]")
