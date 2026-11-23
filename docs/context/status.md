# Status

<!-- Owner: Claude Code. Rewritten by /handoff at the end of each session. -->

Last updated: 2026-11-23, machine: MacBook, commit: ae3e293

## Done

- Step 1 (scaffold). `.gitignore` drafted by Code, reviewed by James, and committed unchanged in `ae3e293`. It covers data and results (`data/`, `results/`, FASTQ/BAM/CRAM/h5ad, `*.sif`), Nextflow (`work/`, `.nextflow*`, `null/`), `.snakemake/`, `.pixi/`, Python/R leftovers, OS/editor files, `.env` and `.claude/settings.local.json`.
- Folders `workflow/`, `config/`, `containers/`, `.github/workflows/` created by James on the MacBook (`docs/` already existed). They are empty, so git does not track them yet; they appear once they hold a file.

## In progress

- Step 2 (Pixi environment): waiting for the Pixi version on the Studio and PC before Code drafts `pixi.toml` with `requires-pixi`.

## Blocked

- Choosing the `requires-pixi` value: needs `pixi --version` and `which pixi` from the Studio and the PC. Known so far: MacBook Pixi 0.84.2, installed through Homebrew (`/opt/homebrew/bin/pixi`). See inbox entry 2026-11-23.

## Deviations from the design

- None.

## Results

| Output | Host | Path | Produced by (command, commit) |
|---|---|---|---|

## Hours

<!-- One row per session. Ask James; never estimate. Write "unknown" if he does not know. -->

| Date | Session hours | Cumulative | Notes |
|---|---|---|---|
| 2026-11-23 | 0.75 | 0.75 | /sync-context, step 1 scaffold, `.gitignore` drafted and committed |

## Next

1. On the Studio and the PC: run `pixi --version` and `which pixi`, and agree on one version for `requires-pixi`.
2. Step 2: Code checks the `requires-pixi` field name in the current Pixi docs, then drafts `pixi.toml`; James reviews it; create `pixi.lock` with `pixi`.
3. Step 9 note: James decided not to put placeholder `data/`, `results/` or `work/` folders in the template. The README will describe the layout instead: workflows create `results/`; data lives outside the repo, with its path in `config/config.yaml`; Nextflow `work/` goes in a scratch folder set with `-w` for real runs.
