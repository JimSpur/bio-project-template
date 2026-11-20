# bio-project-template

<!-- Owner: Claude Project (Dev Setup hub, Phase 0 build). Regenerated on push. Keep under ~100 lines: it loads every session. -->

**Goal:** Build the reusable template repo for bioinformatics portfolio projects: a locked Pixi environment (`osx-arm64`, `linux-64`), hello-world Nextflow and Snakemake workflows, an amd64 container, and CI that runs the test profile. Every later project is created from this repo.

**Build mode:** until v0.1, the files in `docs/context/` describe this build. At close the Claude Project archives them under `docs/archive/phase-0/` and restores the placeholder versions, so the repo works as a template.

## Start of every session

1. Read `docs/context/status.md` (what is done, in progress, blocked).
2. Read `docs/context/brief.md` (question, data, success criteria).
3. Read `docs/context/design.md` and `docs/context/decisions.md` only when the task touches them.
4. After a `git pull`, run `/sync-context` to see what the Claude Project changed.
5. At the end of a session, run `/handoff`.

## File ownership (one owner per file)

| File | Owner | Code may |
|---|---|---|
| `CLAUDE.md`, `docs/context/brief.md`, `design.md`, `decisions.md`, `closeout.md` | Claude Project | read only |
| `docs/context/status.md`, `docs/context/inbox.md` | Claude Code | write |

If the design looks wrong or a decision needs changing, do not edit Project-owned files. Add an entry to `docs/context/inbox.md` and carry on with the current design unless told otherwise.

## Stack and conventions

- Environments: Pixi (`pixi.toml`, `pixi.lock`; platforms `osx-arm64`, `linux-64`). Run tools with `pixi run`.
- Languages: Python, R, bash. Pipelines: Nextflow and Snakemake under `workflow/`, settings under `config/`.
- Containers: Docker (OrbStack) on the Macs, Apptainer on the Ubuntu PC. Release images are amd64, pinned by digest.
- Large or raw data lives outside the repo and is never committed. Paths go in `config/`.
- This repo is public. Public data only. Never commit secrets, tokens, IP addresses, usernames or machine-specific paths. Refer to the PC only by its SSH alias.
- Workflow layout: `workflow/Snakefile`, `workflow/main.nf` and `workflow/nextflow.config`, `config/config.yaml`, `containers/Dockerfile`, `.github/workflows/`. Details in `docs/context/design.md`.
- Keep everything generic: this is a template, so no project-specific content.

## Remote execution (Ubuntu PC)

- Work happens in this clone on the Mac. The clone on the PC is an execution mirror: never edit it by hand.
- SSH alias: `ubuntu-pc`. PC repo path: `~/repos/bio-project-template`. Large data, `work/` and big outputs stay on the PC.
- To run: commit and push here, then `ssh ubuntu-pc 'cd ~/repos/bio-project-template && git pull --ff-only'`, then start the job in `tmux`. Run only pushed commits and record the commit hash.
- Non-interactive SSH commands do not read `~/.zshrc`, so `pixi` is not on the PATH there. Use `~/.pixi/bin/pixi` or an interactive `tmux` session, and raise it in `docs/context/inbox.md` if it gets in the way.
- Record each result in `docs/context/status.md` with host, commit and path. Bring back only small outputs (QC summaries, figures).
- If Claude Code is run on the PC for debugging, commit anything worth keeping and push it. Do not edit Project-owned files there either.

## Commands

Code creates these as part of the build. If the real command differs, say so in `docs/context/inbox.md` and the Project updates this file.

- Install the locked environment: `pixi install --locked`
- All tests: `pixi run test`
- Snakemake hello-world: `pixi run snakemake --snakefile workflow/Snakefile --configfile config/config.yaml --cores 2`
- Nextflow hello-world: `pixi run nextflow run workflow/main.nf -profile test,docker`

## Do not

- Do not commit data, `work/`, `.nextflow*`, `.snakemake/`, or results larger than a few MB.
- Do not change `pixi.lock` by hand.
- Do not run heavy jobs on the MacBook Pro (16 GB). Use the Studio or the Ubuntu PC.
- Do not commit or push unless James asks.
- Launch Nextflow and Snakemake runs that use real or scratch data from a scratch folder with `-w` set, never from inside a git repo.
