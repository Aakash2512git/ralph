# Ralph Loop (Bob Shell)

Autonomous agent loop that works through a PRD one user story at a time using [Bob Shell](https://github.com/bob-shell/bob) in non-interactive mode.

## What it does

1. Reads `prd.json` for user stories (highest priority first)
2. Runs Bob with `prompt.md` instructions each iteration
3. Bob implements one story, commits, updates `prd.json` and `progress.txt`
4. Repeats until all stories pass or max iterations is reached

## Requirements

- [Bob Shell](https://github.com/bob-shell/bob) (`bob` on PATH)
- `jq`
- `git`

## Quick start

```bash
# In your app repo, copy Ralph into the project (or use this repo as a submodule)
cp -r /path/to/ralph ./ralph

# Create your PRD from the example
cp ralph/prd.json.example ralph/prd.json
# Edit ralph/prd.json with your project and user stories

# Run from project root
chmod +x ralph/ralph.sh
./ralph/ralph.sh          # default: 10 iterations
./ralph/ralph.sh 20       # custom max iterations
```

## Files

| File | Purpose |
|------|---------|
| `ralph.sh` | Main loop script |
| `prompt.md` | Instructions given to Bob each iteration |
| `prd.json` | Task list (gitignored — use `prd.json.example` as template) |
| `progress.txt` | Learnings and iteration log (gitignored) |
| `skills/` | BOB skills for PRD generation and Ralph JSON conversion |

Articles : https://heidloff.net/article/bob-ralph-wiggum/
