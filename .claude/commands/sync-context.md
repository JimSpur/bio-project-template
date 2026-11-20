---
description: After a git pull, summarise what the Claude Project changed in docs/context and CLAUDE.md.
---

Check what the Claude Project has changed since my last session.

1. Run `git log --since="2 weeks ago" --oneline -- CLAUDE.md docs/context/brief.md docs/context/design.md docs/context/decisions.md` and `git diff HEAD@{1} HEAD -- CLAUDE.md docs/context` if the reflog allows. If neither is informative, read the files directly.
2. Read `CLAUDE.md`, `docs/context/brief.md`, `design.md` and `decisions.md`, and `inbox.md` (to see which of my questions were marked Resolved).
3. Report briefly:
   - What changed in the design or decisions, and what that means for the code.
   - Inbox entries now resolved, and the outcome.
   - Work in `status.md` that no longer matches the design.
4. Propose the next concrete step. Do not edit any file in this command.
