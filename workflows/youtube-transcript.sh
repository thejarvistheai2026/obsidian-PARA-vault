#!/bin/bash

# YouTube Transcript Script
# Usage: ./youtube-transcript.sh [URL|"--search QUERY"] [SUBJECT] [OPTIONS]

set -e

# Base path for saved transcripts
BASE_PATH="/Users/jarvis/Mac-Mini-Obsidian-Vault/2. the-brain/3. resources"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help message
show_help() {
    cat << EOF
YouTube Transcript Script

Usage:
  $0 "https://youtube.com/watch?v=VIDEO_ID" "Subject Name"
  $0 --search "search query" "Subject Name" [--limit N]

Options:
  --search QUERY    Search for videos matching query
  --limit N         Limit search results (default: 5)
  --timestamps      Include timestamps in transcript
  -h, --help        Show this help message

Examples:
  $0 "https://youtu.be/ABC123" "Peter Thiel"
  $0 --search "Peter Thiel interview" "Peter Thiel" --limit 10
  $0 "https://youtu.be/ABC123" "Lex Fridman" --timestamps
EOF
}

# Parse arguments
SEARCH_MODE=false
SEARCH_QUERY=""
SUBJECT=""
URL=""
LIMIT=5
TIMESTAMPS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --search)
            SEARCH_MODE=true
            SEARCH_QUERY="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --timestamps)
            TIMESTAMPS=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            if [[ -z "$URL" && "$SEARCH_MODE" == false ]]; then
                URL="$1"
            elif [[ -z "$SUBJECT" ]]; then
                SUBJECT="$1"
            fi
            shift
            ;;
    esac
done

# Validate required arguments
if [[ "$SEARCH_MODE" == true && -z "$SEARCH_QUERY" ]]; then
    echo -e "${RED}Error: Search query required${NC}"
    show_help
    exit 1
fi

if [[ "$SEARCH_MODE" == false && -z "$URL" ]]; then
    echo -e "${RED}Error: URL required (or use --search)${NC}"
    show_help
    exit 1
fi

if [[ -z "$SUBJECT" ]]; then
    echo -e "${RED}Error: Subject name required as second argument${NC}"
    show_help
    exit 1
fi

# Create subject directory
SUBJECT_DIR="$BASE_PATH/$SUBJECT"
mkdir -p "$SUBJECT_DIR"

echo -e "${YELLOW}Saving transcripts to: $SUBJECT_DIR${NC}"

