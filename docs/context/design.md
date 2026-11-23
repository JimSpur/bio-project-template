# Design

<!-- Owner: Claude Project. Claude Code reads this; do not edit. Propose changes in inbox.md. -->

## Approach

The repo is built in small, checkable steps so each one can be tested before the next depends on it. Pixi gives one locked environment for `osx-arm64` and `linux-64`, so the same `pixi.lock` runs on the Studio, the MacBook and the PC. Snakemake and Nextflow both get a hello-world workflow with a test configuration. Nextflow processes run in an amd64 container (Docker on the Macs via Rosetta, Docker or Apptainer on the PC), which is the setup HPC and cloud need. GitHub Actions rebuilds that container on a native amd64 runner and runs the Nextflow test profile, so CI checks the same thing the PC does.

The hello-world workflows stay deliberately trivial. Their job is to prove the toolchain, the container path and CI, and to give later projects a layout to copy. The aim is working-level familiarity with each tool, enough to finish the phase, not mastery. Anything surprising goes in `inbox.md`.

**Tutor mode, split by code type.** Each step below is marked **[James]** (logic: James writes it, Code tutors) or **[Code drafts]** (plumbing: Code drafts it when James agrees, explains it and lists what to check; James reviews and edits). Code's own writes are `status.md` and `inbox.md` plus agreed plumbing drafts; the Project writes the governance files. Hours are recorded as they are, and the plan is reviewed after Phases 0 and 1.

## Steps

1. **Scaffold [Code drafts `.gitignore`; James makes the folders].** `.gitignore` (data, `work/`, `.nextflow*`, `.snakemake/`, `.pixi/`, results), folders `workflow/`, `config/`, `containers/`, `docs/`, `.github/workflows/`. Check: `git status` shows only intended files.
2. **Pixi environment [Code drafts].** `pixi.toml` with channels `conda-forge` and `bioconda`, platforms `osx-arm64` and `linux-64`, Nextflow, Snakemake and the small tools the hello-world needs, plus tasks `test`, `test-snakemake` and `test-nextflow`. Pin the minimum Pixi version with `requires-pixi` (confirm the field name and table against the current Pixi docs), set to the version installed on all three machines (`pixi --version`), so every machine and CI read the lockfile with a compatible Pixi. Create `pixi.lock` with `pixi`. Check: `pixi install --locked` succeeds on the Studio. Confirm each package exists for both platforms before relying on it.
3. **Snakemake hello-world [James].** `workflow/Snakefile`, two small rules chained together; `config/config.yaml` structure drafted by Code, values chosen by James. Check: `pixi run test-snakemake` passes and writes only to an ignored output folder.
4. **Nextflow hello-world [James for `main.nf`; Code drafts `nextflow.config`].** `workflow/main.nf` with two small processes. `workflow/nextflow.config` with profiles `test`, `docker`, `docker_amd64` (adds `--platform linux/amd64`), `apptainer`. Check: `pixi run test-nextflow` passes with `-profile test,docker`. Confirm Nextflow finds `workflow/nextflow.config` when launched with `workflow/main.nf` from the repo root; if not, say so in `inbox.md` with the fix that works.
5. **Container [Code drafts].** `containers/Dockerfile`, amd64, pinned base image, built to contain what the Nextflow processes call. Check: builds on the Studio under Rosetta and on the PC natively. Digest pinning is applied in the release image, not in local builds.
6. **CI [Code drafts].** `.github/workflows/ci.yml` on push and pull request, standard Linux runner only: set up Pixi from the lockfile with the same Pixi version as `requires-pixi` in `pixi.toml`, run `pixi run test`, build the amd64 image, run the Nextflow test profile with it. Check: green run on GitHub. Do not push images in Phase 0.
7. **Cross-machine run [James runs].** After a commit and push, pull and run the tests on the PC over SSH (in `tmux`), on the MacBook, and on the Studio. Log host, commit, command and result in `status.md`. Check: same `pixi.lock` hash on all three, tests pass on at least the Studio and the PC.
8. **Smoke test [James runs].** `nf-core/demo` with the template's Pixi `nextflow`, launched from a scratch folder with `-w` set: `-profile test,docker,emulate_amd64` on a Mac, `-profile test,apptainer` on the PC. Check: 8 of 8 tasks on each.
9. **Docs [James].** README (question, one-command test, create-a-project steps, machine notes) and short pages under `docs/` as needed. Check: a fresh clone follows the README and the tests pass.

Closing is done by the Claude Project, not by Code: archive build context, restore placeholders (the restored `CLAUDE.md` keeps the Tutor mode section, so every later project inherits it), set the template flag, tag `v0.1`.

## Interfaces

- Inputs: `config/config.yaml` (hello-world values, output folder, data path keys), Nextflow `params` in `workflow/nextflow.config`.
- Outputs: written to an ignored folder such as `results/`; nothing generated is committed.
- Pixi tasks: `test`, `test-snakemake`, `test-nextflow`.
- Exact config values are James's choice. Code logs the keys in `status.md` at `/handoff` so the Project can describe them in the template `CLAUDE.md`.

## Known risks

- A package may lack an `osx-arm64` or `linux-64` build. Mitigation: pick an alternative or note the platform limit in `inbox.md`.
- Images that are amd64-only run under Rosetta on the Macs and can fail on AVX or large-memory use. Mitigation: those runs go to the PC.
- Apptainer needs user namespaces on Ubuntu 26.04. It worked for `nf-core/demo` on the PC; the template's container must also work there.
- Non-interactive SSH to the PC does not put `pixi` on the PATH. Mitigation: full path `~/.pixi/bin/pixi` or an interactive tmux session. A move of the PATH lines to `~/.zshenv` is a dotfiles decision for the Project.
- CI minutes: free for standard runners on a public repo. Avoid macOS and larger runners.
- Reviewing a drafted plumbing file can turn into skimming it. Mitigation: Code lists what to check, and James changes at least the parts he can explain.
- Layout choice (Nextflow files in `workflow/`, not at the repo root) differs from nf-core convention. If it causes friction, raise it in `inbox.md` rather than moving files.
