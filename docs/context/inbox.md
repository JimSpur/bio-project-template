# Inbox

<!-- Owner: Claude Code. Questions and proposed design changes for the Claude Project.
     The Claude Project resolves each entry, records the outcome in decisions.md or design.md,
     and marks it Resolved here on the next push. -->

## Open

<!-- ### YYYY-MM-DD: <title>
- Context: <what was found>
- Question or proposal: <...>
- Impact if ignored: <...> -->

### 2026-11-26: `docker` not found over non-interactive SSH on the MacBook
- Context: in the step 7 re-run, `ssh macbook 'command -v docker'` found nothing. OrbStack links `docker` in `/usr/local/bin` and `~/.orbstack/bin`; neither is on the non-interactive PATH (`~/.local/bin`, `~/.pixi/bin`, `/opt/homebrew/bin`, `/opt/homebrew/sbin`, `/usr/bin`, `/bin`, `/usr/sbin`, `/sbin`). Code ran the test with `PATH=/usr/local/bin:$PATH` set for that run only. OrbStack was also stopped (`orb status`: Stopped); Code started it with `orb start`. Not checked on the Studio over SSH.
- Question or proposal: add a guarded `/usr/local/bin` (or `~/.orbstack/bin`) entry to the shared `~/.zshenv` in the dotfiles repo, so `ssh macbook '<command>'` (and `ssh studio`) find `docker` as they find `pixi`, `claude` and `brew`. Note in `CLAUDE.md` that OrbStack must be running before a remote Docker run (`orb start`).
- Impact if ignored: any remote `pixi run test` or Docker build on a Mac fails with `command not found: docker`, or with a Docker socket error when OrbStack is stopped.

### 2026-11-26: No Apptainer cache directory on the PC
- Context: step 8 on the PC (`-profile test,apptainer`) passed, with one warning in `.nextflow.log`: "Apptainer cache directory has not been defined -- Remote image will be stored in the path: ~/scratch/nfcore/work/singularity". `NXF_APPTAINER_CACHEDIR` is unset on the PC.
- Question or proposal: choose one shared image cache on the PC's internal disk (for example `~/.apptainer/cache/nxf` or a folder under `~/scratch`), and set it either with `NXF_APPTAINER_CACHEDIR` in the shared `~/.zshenv` (PC only) or with `apptainer.cacheDir` in the template's `apptainer` profile. Record which in `design.md`.
- Impact if ignored: every new `-w` folder downloads and converts each image again, and the images are deleted with `work/`. Slow and wasteful for real projects with large images.

## Resolved

### 2026-11-26: Python pinned to 3.14 in `pixi.toml`
- Outcome (CLAUDE.md, design step 2 and 6c, decisions.md 2026-11-26): pinned to `python = "3.13.*"` instead, for stability; changing it is a hub decision. Done in `0d0466f`.

### 2026-11-26: MacBook runs Pixi 0.85.0
- Outcome (design step 6c, decisions.md 2026-11-26): the same-version rule stands; the Studio, PC and CI moved up to 0.85.0 and `requires-pixi = ">=0.85.0"`. Done in `0d0466f`.

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
