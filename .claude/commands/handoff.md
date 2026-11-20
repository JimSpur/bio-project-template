---
description: End-of-session handoff. Updates docs/context/status.md and inbox.md for the Claude Project.
---

Write the end-of-session handoff for this repository.

1. Run `git status`, `git log --oneline -15` and `git diff --stat` to see what changed this session. Note the current machine (`hostname`) and short commit hash.
2. Rewrite `docs/context/status.md` completely, keeping its template headings: Done, In progress, Blocked, Deviations from the design, Results, Hours, Next. Carry forward still-true items from the previous version. Remove items that are finished. Record real output paths, the host (Studio, MacBook or PC) and the command and commit that produced each result. For runs on the PC, check with `ssh <pc>` rather than assuming.
3. If the work deviated from `docs/context/design.md`, or a decision is needed, add an entry under "Open" in `docs/context/inbox.md` (date, context, question or proposal, impact if ignored). Do not edit `brief.md`, `design.md`, `decisions.md` or `CLAUDE.md`: the Claude Project owns them.
4. Ask me how many hours this session took. Add one row to the Hours table in `status.md` (date, session hours, running cumulative, short note). Do not estimate: if I do not know, write "unknown" and leave the cumulative unchanged.
5. Only state what you verified from the repo and this session. Do not guess results.
6. Show me the diff of `status.md` and `inbox.md` and suggest a commit message such as `docs(context): handoff <date>`. Do not commit or push unless I say so.
