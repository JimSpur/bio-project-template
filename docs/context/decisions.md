# Decisions

<!-- Owner: Claude Project. Newest first. Claude Code reads this; do not edit. -->

## Learned tasks (Claude may automate)

None yet. The Project adds a task here when James says he can do it himself.

## 2026-11-26: `docker` over SSH on the Macs, and the Apptainer image cache on the PC

- Decision: the shared `~/.zshenv` gets two more guarded lines. (1) `~/.orbstack/bin` on the PATH, so `ssh macbook '<command>'` and `ssh studio '<command>'` find `docker`. OrbStack starts at login on both Macs (set by James 2026-11-26), and `CLAUDE.md` says to check `orb status` before a remote Docker run. (2) `NXF_APPTAINER_CACHEDIR=$HOME/.apptainer/nxf-cache`, guarded by `command -v apptainer` so only the PC sets it. The template's `apptainer` profile sets no `cacheDir`. Resolves inbox entries "`docker` not found over non-interactive SSH on the MacBook" (2026-11-26) and "No Apptainer cache directory on the PC" (2026-11-26).
- Why: (1) OrbStack links `docker` in `/usr/local/bin` and `~/.orbstack/bin`, and a non-interactive shell gets neither. `~/.orbstack/bin` is chosen because it holds only OrbStack's tools, so the line can't pull in anything else. Starting at login removes the "OrbStack stopped" failure. (2) Without a cache, every new `-w` folder pulls and converts each image again and deletes it with `work/`. The cache path is a machine setting: a public template must not hold machine paths, and each HPC cluster has its own place for it. It sits on the internal disk but outside `~/scratch`, so cleaning scratch keeps the images.
- Alternatives rejected: `/usr/local/bin` on the PATH (also picks up anything else installed there); `apptainer.cacheDir` in the template's `nextflow.config`; a cache under `~/scratch`.

## 2026-11-26: Remote access over Tailscale and `~/.zshenv` on every machine

- Decision: plain SSH over Tailscale between all three machines, with aliases `studio`, `macbook` and `ubuntu-pc` that work at home and off site; `ubuntu-pc-lan` is the LAN-only fallback. The shared `~/.zshenv` is now linked on the Macs as well as the PC, with guarded Homebrew (`/opt/homebrew` on the Macs, Linuxbrew on the PC) and `typeset -U path PATH`, so non-interactive `ssh <host> '<command>'` finds `pixi`, `claude` and `brew` everywhere. Claude Code on the Studio may run checks on the MacBook with `ssh macbook`; it does not edit files there. Extends the 2026-11-25 PATH decision below.
- Why: James can work on the Studio from the MacBook at home or away, Code can check the MacBook from the Studio, and the PC is reachable off site, all with one set of aliases.
- Alternatives rejected: Tailscale SSH (its server needs the open-source `tailscaled` on macOS, not the app); a separate set of aliases for off-site use.

## 2026-11-26: Python pinned to 3.13 for the template and every project

- Decision: `python = "3.13.*"` in `pixi.toml`, replacing the `"3.14.*"` pin added in step 6b(a) (`1ef68ed`); done in design step 6c. Every project made from the template inherits it. Changing the Python minor version is a hub decision, made in the Dev Setup project first and followed by a deliberate relock. Resolves inbox entry "Python pinned to 3.14 in `pixi.toml`" (2026-11-26).
- Why: without a pin the platforms resolved different Pythons (3.13 on `linux-64`, 3.14 on `osx-arm64`). 3.13 is chosen for stability: it has been out longer, so the heavier packages of later phases (scverse, bioconda tools) are more likely to have builds for it.
- Alternatives rejected: keeping 3.14 (newest, more risk of missing builds later); letting each project choose its Python.

## 2026-11-26: Pixi 0.85.0 on every machine and in CI