# Function to extract video info and transcript
process_video() {
    local video_url="$1"
    local video_id

    # Extract video ID
    if [[ "$video_url" =~ v=([a-zA-Z0-9_-]{11}) ]]; then
        video_id="${BASH_REMATCH[1]}"
    elif [[ "$video_url" =~ youtu\.be/([a-zA-Z0-9_-]{11}) ]]; then
        video_id="${BASH_REMATCH[1]}"
    else
        echo -e "${RED}Error: Could not extract video ID from URL${NC}"
        return 1
    fi

    echo -e "${YELLOW}Processing video: $video_id${NC}"

    # Get video metadata using yt-dlp
    local metadata
    if ! metadata=$(yt-dlp --dump-json --no-download "$video_url" 2>/dev/null); then
        echo -e "${RED}Error: Could not fetch video metadata${NC}"
        return 1
    fi

    local title=$(echo "$metadata" | python3 -c "import sys,json; print(json.load(sys.stdin)['title'])")
    local channel=$(echo "$metadata" | python3 -c "import sys,json; print(json.load(sys.stdin)['channel'])")
    local upload_date=$(echo "$metadata" | python3 -c "import sys,json; print(json.load(sys.stdin)['upload_date'])")
    local duration=$(echo "$metadata" | python3 -c "import sys,json; print(json.load(sys.stdin)['duration'])")

    # Format filename
    local formatted_date="${upload_date:0:4}-${upload_date:4:2}-${upload_date:6:2}"
    local safe_title=$(echo "$title" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | cut -c1-50)
    local filename="$formatted_date - $safe_title.md"
    local filepath="$SUBJECT_DIR/$filename"

    # Check for duplicate
    if [[ -f "$filepath" ]]; then
        echo -e "${YELLOW}Transcript already exists: $filename${NC}"
        return 0
    fi

    echo -e "${YELLOW}Fetching transcript for: $title${NC}"

    # Try to get transcript using youtube-transcript-api
    local transcript_text=""
    if command -v python3 &> /dev/null; then
        transcript_text=$(python3 << PYEOF
import sys
try:
    from youtube_transcript_api import YouTubeTranscriptApi
    transcript_list = YouTubeTranscriptApi.get_transcript("$video_id")
    formatter = lambda x: f"[{x['start']:.0f}s] {x['text']}" if $TIMESTAMPS else lambda x: x['text']
    print('\n'.join(formatter(item) for item in transcript_list))
except Exception as e:
    sys.exit(1)
PYEOF
        )
    fi

    # Fallback: use yt-dlp subtitles if python method fails
    if [[ -z "$transcript_text" ]]; then
        echo -e "${YELLOW}Using yt-dlp fallback for subtitles...${NC}"
        local temp_dir=$(mktemp -d)
        yt-dlp --write-auto-sub --sub-langs en --skip-download --output "$temp_dir/%(title)s.%(ext)s" "$video_url" 2>/dev/null || true

        local subtitle_file=$(find "$temp_dir" -name "*.vtt" | head -1)
        if [[ -f "$subtitle_file" ]]; then
            transcript_text=$(sed '/^WEBVTT/d; /^NOTE/d; /^[0-9]/d; s/<[^>]*>//g; s/^.*-->.*$//d; /^$/d' "$subtitle_file" | tr '\n' ' ' | sed 's/  */ /g')
        fi
        rm -rf "$temp_dir"
    fi

    # If still no transcript, try audio extraction + whisper
    if [[ -z "$transcript_text" ]] && command -v whisper &> /dev/null; then
        echo -e "${YELLOW}Attempting audio extraction + Whisper transcription...${NC}"
        local temp_dir=$(mktemp -d)
        local audio_file="$temp_dir/audio.mp3"

        if yt-dlp -x --audio-format mp3 --output "$temp_dir/audio.%(ext)s" "$video_url" 2>/dev/null; then
            audio_file=$(find "$temp_dir" -name "*.mp3" | head -1)
            if [[ -f "$audio_file" ]]; then
                transcript_text=$(whisper "$audio_file" --model tiny --output_format txt 2>/dev/null | cat)
            fi
        fi
        rm -rf "$temp_dir"
    fi

    # Write markdown file
    {
        echo "# $title"
        echo ""
        echo "**Channel:** $channel"
        echo "**URL:** $video_url"
        echo "**Published:** $formatted_date"
        echo "**Duration:** $(($duration / 60)):$(printf "%02d" $(($duration % 60)))"
        echo "**Subject:** $SUBJECT"
        echo "**Transcribed:** $(date '+%Y-%m-%d %H:%M')"
        echo ""
        echo "---"
        echo ""
        if [[ -n "$transcript_text" ]]; then
            echo "## Transcript"
            echo ""
            echo "$transcript_text"
        else
            echo "## Transcript"
            echo ""
            echo "*Could not retrieve transcript. Video may not have auto-generated captions or transcript may be disabled.*"
        fi
    } > "$filepath"

    echo -e "${GREEN}✓ Saved: $filename${NC}"
}

# Main execution
if [[ "$SEARCH_MODE" == true ]]; then
    echo -e "${YELLOW}Searching for: $SEARCH_QUERY (limit: $LIMIT)${NC}"

    # Use yt-dlp to search
    local video_urls
    video_urls=$(yt-dlp "ytsearch$LIMIT:$SEARCH_QUERY" --get-id --no-download 2>/dev/null)

    if [[ -z "$video_urls" ]]; then
        echo -e "${RED}Error: No videos found${NC}"
        exit 1
    fi

    local count=0
    while IFS= read -r video_id; do
        if [[ -n "$video_id" ]]; then
            count=$((count + 1))
            echo -e "\n${YELLOW}[$count/$LIMIT] Processing...${NC}"
            process_video "https://youtube.com/watch?v=$video_id"
        fi
    done <<< "$video_urls"

    echo -e "\n${GREEN}✓ Processed $count videos to: $SUBJECT_DIR${NC}"
else
    process_video "$URL"
fi
