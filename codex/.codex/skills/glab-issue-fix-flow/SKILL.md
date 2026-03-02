---
name: glab-issue-fix-flow
description: GitLab issue implementation workflow using glab CLI with an issue_number parameter. Use when Codex should fetch issue details, create a fix plan, branch as feature/<issue_number>_<task_slug> or fix/<issue_number>_<task_slug>, implement changes, commit and push, and open a merge request that closes the issue.
---

# GitLab Issue Fix Flow

Follow this workflow when invoked.

## Required input

- `issue_number` (integer)

## Optional input

- `task_slug` (kebab/snake slug). If omitted, derive from issue title.
- `branch_type` (`fix` or `feature`). Default to `fix` unless the issue clearly requests a new feature.
- `base_branch` (default `main`)
- `commit_message` (default `fix(#<issue_number>): <short summary>`)
- `mr_title` (default mirrors commit summary)

## Workflow

1. Validate environment.
- Ensure inside a GitLab repo with clean enough working tree for intended edits.
- Ensure `glab auth status` succeeds.

2. Fetch and summarize issue.
- Run: `glab issue view <issue_number>`
- Capture title, description, labels, acceptance criteria, and linked context.
- If requirements are ambiguous, state assumptions before editing.

3. Build an implementation plan.
- Create a short plan with concrete file-level changes and validation steps.
- Keep scope limited to the issue.

4. Create branch name and checkout.
- Derive slug from issue title when `task_slug` is absent:
  - lowercase
  - replace non-alphanumeric with `_`
  - collapse repeated `_`
  - trim leading/trailing `_`
- Branch format: `<branch_type>/<issue_number>_<task_slug>`
- Example: `fix/321_add_login_validation`
- Create branch from `base_branch`:
  - `git fetch origin <base_branch>`
  - `git checkout -b <branch_name> origin/<base_branch>`

5. Implement the fix.
- Make the minimum necessary code changes.
- Run targeted tests/lint/build relevant to changed files.

6. Commit and push.
- Stage intended files only.
- Commit message default: `fix(#<issue_number>): <summary>`
- Push: `git push -u origin <branch_name>`

7. Open MR that closes the issue.
- Use an MR description that includes a closing keyword:
  - `Closes #<issue_number>`
- Run:
  - `glab mr create --source-branch <branch_name> --target-branch <base_branch> --title "<mr_title>" --description "<mr_body>"`

8. Report result.
- Return branch, commit SHA, MR URL, tests run, and any follow-ups.

## Scripted helper

Use `scripts/issue_fix_flow.sh` for command orchestration:

```bash
scripts/issue_fix_flow.sh --issue-number 123 --dry-run
scripts/issue_fix_flow.sh --issue-number 123 --execute --branch-type fix
```

The script prints and optionally executes the exact commands for issue fetch, branch setup, push, and MR creation.
