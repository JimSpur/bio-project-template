# Status

<!-- Owner: Claude Code. Rewritten by /handoff at the end of each session. -->

Last updated: 2026-11-25, machine: Studio, commit: 20ad230 (pushed, `main` up to date with `origin/main`). Steps 4, 5 and 6 done; step 7 next.

## Done

- Step 1 (scaffold). `.gitignore` drafted by Code, reviewed by James, committed in `ae3e293`. `.pixi/` ignores the whole Pixi folder; `.pixi/config.toml` is not tracked.
- Pixi 0.84.2 on all three machines. Studio and PC: official installer (`~/.pixi/bin/pixi`). MacBook: still Homebrew (`/opt/homebrew/bin/pixi`), to be replaced (see Next).
- Step 2 (Pixi environment), committed in `275e6ce`: `pixi.toml` with `requires-pixi = ">=0.84.2"`, platforms `osx-arm64` and `linux-64`, `nextflow = "26.10.*"`, `snakemake-minimal = "9.27.*"`, tasks `test-snakemake`, `test-nextflow`, `test` (depends on both); `pixi.lock` (lock version 7); `.gitattributes` from `pixi init`.
- Step 3 (Snakemake hello-world), written by James, committed in `d5cd866` and `2af6321`: `workflow/Snakefile` (`write_greeting` with `{params.txtstring:q}`, `transform_greeting` with `tr`, `rule all`); `config/config.yaml` keys `pathvars.outdir = "results/snakemake/helloworld"` and `txtstring = "Hello World"`. Learned: rerun triggers (params in `.snakemake/` metadata, `--list-changes params`) and bash word-splitting.
- Step 4 (Nextflow hello-world), committed in `5ba3d46`, `f6ee037`, `2379f9e`:
  - `workflow/main.nf` (written by James): typed `params { greeting: String }` (no default); `sayHello` (`val greeting`, `echo "${greeting}"` → `hello_process_1.txt`); `convertToUpper` (input staged as `path 'input_file_1'`, `tr` reads it → `hello_process_2.txt`); `publish:` and `output { }` with `path 'helloworld'`, `mode 'copy'`. Known limit accepted by James: greetings containing `$`, `` ` ``, `"` or `\` are changed by bash.
  - `workflow/nextflow.config` (drafted by Code, reviewed and edited by James): `params.greeting = 'Hello World'`; `outputDir = 'results/nextflow'`; `process.container = 'bio-project-template:dev'` with James's comment on building it (`docker build --platform linux/amd64 -t bio-project-template:dev containers/`); profiles `test` (`resourceLimits` 2 CPUs, 4 GB, 1 h), `docker`, `docker_amd64` (`--platform linux/amd64`), `apptainer` (`autoMounts`). Keys for the template `CLAUDE.md`: `params.greeting`, `outputDir`.
  - Config discovery confirmed: launched from the repo root, Nextflow parses `workflow/nextflow.config` (project folder of `main.nf`); no design change needed.
  - Learned: `Path`-typed params must exist; built-in `outputDir` / `-o`; `env` inputs do not protect free text (Nextflow writes `export NAME="<value>"` unescaped; Code tested in scratch), `exec:` writes it verbatim.
- Step 5 (container), committed in `635d48b`: `containers/Dockerfile` (drafted by Code, reviewed by James) is `FROM ubuntu:24.04` with OCI labels (title, description, licence MIT) and no added tools; `bash`, `ps` and `tr` are already in the base image (checked with `docker run`). Repo URL label left out (would contain the GitHub username). Built amd64 on the Studio (Rosetta) and natively on the PC. A build without `--platform` on a Mac gives `linux/arm64`, which `docker_amd64` cannot use (Code tested with a throwaway tag). James chose to keep `pixi run test-nextflow` on `-profile test,docker`; on the Macs it runs with Docker's platform-mismatch warning.
- Step 6 (CI), committed in `20ad230`: `.github/workflows/ci.yml` (drafted by Code, reviewed by James): on push and pull request; `permissions: contents: read`; concurrency cancels older runs per ref; `runs-on: ubuntu-26.04`, 30 min timeout; `actions/checkout` v7.0.1 and `prefix-dev/setup-pixi` v0.11.3 pinned by commit SHA (looked up with `gh api`); `pixi-version: v0.84.2`, `locked: true`, `cache: true`; `docker build -t bio-project-template:dev containers/`; `pixi run test`. First run green (see Results).
- PC clone created this session by James: `~/repos/bio-project-template` (the `~/repos` folder did not exist before).

## In progress

- None.

## Blocked

- None.

## Deviations from the design

- Step 6: the image is built before `pixi run test`, and the Nextflow test profile runs inside `pixi run test` (task `test-nextflow`) instead of as a separate CI step. Same checks, one run. See inbox.

## Results

