# Git Commits

Please commit all changes in git. Use conventional commit format and atomic
commits. Isolate similar changes to a single commit.

When writing git commit messages, pass the message as a plain string — do NOT
use `$()` command substitution (e.g. `git commit -m "$(cat <<'EOF'...EOF)"`).
Command substitution breaks the allowed tools permission system. Use a direct
string instead: `git commit -m "type(scope): message"`.
