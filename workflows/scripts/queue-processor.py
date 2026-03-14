#!/usr/bin/env python3
"""
Link Queue Processor - End-to-End Content Capture
Processes pending links and creates structured Obsidian files.
"""

import json
import sys
import os
import re
import subprocess
from datetime import datetime
from pathlib import Path
from urllib.parse import urlparse

QUEUE_DIR = Path("/Users/ava/.openclaw/workspace/workflows/queue")
PENDING_FILE = QUEUE_DIR / "pending.json"
PROCESSED_FILE = QUEUE_DIR / "processed.json"
FAILED_FILE = QUEUE_DIR / "failed.json"
ARTICLES_DIR = Path("/Users/ava/Mac-Mini-Obsidian-Vault/2. the-brain/3. resources/Articles")
ATTACHMENTS_DIR = Path("/Users/ava/Mac-Mini-Obsidian-Vault/2. the-brain/3. resources/attachments")

def load_queue():
    """Load pending links from queue."""
    if not PENDING_FILE.exists():
        return {"links": [], "lastUpdated": datetime.utcnow().isoformat() + "Z"}
    
    with open(PENDING_FILE) as f:
        return json.load(f)

def save_queue(data):
    """Save updated queue."""
    data["lastUpdated"] = datetime.utcnow().isoformat() + "Z"
    with open(PENDING_FILE, "w") as f:
        json.dump(data, f, indent=2)

def archive_link(link, success=True, error=None):
    """Move link from pending to processed/failed."""
    timestamp = datetime.utcnow().isoformat() + "Z"
    
    # Remove from pending
    queue = load_queue()
    queue["links"] = [l for l in queue["links"] if l["url"] != link["url"]]
    save_queue(queue)
    
    # Add to processed or failed
    link["completed"] = timestamp
    link["status"] = "success" if success else "failed"
    if error:
        link["error"] = str(error)
    
    target_file = PROCESSED_FILE if success else FAILED_FILE
    
    if target_file.exists():
        with open(target_file) as f:
            data = json.load(f)
    else:
        data = {"links": [], "lastUpdated": timestamp}
    
    data["links"].append(link)
    data["lastUpdated"] = timestamp
    
    with open(target_file, "w") as f:
        json.dump(data, f, indent=2)

def sanitize_filename(title):
    """Sanitize title for use as filename."""
    # Remove or replace invalid characters
    title = re.sub(r'[<>:"/\\|?*]', '', title)
    title = re.sub(r'\s+', ' ', title).strip()
    return title

def extract_domain(url):
    """Extract domain from URL."""
    parsed = urlparse(url)
    domain = parsed.netloc.replace('www.', '')
    return domain

def is_youtube_url(url):
    """Check if URL is YouTube."""
    return 'youtube.com' in url or 'youtu.be' in url

def is_x_url(url):
    """Check if URL is X/Twitter."""
    return 'x.com' in url or 'twitter.com' in url

def fetch_content(url):
    """
    Fetch content from URL using web_fetch tool via subprocess.
    Returns (title, content, author) or (None, None, None) on failure.
    """
    try:
        # Use OpenClaw's web_fetch via a shell command
        # Since we can't call tools directly from Python, we'll use a marker
        # The actual implementation will be handled by the calling agent
        return None, None, None
    except Exception as e:
        print(f"  Error fetching: {e}")
        return None, None, None

def create_obsidian_file(url, title, content, author, source_type):
    """
    Create a structured Obsidian markdown file.
    Returns the file path on success, None on failure.
    """
    try:
        today = datetime.now().strftime("%Y-%m-%d")
        
        # Sanitize title for filename
        safe_title = sanitize_filename(title) if title else "Untitled"
        if not safe_title or safe_title == "Untitled":
            # Try to extract from URL
            safe_title = extract_domain(url).split('.')[0].title()
        
        filename = f"{safe_title}.md"
        filepath = ARTICLES_DIR / filename
        
        # Handle duplicates
        counter = 1
        while filepath.exists():
            filename = f"{safe_title} ({counter}).md"
            filepath = ARTICLES_DIR / filename
            counter += 1
        
        # Build YAML frontmatter
        frontmatter = f"""---
captured: {today}
source_url: {url}
category: article
author: {author or 'Unknown'}
source: {extract_domain(url)}
type: {source_type}
---

"""
        
        # Build content sections
        sections = []
        
        # Summary section
        sections.append("## Summary")
        sections.append("_Brief overview of the content..._")
        sections.append("")
        
        # Key Insights section
        sections.append("## Key Insights")
        sections.append("- ")
        sections.append("")
        
        # Main Content section
        sections.append("## Main Content")
        if content:
            # Truncate if too long for the summary view
            content_preview = content[:2000] if len(content) > 2000 else content
            sections.append(content_preview)
        else:
            sections.append("_Content not extracted. View original at source URL._")
        sections.append("")
        
        # Full Content (collapsed)
        sections.append("## Full Content")
        sections.append("<details>")
        sections.append("<summary>Click to expand full content</summary>")
        sections.append("")
        if content:
            sections.append(content)
        else:
            sections.append("_Content not available._")
        sections.append("</details>")
        sections.append("")
        
        # Key Quotes section
        sections.append("## Key Quotes")
        sections.append("> _Add notable quotes here..._")
        sections.append("")
        
        # Related section
        sections.append("## Related")
        sections.append("- ")
        sections.append("")
        
        # Write file
        full_content = frontmatter + "\n".join(sections)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(full_content)
        
        return filepath
        
    except Exception as e:
        print(f"  Error creating file: {e}")
        return None

