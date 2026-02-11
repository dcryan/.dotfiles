---
description: Check domain name availability across .com, .io, .app, and .ai TLDs
allowed-tools: Bash(name-scout *)
---

Use the `name-scout` command to check domain availability. Pass one or more names as arguments to check them in batch.

Example:
```bash
name-scout acme rocket flux widget
```

Returns JSON with available and taken TLDs for each name:
```json
[
  { "name": "acme", "available": ["io"], "taken": ["com", "app", "ai"] },
  { "name": "rocket", "available": [], "taken": ["com", "io", "app", "ai"] }
]
```

When helping users find available domain names:
1. Check their preferred names first
2. If taken, suggest variations and check those
3. Summarize which names have .com available (most valuable) vs other TLDs
