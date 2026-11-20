# Decisions

<!-- Owner: Claude Project. Newest first. Claude Code reads this; do not edit. -->

## 2026-11-20: Hours are logged from the first Claude Code session

- Decision: setup work before the first Claude Code session does not count towards the 40 h Phase 0 budget. Hours are recorded in the Hours table in `status.md` at `/handoff`, from what James reports.
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