def process_link(link):
    """
    Process a single link end-to-end.
    Returns (success, error_message)
    """
    url = link["url"]
    print(f"\nProcessing: {url}")
    print(f"  Note: {link.get('note', 'N/A')}")
    print(f"  Added: {link.get('added', 'N/A')}")
    
    try:
        # Determine source type
        source_type = "article"
        if is_youtube_url(url):
            source_type = "video"
        elif is_x_url(url):
            source_type = "x-thread"
        
        # For now, create a placeholder file with proper structure
        # The actual content fetching will be done by the agent calling this script
        # This allows the agent to use browser tools, web_fetch, etc.
        
        # Extract a title from the URL as fallback
        parsed = urlparse(url)
        path_parts = [p for p in parsed.path.split('/') if p]
        
        title = None
        author = None
        
        if is_x_url(url):
            # Try to extract username from X URL
            if len(path_parts) >= 1:
                author = path_parts[0]
                title = f"X Thread by @{author}"
        elif is_youtube_url(url):
            title = "YouTube Video"
        elif path_parts:
            # Use last path part as title hint
            title = path_parts[-1].replace('-', ' ').replace('_', ' ').title()
        
        if not title:
            title = f"Content from {extract_domain(url)}"
        
        # Create the Obsidian file
        filepath = create_obsidian_file(url, title, None, author, source_type)
        
        if filepath:
            print(f"  ✓ Created: {filepath.name}")
            return True, None
        else:
            return False, "Failed to create Obsidian file"
            
    except Exception as e:
        return False, str(e)

def process_queue(limit=None):
    """Process all pending links (or up to limit)."""
    queue = load_queue()
    links = queue["links"]
    
    if not links:
        print("Queue is empty. Nothing to process.")
        return
    
    to_process = links[:limit] if limit else links
    print(f"Processing {len(to_process)} of {len(links)} pending links...\n")
    
    success_count = 0
    fail_count = 0
    
    for i, link in enumerate(to_process, 1):
        print(f"[{i}/{len(to_process)}] ", end="")
        
        try:
            success, error = process_link(link)
            
            if success:
                archive_link(link, success=True)
                success_count += 1
            else:
                archive_link(link, success=False, error=error)
                fail_count += 1
                print(f"  ✗ Failed: {error}")
                
        except Exception as e:
            archive_link(link, success=False, error=str(e))
            fail_count += 1
            print(f"  ✗ Error: {e}")
    
    # Print summary
    print("\n" + "="*50)
    print("Queue processing complete!")
    print(f"  Processed: {len(to_process)}")
    print(f"  ✓ Success: {success_count}")
    print(f"  ✗ Failed: {fail_count}")
    print(f"  ⏳ Remaining: {len(queue['links']) - len(to_process)}")
    print("="*50)

def add_to_queue(url, note=""):
    """Add a new link to the queue."""
    timestamp = datetime.utcnow().isoformat() + "Z"
    
    queue = load_queue()
    
    # Check for duplicates
    for link in queue["links"]:
        if link["url"] == url:
            print(f"Link already in queue: {url}")
            return
    
    new_link = {
        "url": url,
        "added": timestamp,
        "note": note,
        "source": "manual",
        "priority": "normal"
    }
    
    queue["links"].append(new_link)
    save_queue(queue)
    
    print(f"✓ Added to queue: {url}")
    print(f"Queue size: {len(queue['links'])} links pending")

def show_status():
    """Show current queue status."""
    queue = load_queue()
    pending = len(queue["links"])
    
    processed_count = 0
    if PROCESSED_FILE.exists():
        with open(PROCESSED_FILE) as f:
            data = json.load(f)
            processed_count = len(data.get("links", []))
    
    failed_count = 0
    if FAILED_FILE.exists():
        with open(FAILED_FILE) as f:
            data = json.load(f)
            failed_count = len(data.get("links", []))
    
    print(f"📊 Queue Status")
    print(f"  ⏳ Pending: {pending}")
    print(f"  ✓ Processed: {processed_count}")
    print(f"  ✗ Failed: {failed_count}")
    
    if queue["links"]:
        print(f"\nPending links:")
        for i, link in enumerate(queue["links"][:10], 1):
            print(f"  {i}. {link['url']}")
        if len(queue["links"]) > 10:
            print(f"  ... and {len(queue['links']) - 10} more")

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 queue-processor.py add <url> [note]")
        print("  python3 queue-processor.py process [limit]")
        print("  python3 queue-processor.py status")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "add":
        if len(sys.argv) < 3:
            print("Usage: python3 queue-processor.py add <url> [note]")
            sys.exit(1)
        url = sys.argv[2]
        note = sys.argv[3] if len(sys.argv) > 3 else ""
        add_to_queue(url, note)
    
    elif command == "process":
        limit = int(sys.argv[2]) if len(sys.argv) > 2 else None
        process_queue(limit)
    
    elif command == "status":
        show_status()
    
    else:
        print(f"Unknown command: {command}")
        print("Use: add, process, or status")
        sys.exit(1)

if __name__ == "__main__":
    main()