- Decision: the 2026-11-25 rule stands: one Pixi version everywhere, upgraded together. The MacBook's switch to the official installer brought 0.85.0, so the Studio, the PC and CI move up to 0.85.0 and `requires-pixi` becomes `">=0.85.0"` (design step 6c). The comments in `pixi.toml` ("Same version on the Studio, MacBook, PC and in CI") and `ci.yml` ("keep equal to requires-pixi") stay. Resolves inbox entry "MacBook runs Pixi 0.85.0" (2026-11-26).
- Why: a newer Pixi on one machine could write `pixi.lock` in a way the other machines and CI read differently. Moving everything up takes a few minutes and keeps the rule simple.
- Alternatives rejected: treating `requires-pixi` as a minimum only, with newer versions allowed on some machines and CI on the minimum.

## 2026-11-25: Full Snakemake, `.editorconfig` and a whitespace check before the cross-machine run

- Decision: new design step 6b, done before step 7. Replace `snakemake-minimal` with full `snakemake` and relock; add `.editorconfig` (Markdown exempt from whitespace trimming); add a CI step that fails on trailing whitespace. `.gitattributes` and `.editorconfig` join the plumbing list (Code drafts, James reviews). Resolves inbox entries "Switch to full Snakemake after Phase 0" (2026-11-24), "Add an `.editorconfig` to the template" (2026-11-24) and "`.gitattributes` is not in the plumbing list" (2026-11-24).
- Why: step 7 proves one lockfile works on all three machines. Changing the lockfile after step 7 would ship a template whose lockfile was never tested across machines. Editors handle `.editorconfig` differently (Positron may need an extension), so the CI check is what actually stops trailing whitespace.
- Alternatives rejected: switching to full Snakemake at close or at the start of Phase 1 (lockfile untested across machines); `.editorconfig` alone without a CI check.

## 2026-11-25: Pixi installed the same way on every machine

- Decision: Pixi is installed with the official installer (`~/.pixi/bin/pixi`) on the Studio, the MacBook and the PC. Upgrades are deliberate: `pixi self-update --version <x.y.z>` on all three machines, with `requires-pixi` in `pixi.toml` and `pixi-version` in CI changed in the same commit. No Homebrew Pixi. Resolves inbox entry "Pixi install method differs between machines" (2026-11-23).
- Why: `brew upgrade` could move one machine to a newer Pixi than the others and CI, and full-path commands (`~/.pixi/bin/pixi`) would not work on a Homebrew install.

## 2026-11-25: PATH for non-interactive SSH on the PC

- Decision: a `~/.zshenv` on the PC adds `~/.pixi/bin` and `~/.local/bin` to the PATH, so `ssh ubuntu-pc '<command>'` finds `pixi` and `claude`. It is kept in the dotfiles repo and linked on the PC only. The guarded PATH lines in `.zshrc` stay for the Macs. (Extended on 2026-11-26 to all three machines: see the entry above.)
- Why: steps 7 and 8 run many commands over SSH. zsh reads `~/.zshenv` for every shell, including non-interactive ones; it does not read `~/.zshrc` for them.

## 2026-11-25: Container step order, image name and tools

- Decision: CI builds `bio-project-template:dev` first and then runs `pixi run test` once, which includes the Nextflow test profile (design step 6 updated). Projects made from the template rename the image tag as one of the README's create-a-project steps. Digest pinning in `process.container` and pushing release images come later, when images are first pushed. The Phase 0 image adds no tools; the default for later projects is to install tools in the image with Pixi from the same `pixi.lock`, to be confirmed in Phase 3. Resolves inbox entries "CI step order and the image name in `nextflow.config`" (2026-11-25) and "How later projects install tools into the container" (2026-11-25).
- Why: `pixi run test` already needs the image, so one run checks everything. Installing container tools from the same lockfile keeps the container and the host environment in step. nf-core pipelines bring their own per-process containers, so the choice only matters for custom processes (Phase 3).
- Alternatives considered for container tools: `apt-get` in the Dockerfile; micromamba with an environment file. Revisit in Phase 3.

## 2026-11-25: Step 4 used a public base image before the template image existed

- Decision: design step 4 records what was done. `main.nf` was developed with no profile, and the step 4 check passed with a small public base image in `nextflow.config`; step 5 replaced it with the template image. Resolves inbox entry "Step 4 check needs a container before step 5 makes one" (2026-11-24).
- Why: with the `docker` profile every process needs an image, and the template image only exists from step 5.

## 2026-11-25: GitHub handle and repo URL may appear in the public repo

