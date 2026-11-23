# Brief

<!-- Owner: Claude Project. Claude Code reads this; do not edit. -->

## Question

Can one small public repo give every later portfolio project the same reproducible start? It should give a locked Pixi environment for Apple Silicon and Linux x86, hello-world Nextflow and Snakemake workflows, an amd64 container, and CI that runs the test profile on every push. The repo also carries the Claude Project and Claude Code context protocol, so design and code stay in step.

## Data

| Dataset | Source | Location (see config/) | Notes |
|---|---|---|---|
| Hello-world inputs | generated in the repo | `config/config.yaml` | a few lines of text, no download |
| nf-core/demo test data | nf-core test profile, public | fetched by the pipeline at run time | smoke test only; never committed |

## Scope

- In scope: `.gitignore`, `pixi.toml` and `pixi.lock` (`osx-arm64`, `linux-64`), `workflow/` with a hello-world Snakemake and Nextflow workflow, `config/`, `containers/Dockerfile` (amd64), `.github/workflows/` CI, `docs/`, README, the smoke test with `nf-core/demo`, and a cross-machine run of the test workflows.
- Out of scope: real analyses or datasets, GPU use, a self-hosted runner, macOS or large CI runners, cloud batch profiles (Phase 6), arm64 release images (add only if a Mac run needs one), and the Phase 0 study blocks (tracked in the Dev Setup hub).

## Success criteria

- The same `pixi.lock` installs and the test workflows (Snakemake and Nextflow) pass on the Mac Studio and the Ubuntu PC. Each run is logged in `docs/context/status.md` with host, commit and path.
- The MacBook Pro runs the test profile from the same lockfile.
- CI on a standard Linux runner builds the amd64 container and runs the Nextflow test profile, and is green.
- The README states the question, how to run the tests in one command, and how to create a new project from the template.
- `nf-core/demo` passes using the template's Pixi `nextflow`: Docker on a Mac, Apptainer on the PC.
- James wrote the workflow logic and README himself with Code as tutor, and reviewed every plumbing file Code drafted (see `CLAUDE.md`). The Hours table shows the real time taken.
- At close: build context archived under `docs/archive/phase-0/`, placeholders restored, "Template repository" flag set on GitHub, tag `v0.1`.

## Portfolio notes

Show reproducible environments, containers pinned for HPC use, CI for pipelines, and a clear process for working with Claude Code. The README is read by hiring managers, so keep it short and accurate.
