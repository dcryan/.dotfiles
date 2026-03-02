#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  issue_fix_flow.sh --issue-number <num> [options]

Options:
  --issue-number <num>       GitLab issue IID (required)
  --task-slug <slug>         Branch slug suffix; if omitted derive from issue title
  --branch-type <fix|feature> Branch prefix (default: fix)
  --base-branch <name>       Target/base branch (default: main)
  --commit-message <msg>     Commit message to use
  --mr-title <title>         Merge request title
  --dry-run                  Print commands without executing (default)
  --execute                  Execute commands
  --help                     Show this help

Notes:
  - This script orchestrates git/glab operations only.
  - You must make and stage actual code changes before commit/push commands.
USAGE
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

slugify() {
  local input="$1"
  echo "$input" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/_/g; s/_+/_/g; s/^_+//; s/_+$//'
}

run_cmd() {
  local cmd="$1"
  if [[ "$MODE" == "execute" ]]; then
    echo "+ $cmd"
    eval "$cmd"
  else
    echo "+ $cmd"
  fi
}

ISSUE_NUMBER=""
TASK_SLUG=""
BRANCH_TYPE="fix"
BASE_BRANCH="main"
COMMIT_MESSAGE=""
MR_TITLE=""
MODE="dry-run"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue-number)
      ISSUE_NUMBER="${2:-}"
      shift 2
      ;;
    --task-slug)
      TASK_SLUG="${2:-}"
      shift 2
      ;;
    --branch-type)
      BRANCH_TYPE="${2:-}"
      shift 2
      ;;
    --base-branch)
      BASE_BRANCH="${2:-}"
      shift 2
      ;;
    --commit-message)
      COMMIT_MESSAGE="${2:-}"
      shift 2
      ;;
    --mr-title)
      MR_TITLE="${2:-}"
      shift 2
      ;;
    --dry-run)
      MODE="dry-run"
      shift
      ;;
    --execute)
      MODE="execute"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$ISSUE_NUMBER" ]]; then
  echo "--issue-number is required" >&2
  usage
  exit 1
fi

if [[ ! "$ISSUE_NUMBER" =~ ^[0-9]+$ ]]; then
  echo "--issue-number must be numeric" >&2
  exit 1
fi

if [[ "$BRANCH_TYPE" != "fix" && "$BRANCH_TYPE" != "feature" ]]; then
  echo "--branch-type must be one of: fix, feature" >&2
  exit 1
fi

require_cmd git
require_cmd glab

# Ensure glab is authenticated and issue exists.
run_cmd "glab auth status"

ISSUE_TITLE=""
if [[ -n "$TASK_SLUG" ]]; then
  ISSUE_TITLE="$TASK_SLUG"
else
  if [[ "$MODE" == "execute" ]]; then
    ISSUE_TITLE="$(glab issue view "$ISSUE_NUMBER" --json title -q '.title')"
  else
    ISSUE_TITLE="issue_${ISSUE_NUMBER}"
  fi
fi

if [[ -z "$TASK_SLUG" ]]; then
  TASK_SLUG="$(slugify "$ISSUE_TITLE")"
fi

if [[ -z "$TASK_SLUG" ]]; then
  TASK_SLUG="task"
fi

BRANCH_NAME="${BRANCH_TYPE}/${ISSUE_NUMBER}_${TASK_SLUG}"

if [[ -z "$COMMIT_MESSAGE" ]]; then
  COMMIT_MESSAGE="fix(#${ISSUE_NUMBER}): ${TASK_SLUG//_/ }"
fi

if [[ -z "$MR_TITLE" ]]; then
  MR_TITLE="$COMMIT_MESSAGE"
fi

MR_BODY=$'## Summary\n- Implement issue #'"$ISSUE_NUMBER"$'\n\n## Validation\n- [ ] Add verification notes\n\nCloses #'"$ISSUE_NUMBER"

run_cmd "glab issue view ${ISSUE_NUMBER}"
run_cmd "git fetch origin ${BASE_BRANCH}"
run_cmd "git checkout -b ${BRANCH_NAME} origin/${BASE_BRANCH}"

echo
if [[ "$MODE" == "execute" ]]; then
  echo "Make code changes now, then run:"
else
  echo "After making and staging code changes, run these commands:"
fi

echo "+ git add <files>"
echo "+ git commit -m \"${COMMIT_MESSAGE}\""
echo "+ git push -u origin ${BRANCH_NAME}"
echo "+ glab mr create --source-branch ${BRANCH_NAME} --target-branch ${BASE_BRANCH} --title \"${MR_TITLE}\" --description \"${MR_BODY}\""

echo
echo "Derived values:"
echo "  issue_number: ${ISSUE_NUMBER}"
echo "  task_slug: ${TASK_SLUG}"
echo "  branch_name: ${BRANCH_NAME}"
echo "  commit_message: ${COMMIT_MESSAGE}"
echo "  mr_title: ${MR_TITLE}"
echo "  mode: ${MODE}"
