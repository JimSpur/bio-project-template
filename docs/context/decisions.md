# Decisions

<!-- Owner: Claude Project. Newest first. Claude Code reads this; do not edit. -->

## Learned tasks (Claude may automate)

None yet. The Project adds a task here when James says he can do it himself.

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
