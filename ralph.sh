#!/bin/bash
# Ralph loop for Bob Shell — run from project root: ./ralph/ralph.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAX_ITERATIONS=10
PROJECT_ROOT=""

usage() {
  cat <<'EOF'
Usage: ./ralph/ralph.sh [options] [max_iterations]

Options:
  --project-root PATH   App project root (default: parent of ralph/ folder)
  -h, --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root) PROJECT_ROOT="$2"; shift 2 ;;
    --project-root=*) PROJECT_ROOT="${1#*=}"; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      if [[ "$1" =~ ^[0-9]+$ ]]; then MAX_ITERATIONS="$1"; else echo "Unknown: $1"; usage; exit 1; fi
      shift ;;
  esac
done

if [[ -z "$PROJECT_ROOT" ]]; then
  if [[ "$(basename "$SCRIPT_DIR")" == "ralph" ]]; then
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
  elif git -C "$PWD" rev-parse --show-toplevel >/dev/null 2>&1; then
    PROJECT_ROOT="$(git -C "$PWD" rev-parse --show-toplevel)"
  else
    PROJECT_ROOT="$PWD"
  fi
fi

PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"

PRD_FILE="$SCRIPT_DIR/prd.json"
PROGRESS_FILE="$SCRIPT_DIR/progress.txt"
ARCHIVE_DIR="$SCRIPT_DIR/archive"
LAST_BRANCH_FILE="$SCRIPT_DIR/.last-branch"
PROMPT_FILE="$SCRIPT_DIR/prompt.md"

require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Error: '$1' required"; exit 1; }; }

init_progress() {
  { echo "# Ralph Progress Log"; echo "Started: $(date)"; echo "---"; } > "$1"
}

require_cmd bob; require_cmd jq; require_cmd git

[[ -f "$PRD_FILE" ]] || { echo "Missing $PRD_FILE"; exit 1; }
[[ -f "$PROMPT_FILE" ]] || { echo "Missing $PROMPT_FILE"; exit 1; }

if [[ -f "$PRD_FILE" && -f "$LAST_BRANCH_FILE" ]]; then
  CURRENT_BRANCH="$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")"
  LAST_BRANCH="$(cat "$LAST_BRANCH_FILE" 2>/dev/null || echo "")"
  if [[ -n "$CURRENT_BRANCH" && -n "$LAST_BRANCH" && "$CURRENT_BRANCH" != "$LAST_BRANCH" ]]; then
    DATE="$(date +%Y-%m-%d)"
    FOLDER_NAME="$(echo "$LAST_BRANCH" | sed 's|^ralph/||')"
    ARCHIVE_FOLDER="$ARCHIVE_DIR/$DATE-$FOLDER_NAME"
    echo "Archiving previous run: $LAST_BRANCH → $ARCHIVE_FOLDER"
    mkdir -p "$ARCHIVE_FOLDER"
    cp "$PRD_FILE" "$ARCHIVE_FOLDER/"
    [[ -f "$PROGRESS_FILE" ]] && cp "$PROGRESS_FILE" "$ARCHIVE_FOLDER/"
    init_progress "$PROGRESS_FILE"
  fi
fi

CURRENT_BRANCH="$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")"
[[ -n "$CURRENT_BRANCH" ]] && echo "$CURRENT_BRANCH" > "$LAST_BRANCH_FILE"
[[ -f "$PROGRESS_FILE" ]] || init_progress "$PROGRESS_FILE"

echo "Starting Ralph (Bob Shell)"
echo "  Project root:    $PROJECT_ROOT"
echo "  Ralph directory: $SCRIPT_DIR"
echo "  Max iterations:  $MAX_ITERATIONS"
echo ""

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo ""
  echo "==============================================================="
  echo " Ralph Iteration $i of $MAX_ITERATIONS (Bob Shell)"
  echo "==============================================================="

  OUTPUT_FILE="$(mktemp)"
  (
    cd "$PROJECT_ROOT"
    cat "$PROMPT_FILE" | bob --yolo --chat-mode code --hide-intermediary-output 2>&1
  ) | tee /dev/stderr | tee "$OUTPUT_FILE" || true

  if grep -q "<promise>COMPLETE</promise>" "$OUTPUT_FILE"; then
    rm -f "$OUTPUT_FILE"
    echo ""; echo "Ralph completed all tasks!"; exit 0
  fi

  rm -f "$OUTPUT_FILE"
  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo ""; echo "Max iterations reached. Check $PROGRESS_FILE"; exit 1
