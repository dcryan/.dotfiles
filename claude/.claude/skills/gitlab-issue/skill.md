---
name: gitlab-issue
argument-hint: [issue-number]
description: Complete GitLab issue workflow - fetch issue, create branch, analyze, implement, commit, and create MR
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, Task, TodoWrite, Bash(glab issue:*)
---

GitLab issue workflow for issue #$1.

IMPORTANT: At the beginning, check if the user has plan mode enabled. If not,
stop and instruct them to enable it before continuing by tell the user to press
Shift+Tab to enable plan mode for best execution of this multi-step workflow.

This command will execute the following comprehensive workflow:

**GitLab Issue Workflow for Issue #$1**

Execute the following steps:

1. **Fetch Issue Details**: Use `glab issue view $1` to get issue information
2. **Create Feature Branch**: Create a new branch based on the issue
3. **Analyze Codebase**: Search for relevant files and understand the context
4. **Implement Changes**: Apply the necessary code changes
5. **Commit Changes**: Create conventional commits grouped by change type
6. **Push & Create MR**: Push branch and create merge request to close the issue

Start by fetching the issue details and creating a proper development workflow.

```bash
# Fetch issue details
glab issue view $1

# Create a branch for the issue
# Determine an appropriate branch name based on the issue content
# Use Git Flow conventions: feature/fix/chore/docs/{issue_number}-{descriptive-name}
git checkout -b "[BRANCH_NAME_TO_BE_DETERMINED_BY_AGENT]"
```

Now analyze the codebase to understand what changes are needed based on the issue requirements.

After implementing all changes and committing them, push and create the merge request:

```bash
# Push the branch
git push -u origin HEAD

# Create merge request for the issue
# Determine appropriate title and description based on the changes made
glab mr create --related-issue $1 \
  --source-branch "$(git branch --show-current)" \
  --title "[TITLE TO BE DETERMINED BY AGENT]" \
  --description "[DESCRIPTION TO BE DETERMINED BY AGENT - should include summary of changes, testing notes, and 'Closes #$1']" \
  --copy-issue-labels \
  --remove-source-branch
```
