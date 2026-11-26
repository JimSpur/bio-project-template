# Inbox

<!-- Owner: Claude Code. Questions and proposed design changes for the Claude Project.
     The Claude Project resolves each entry, records the outcome in decisions.md or design.md,
     and marks it Resolved here on the next push. -->

## Open

<!-- ### YYYY-MM-DD: <title>
- Context: <what was found>
- Question or proposal: <...>
- Impact if ignored: <...> -->

### 2026-11-26: Python pinned to 3.14 in `pixi.toml`
- Context: in step 6b(a), Code found that the committed `pixi.lock` resolved Python 3.13.18 on `linux-64` (PC, CI) and 3.14.10 on `osx-arm64` (Macs). Nothing forced 3.13: with `python = "3.14.*"` both platforms solve and every compiled package has a `py314` build (tested in a scratch copy). James chose to pin `python = "3.14.*"`, committed in `1ef68ed` together with full Snakemake. Step 7 confirmed Python 3.14.10 on the PC and the Studio.
- Question or proposal: record the pin in `design.md` (step 2 or 6b) and `decisions.md`. Projects made from the template inherit it; raising the minor version later is a deliberate relock, like the Pixi version.
- Impact if ignored: the design does not mention a pin that every later project inherits; a future edit might drop it and bring back different Pythons per platform.

### 2026-11-26: MacBook runs Pixi 0.85.0
- Context: the Homebrew Pixi on the MacBook was replaced with the official installer, which installed 0.85.0. The Studio and the PC run 0.84.2, and CI uses `pixi-version: v0.84.2`. James decided to keep 0.85.0 ("Require pixi is for greater or equal to 0.84.2"). Step 7 on the MacBook passed with the same `pixi.lock` hash. This goes against the 2026-11-25 decision (same version on all machines, upgrades deliberate on all three with `requires-pixi` and CI `pixi-version` in the same commit).
- Question or proposal: update the decision so that `requires-pixi` is the minimum, machines may run a newer Pixi, and CI stays on the minimum. Or keep the decision and plan a deliberate upgrade of all machines and CI. The comments in `pixi.toml` ("Same version on the Studio, MacBook, PC and in CI") and `ci.yml` ("keep equal to requires-pixi") follow whichever is chosen.
- Impact if ignored: `pixi lock` or `pixi add` run on the MacBook may write `pixi.lock` differently from the other machines and CI; the decision and the machines disagree.

## Resolved

### 2026-11-23: Pixi install method differs between machines
- Outcome (decisions.md 2026-11-25): official installer on every machine, upgrades deliberate. Homebrew Pixi removed from the MacBook on 2026-11-26. See the 2026-11-26 entry on the MacBook version.

### 2026-11-24: `.gitattributes` is not in the plumbing list
- Outcome (CLAUDE.md, decisions.md 2026-11-25): `.gitattributes` and `.editorconfig` are plumbing files.

### 2026-11-24: Switch to full Snakemake after Phase 0
- Outcome (design step 6b): moved before step 7. Done in `1ef68ed`.

### 2026-11-24: Add an `.editorconfig` to the template
- Outcome (design step 6b): `.editorconfig` plus a CI whitespace check. Done in `eefce5b`.

### 2026-11-24: Step 4 check needs a container before step 5 makes one
- Outcome (design step 4, decisions.md 2026-11-25): recorded as done.

### 2026-11-25: How later projects install tools into the container
- Outcome (design step 5, decisions.md 2026-11-25): no tools in the Phase 0 image; default for later projects is Pixi from the same `pixi.lock`, to confirm in Phase 3.

### 2026-11-25: CI step order and the image name in `nextflow.config`
- Outcome (design step 6, decisions.md 2026-11-25): build the image, then `pixi run test`. Projects rename the tag in their create-a-project steps; digest pinning when images are first pushed.

### 2026-11-25: Image label for the repo URL
- Outcome (CLAUDE.md, decisions.md 2026-11-25): the GitHub handle and repo URL may appear; the `source` label is added when images are first pushed.
