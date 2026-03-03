# YouTube Transcript Workflow

A complete system for transcribing YouTube videos into Obsidian.

## Quick Start

### 1. Transcribe a Single Video
```
Transcribe this YouTube: https://youtube.com/watch?v=ABC123
```

### 2. Search and Transcribe
```
Find and transcribe top 5 videos with Peter Thiel
```

### 3. Transcribe Channel Videos
```
Transcribe latest 10 videos from Lex Fridman Podcast
```

## How It Works

1. **Input**: You provide a YouTube URL or natural language search
2. **Search** (if needed): Uses web search to find top videos
3. **Fetch**: Downloads transcript via yt-dlp
4. **Format**: Cleans and structures the transcript
5. **Save**: Creates folder + saves to `/2. the-brain/3. resources/[Subject]/[date] - [video-title].md`

## Output Structure

```
/2. the-brain/3. resources/
├── Peter Thiel/
│   ├── 2025-02-25 - Zero to One Interview.md
│   └── 2025-02-24 - Stanford Lecture.md
├── Founders Podcast/
│   └── 2025-02-25 - episode-transcript.md
└── ...
```

## Manual Usage (Shell Script)

```bash
# Single video
/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/workflows/youtube-transcript.sh "https://youtu.be/ABC123" "Peter Thiel"

# With timestamps
/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/workflows/youtube-transcript.sh "https://youtu.be/ABC123" "Peter Thiel" --timestamps

# Search mode (top 5)
/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/workflows/youtube-transcript.sh --search "Peter Thiel interview" "Peter Thiel" --limit 5
```

## Requirements

- yt-dlp (installed ✓)
- No API keys required for transcripts

## Features

- ✅ Single video transcription
- ✅ Batch search + transcribe
- ✅ Auto-generated timestamps (optional)
- ✅ Clean markdown formatting
- ✅ Video metadata preserved
- ✅ Automatic folder creation
- ✅ Duplicate detection

## Tips

- Be specific in search queries for better results
- Channel names work great: "latest from [Channel Name]"
- Timestamps add size but help with navigation
- Transcripts are automatically titled with video title + date
