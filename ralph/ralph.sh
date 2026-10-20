#!/usr/bin/env bash
# The Ralph loop: run a fresh agent over and over, one backlog job per tick.
#
# Each tick is a new, headless Claude Code session with no memory of the last
# one; continuity lives in the repo (backlog.md, progress.md, spec/, agent-logs/).
#
# Most ticks run ralph/tick.md, which does the job at the top of the backlog.
# A reflection (ralph/reflect.md) runs instead when no open jobs remain, or on
# every RALPH_REFLECT_EVERY-th tick. If no open jobs remain after a reflection,
# the project is either finished or waiting on the owner, and the loop stops.
#
# Usage: ralph/ralph.sh [max_ticks]
# Stop it gracefully with: touch ralph/.state/STOP
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

# Settings may come from .env; the environment wins.
if [[ -f .env ]]; then
  set -a; source .env; set +a
fi
MAX_TICKS="${1:-${RALPH_MAX_TICKS:-0}}"   # 0 means no limit
REFLECT_EVERY="${RALPH_REFLECT_EVERY:-10}"
MAX_FAILURES="${RALPH_MAX_FAILURES:-3}"
read -r -a CLAUDE_ARGS <<< "${RALPH_CLAUDE_ARGS:---permission-mode auto}"

STATE="ralph/.state"
mkdir -p "$STATE"
COUNTER="$STATE/tick"
STOP="$STATE/STOP"
RUNLOG="$STATE/ralph.log"
[[ -f "$COUNTER" ]] || echo 0 > "$COUNTER"
rm -f "$STOP"

say() { echo "[ralph $(date '+%F %T')] $*" | tee -a "$RUNLOG"; }

# Jobs are top-level list items that start with a bold name (- **name**).
# Examples in the file's HTML comment are indented, so they never count.
# A job labelled [blocked] is waiting on the owner and is not open.
open_jobs() { grep '^- \*\*' backlog.md | grep -vc '\[blocked\]' || true; }
blocked_jobs() { grep '^- \*\*' backlog.md | grep -c '\[blocked\]' || true; }

ran=0
failures=0
while :; do
  if [[ -f "$STOP" ]]; then say "STOP file found; stopping."; break; fi
  if (( MAX_TICKS > 0 && ran >= MAX_TICKS )); then say "Ran $ran ticks; stopping."; break; fi

  tick=$(( $(cat "$COUNTER") + 1 ))
  jobs=$(open_jobs)
  if (( jobs == 0 )); then
    kind=reflect; why="no open jobs"
  elif (( tick % REFLECT_EVERY == 0 )); then
    kind=reflect; why="due every $REFLECT_EVERY ticks"
  else
    kind=tick; why="$jobs open jobs"
  fi

  say "Tick $tick: $kind ($why)."
  prompt="$(cat "ralph/$kind.md")

---
This is Ralph tick $tick. Session kind: $kind.
Name your session log agent-logs/$(date '+%Y-%m-%dT%H-%M')-$kind-$tick.log and record \"tick\": $tick and \"kind\": \"$kind\" in its logs.json entry."

  if claude -p "$prompt" "${CLAUDE_ARGS[@]}" >> "$RUNLOG" 2>&1; then
    failures=0
  else
    failures=$(( failures + 1 ))
    say "Tick $tick: claude exited with an error ($failures in a row)."
    if (( failures >= MAX_FAILURES )); then say "Too many failures; stopping."; break; fi
  fi

  echo "$tick" > "$COUNTER"
  ran=$(( ran + 1 ))

  if [[ -n "$(git status --porcelain)" ]]; then
    say "Tick $tick left uncommitted changes; the next tick will find them."
  fi
  if [[ $kind == reflect && $(open_jobs) -eq 0 ]]; then
    if (( $(blocked_jobs) > 0 )); then
      say "Every remaining job is blocked; see BLOCKERS.md. Stopping for the owner."
    else
      say "Reflection left the backlog empty: the project is judged complete. Stopping."
    fi
    break
  fi
done
