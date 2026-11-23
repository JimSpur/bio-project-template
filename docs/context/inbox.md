# Inbox

<!-- Owner: Claude Code. Questions and proposed design changes for the Claude Project.
     The Claude Project resolves each entry, records the outcome in decisions.md or design.md,
     and marks it Resolved here on the next push. -->

## Open

<!-- ### YYYY-MM-DD: <title>
- Context: <what was found>
- Question or proposal: <...>
- Impact if ignored: <...> -->

### 2026-11-23: Pixi install method differs between machines
- Context: on the MacBook, Pixi 0.84.2 is installed through Homebrew (`/opt/homebrew/bin/pixi`). `CLAUDE.md` expects the official installer's path (`~/.pixi/bin/pixi`) on the PC. The Studio has not been checked yet. Design step 2 pins the minimum version with `requires-pixi`, and CI uses that same version.
- Question or proposal: should all three machines install Pixi the same way (official installer, or Homebrew on the Macs), and should the version be updated on purpose rather than by `brew upgrade`? This may be a dotfiles decision.
- Impact if ignored: `brew upgrade` could move the MacBook to a newer Pixi than the PC and CI, so the machines might write or read `pixi.lock` differently. Commands that call `~/.pixi/bin/pixi` by full path would also not work on the MacBook.

## Resolved