- Decision: the "no usernames" rule covers local account names, home-folder paths, IP addresses and other machine details, not the GitHub handle or the repo's own URL, which are public already. The `org.opencontainers.image.source` label is added to `containers/Dockerfile` when images are first pushed to a registry, not in Phase 0. Resolves inbox entry "Image label for the repo URL" (2026-11-25).
- Why: the rule exists to keep machine details out of a public repo. The handle is already in the repo's own URL. The label only has an effect once an image is pushed to GitHub's registry.

## 2026-11-23: Tutor mode split by code type

- Decision: logic (analysis code, Nextflow processes and workflow blocks, Snakemake rules, analysis shell scripts, README and docs) is written by James with Code as tutor. Plumbing (`pixi.toml`, CI workflows, Dockerfile, `nextflow.config` profiles, `config/config.yaml` structure, `.gitignore`) is drafted by Code when James agrees; Code explains it and lists what to check, and James reviews and edits it. Replaces the 2026-11-20 rule that James writes all build code.
- Why: Phase 0 aims at working-level familiarity, not mastery. Plumbing files are mostly syntax looked up in docs, so writing them by hand teaches little per hour; the logic is what employers will ask about.
- Alternatives rejected: keeping full tutor mode (too slow for the learning gained); dropping tutor mode.

## 2026-11-20: Tutor mode for the whole Phase 0 build

- Decision: James writes the build code himself (Pixi manifest, workflows, Dockerfile, CI). Claude Code acts as a tutor: it explains, reviews and suggests checks, and writes code only if James is stuck and asks. This is guidance, not a permission lock. Superseded on 2026-11-23 by the split by code type.
- Why: the goal is for James to learn to write the code for each project.
- Alternatives rejected: Code builds the template (the original plan), hard permission deny rules on the code folders, the built-in Learning output style (Claude writes the routine code).

## 2026-11-20: Automation after learning

- Decision: once James says he can do a task himself, Claude may do that task for him in future iterations and explain what it did. A new variant of the task or a new tool is not covered. Tasks are listed under "Learned tasks" above.
- Why: James can automate a task safely once he understands exactly what happens in it.

## 2026-11-20: Claude writes the governance files

- Decision: `CLAUDE.md` (repo and global), `docs/context/*.md`, `.claude/**` and other `.md` files that govern how Claude works are written by Claude, not by James. README and docs pages stay in tutor mode. Ownership rules are unchanged.
- Why: they are instructions for the agent, not learning code.

## 2026-11-20: Hours and review of tutor mode

- Decision: hours are recorded as they are. After Phases 0 and 1, regroup, check the time budget and loosen tutor mode if things take too long.
- Why: Phases 0 and 1 will show how long tutor-mode work really takes.

## 2026-11-20: Hours are logged from the first Claude Code session

- Decision: setup work before the first Claude Code session does not count towards the 40 h Phase 0 budget. Hours are recorded in the Hours table in `status.md` at `/handoff`, from what James reports. Study hours count too and are logged by James in the hub (decided 2026-11-23).
- Why: much of the earlier time went into building the Claude project itself.
- Alternatives rejected: counting the machine installs and project setup.

## 2026-11-20: Repo name, licence and visibility

- Decision: `bio-project-template`, MIT licence, public on GitHub. Repos live under `~/repos` on each Mac. `~/dotfiles` stays in the home folder.
- Why: MIT is the convention in the Nextflow and Snakemake ecosystem and the simplest for a personal portfolio. The licence covers code only; each project README states its dataset's terms. A public repo gets free standard CI minutes.
- Alternatives rejected: Apache-2.0 (patent grant adds little for a personal portfolio), a private repo.

## 2026-11-20: Claude Code install

- Decision: Claude Code runs from the Positron extension on the Macs and from the standalone CLI (native installer, `~/.local/bin/claude`) on all three machines. Global instructions live in `~/dotfiles/dotfiles-claude/CLAUDE.md`, symlinked to `~/.claude/CLAUDE.md`.
- Why: the extension does not put `claude` on the PATH, and the PC needs the CLI.
- Alternatives rejected: Homebrew cask (not available on the PC).
