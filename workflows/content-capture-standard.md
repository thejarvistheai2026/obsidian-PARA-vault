# Content Capture Standard

**Applies to:** All links shared in #capture-content (YouTube, Twitter/X, articles, etc.)

## Output Location
`2. the-brain/3. resources/Articles/[descriptive-title].md`

## Standard Format

```markdown
---
captured: YYYY-MM-DD
source_url: [original URL]
category: [transcript | article | thread | etc]
author: [if known]
context: [if relevant]
---

# [Title]

## Summary
2-3 sentence overview of what this is and why it matters.

## Key Insights
- Bullet point 1
- Bullet point 2
- Bullet point 3

## Frameworks / Models (if applicable)
### Framework Name
- **Component 1** — description
- **Component 2** — description

## Stats / Data (if applicable)
| Metric | Value |
|--------|-------|
| Stat 1 | Value 1 |
| Stat 2 | Value 2 |

## Key Quotes
> "Punchy quote that stands alone"

## Full Content
<details>
<summary>Expand for complete content</summary>

[Full transcript, thread text, or article content]

</details>
```

## Processing Rules

1. **Always extract structure** — frameworks, stats, key concepts
2. **Use tables** for data comparisons
3. **Use blockquotes** for memorable one-liners
4. **Collapse the raw content** — full text available but not in the way
5. **Add context** — who said it, where, why it matters

## Content-Specific Handling

### YouTube Videos
- Extract transcript via youtube-transcript-api
- Identify frameworks/methods taught
- Pull stats mentioned
- Note speaker credentials

### Twitter/X Threads
- Unroll thread (chronological order)
- Group by theme if thread jumps topics
- Extract key claims and supporting points
- Note any linked resources
- **Capture images/diagrams** — screenshot and save to `assets/` folder, reference in markdown

### Articles/Blog Posts
- Preserve original structure (headers → headers)
- Extract key arguments
- Note publication/source credibility
- Capture any cited data/studies
- **Capture images/diagrams** — download or screenshot, save to `assets/` folder

## Image Handling

When content includes diagrams, charts, or visual frameworks:

1. **Screenshot or download** the image
2. **Save to:** `2. the-brain/3. resources/attachments/[descriptive-name].jpg`
3. **Reference in markdown:** `![Alt text](../attachments/filename.jpg)`
4. **Include context:** Explain what the diagram shows in the text

Images are part of the knowledge capture — not just decoration.

## Automation

This format applies automatically to all links shared in #capture-content unless specified otherwise.
