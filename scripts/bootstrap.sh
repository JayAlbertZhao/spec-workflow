#!/usr/bin/env bash
# bootstrap.sh — start a new project on top of spec-workflow.
#
# What it does:
#   1. Clones spec-workflow into the target directory.
#   2. Discards the spec-workflow git history; initializes fresh git for your project.
#   3. Appends `## Brief`, `## Specs in Use`, `## Project-Specific Overrides` sections
#      to CLAUDE.md (base content stays at the top).
#   4. Creates an empty `.agents/` directory.
#   5. Launches `claude` in the target dir (unless --no-launch).
#
# Usage:
#   bootstrap.sh [target] [--brief "<text>" | --brief-file <path>] [--no-launch]
#
#   target          target directory; default "." (must be empty or non-existent)
#   --brief         one-paragraph project description written into ## Brief
#   --brief-file    same, but read from a file
#   --no-launch     don't run `claude` at the end
#
# One-liner for first-time users:
#   bash <(curl -fsSL https://raw.githubusercontent.com/JayAlbertZhao/spec-workflow/main/scripts/bootstrap.sh) [target] [--brief "..."]

set -euo pipefail

REPO_URL="${SPEC_WORKFLOW_REPO:-https://github.com/JayAlbertZhao/spec-workflow.git}"
TARGET=""
BRIEF=""
LAUNCH=true

usage() {
  sed -n '2,22p' "${BASH_SOURCE[0]}" | sed -E 's/^# ?//'
  exit "${1:-0}"
}

while (( $# )); do
  case "$1" in
    --brief)
      [[ $# -ge 2 ]] || { echo "--brief needs a value" >&2; exit 2; }
      BRIEF="$2"; shift 2 ;;
    --brief-file)
      [[ $# -ge 2 ]] || { echo "--brief-file needs a path" >&2; exit 2; }
      [[ -f "$2" ]] || { echo "brief file not found: $2" >&2; exit 2; }
      BRIEF="$(cat "$2")"; shift 2 ;;
    --no-launch)
      LAUNCH=false; shift ;;
    -h|--help)
      usage 0 ;;
    --)
      shift; break ;;
    -*)
      echo "unknown flag: $1" >&2; usage 2 ;;
    *)
      if [[ -z "$TARGET" ]]; then TARGET="$1"; else
        echo "unexpected extra arg: $1" >&2; usage 2
      fi
      shift ;;
  esac
done

TARGET="${TARGET:-.}"

# Resolve target. "." means current dir; must be empty.
if [[ "$TARGET" == "." ]]; then
  TARGET="$PWD"
fi
TARGET="$(cd "$(dirname "$TARGET")" 2>/dev/null && pwd)/$(basename "$TARGET")" || {
  echo "cannot resolve parent of: $TARGET" >&2; exit 1
}

if [[ -e "$TARGET" && -d "$TARGET" ]]; then
  if [[ -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
    echo "target is not empty: $TARGET" >&2
    echo "refusing to clone over existing content. Pick an empty or non-existent path." >&2
    exit 1
  fi
elif [[ -e "$TARGET" ]]; then
  echo "target exists and is not a directory: $TARGET" >&2; exit 1
fi

echo "==> cloning spec-workflow into: $TARGET"
git clone --depth=1 "$REPO_URL" "$TARGET"
cd "$TARGET"

echo "==> resetting git history (this is your project, not a fork)"
rm -rf .git

# Append project layer to CLAUDE.md if not already there.
if grep -q '^## Brief$' CLAUDE.md 2>/dev/null; then
  echo "==> CLAUDE.md already has ## Brief; skipping append"
else
  echo "==> appending project layer to CLAUDE.md"
  brief_block="${BRIEF:-<fill in: one-paragraph description of what this project is. The orchestrator reads this on first run to auto-route specs via specs/route.md.>}"
  cat >> CLAUDE.md <<EOF

---

# Project Layer

(Everything below this line is your project's. Base updates from spec-workflow only modify what is above. Safe to edit freely.)

## Brief

$brief_block

## Specs in Use

<empty — orchestrator will auto-route on first run via specs/route.md; you may edit this list afterward>

## Project-Specific Overrides

<phase list, sprint conventions, domain constraints, any rule that overrides or extends a loaded spec for THIS project only>
EOF
fi

# Project README — placeholder so the base's BASE_README stays untouched.
if [[ ! -f README.md ]]; then
  echo "==> writing minimal README.md"
  cat > README.md <<EOF
# $(basename "$TARGET")

(Project README — fill in as the project takes shape. The spec-workflow base lives in \`BASE_README.md\` and \`specs/\`; you don't normally touch those.)
EOF
fi

# .agents/ — communication scratch the orchestrator + sub-agents use.
mkdir -p .agents

# Fresh git history.
echo "==> initializing fresh git"
git init -q -b main 2>/dev/null || git init -q
git add -A
git -c user.email="bootstrap@spec-workflow.local" \
    -c user.name="spec-workflow bootstrap" \
    commit -q -m "chore: bootstrap from spec-workflow"

echo
echo "Bootstrapped at: $TARGET"
echo
echo "Next steps:"
echo "  1. Edit CLAUDE.md ## Brief if not already filled."
echo "  2. Run \`claude\` here — the orchestrator will route specs on first run."
echo

if $LAUNCH && command -v claude >/dev/null 2>&1; then
  echo "==> launching claude"
  exec claude
else
  if ! command -v claude >/dev/null 2>&1; then
    echo "(claude CLI not on PATH; run it manually when ready.)"
  fi
fi