| Output | Host | Path | Produced by (command, commit) |
|---|---|---|---|
| Step 2 check passed: `pixi install --locked` ok; Nextflow 26.10.7, Snakemake 9.27.2 | Studio | `.pixi/envs/default` (ignored) | `pixi install --locked`; `275e6ce` |
| Step 3 check passed: `hello_rule_1.txt` = `Hello World`, `hello_rule_2.txt` = `HELLO WORLD` | Studio | `results/snakemake/helloworld/` (ignored) | `pixi run test-snakemake`; `2af6321` |
| Step 4 check passed with `ubuntu:24.04`: `hello_process_1.txt` = `Hello World`, `hello_process_2.txt` = `HELLO WORLD`; `docker_amd64` tasks' `.command.run` contain `--platform linux/amd64` | Studio | `results/nextflow/helloworld/` (ignored) | `pixi run test-nextflow` and `nextflow run workflow/main.nf -profile test,docker_amd64`; `f6ee037` |
| Step 5 image built: `bio-project-template:dev`, architecture `amd64` (reported by James); `test,docker_amd64` and `test,docker` runs completed with the image, `docker` with the platform-mismatch warning in `.command.err` (log checked by Code) | Studio | Docker image store (OrbStack VM); `results/nextflow/helloworld/` | `docker build --platform linux/amd64 -t bio-project-template:dev containers/`, `pixi run test-nextflow`; `635d48b` with the `nextflow.config` image change |
| Step 5 image built natively: `bio-project-template:dev`, `amd64`, ID `95c67e2fa729` (checked over SSH) | PC | Docker image store `/var/lib/docker` | `docker build -t bio-project-template:dev containers/` (run by James); `635d48b` |
| PC Nextflow test passed: both tasks exit 0, outputs `Hello World` / `HELLO WORLD`, empty `.command.err`, clean `git status`; `pixi.lock` SHA-256 `f4272dcd…` identical to the Studio | PC | `~/repos/bio-project-template/results/nextflow/helloworld/` (ignored) | `~/.pixi/bin/pixi install --locked && ~/.pixi/bin/pixi run test-nextflow` in `tmux` (run by Code over SSH); `635d48b` |
| CI run 45719956294 green in 31 s: runner `ubuntu-26.04` (image 20261116.202.1), Pixi 0.84.2, `pixi install --locked`, image built, Snakemake 3 of 3 steps, Nextflow 26.10.7 `-profile test,docker` both tasks ✔; cache saved | GitHub Actions | runner workspace (not kept) | `.github/workflows/ci.yml`; `20ad230` |

## Hours

<!-- One row per session. Ask James; never estimate. Write "unknown" if he does not know. -->

| Date | Session hours | Cumulative | Notes |
|---|---|---|---|
| 2026-11-23 | 0.75 | 0.75 | /sync-context, step 1 scaffold, `.gitignore` drafted and committed |
| 2026-11-24 | 2.5 | 3.25 | /sync-context, Pixi versions on 3 machines, step 2 `pixi.toml`/`pixi.lock` committed, step 3 Snakefile started |
| 2026-11-24 (continued) | 1 | 4.25 | Work after the first handoff: config `pathvars`, step 3 dry run and test passed |
| 2026-11-24 (third) | 0.5 | 4.75 | Rerun triggers (`params`, `--list-changes`), shell quoting and `:q`, trailing whitespace |
| 2026-11-24 (fourth) | 2 | 6.75 | Step 3 committed; step 4 started: `main.nf` processes, typed params, workflow outputs |
| 2026-11-25 | 3 | 9.75 | Step 4 finished (`nextflow.config`), step 5 Dockerfile built on Studio and PC, PC Nextflow test, step 6 CI green |

## Next

1. Step 7 (cross-machine run, James runs):
   - PC: run the full `pixi run test` (only `test-nextflow` has run there so far). Over non-interactive SSH `pixi` was not on the PATH when Code checked (`command -v pixi` empty); use `~/.pixi/bin/pixi` or an interactive `tmux` session.
   - MacBook: `brew uninstall pixi`, install Pixi 0.84.2 with the official installer (look up its version option first), check `which pixi` shows `~/.pixi/bin/pixi` and `pixi --version` shows 0.84.2; then `git pull`, build the image with `--platform linux/amd64`, `pixi install --locked`, `pixi run test`. The MacBook is 16 GB: test profile only.
   - Studio: full `pixi run test` at the current commit.
   - Log host, commit, command, result and the `pixi.lock` hash for each in this file.
2. Step 8 (smoke test): `nf-core/demo` from a scratch folder with `-w` set: `-profile test,docker,emulate_amd64` on a Mac, `-profile test,apptainer` on the PC.
3. Second CI run: check that "Set up Pixi" restores the cache (expected faster).
4. After Phase 0: switch `snakemake-minimal` to full `snakemake` in `pixi.toml` (James's decision; see inbox).
5. Step 9 note (carried forward): no placeholder `data/`, `results/` or `work/` folders in the template. The README describes the layout: workflows create `results/`; data lives outside the repo, with its path in `config/config.yaml`; Nextflow `work/` goes in a scratch folder set with `-w` for real runs. The README should also say that `bio-project-template:dev` must be built on each machine before the Nextflow test.
6. Note for step 7: folders only reach another machine once they hold a tracked file.
