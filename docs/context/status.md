# Status

<!-- Owner: Claude Code. Rewritten by /handoff at the end of each session. -->

Last updated: 2026-11-26, machine: Studio, commit: eefce5b (pushed, `main` up to date with `origin/main`). Steps 6b and 7 done; step 8 next.

## Done

- Step 1 (scaffold). `.gitignore` drafted by Code, reviewed by James, committed in `ae3e293`. `.pixi/` ignores the whole Pixi folder; `.pixi/config.toml` is not tracked.
- Pixi: official installer (`~/.pixi/bin/pixi`) on all three machines. Studio and PC 0.84.2; MacBook 0.85.0 (Homebrew Pixi replaced this session; James chose to keep 0.85.0, see inbox). CI uses 0.84.2.
- PC non-interactive SSH: `ssh ubuntu-pc 'command -v pixi'` now prints `~/.pixi/bin/pixi`, and `command -v claude` prints `~/.local/bin/claude` (checked by Code 2026-11-26). Plain `pixi` works over SSH.
- Step 2 (Pixi environment), committed in `275e6ce`, changed in step 6b: `pixi.toml` with `requires-pixi = ">=0.84.2"`, platforms `osx-arm64` and `linux-64`, tasks `test-snakemake`, `test-nextflow`, `test` (depends on both); `pixi.lock` (lock version 7); `.gitattributes` from `pixi init`.
- Step 3 (Snakemake hello-world), written by James, committed in `d5cd866` and `2af6321`: `workflow/Snakefile` (`write_greeting` with `{params.txtstring:q}`, `transform_greeting` with `tr`, `rule all`); `config/config.yaml` keys `pathvars.outdir = "results/snakemake/helloworld"` and `txtstring = "Hello World"`.
- Step 4 (Nextflow hello-world), committed in `5ba3d46`, `f6ee037`, `2379f9e`: `workflow/main.nf` (written by James; typed `params { greeting: String }`, processes `sayHello` and `convertToUpper`, `publish:` / `output { }` to `helloworld`); `workflow/nextflow.config` (drafted by Code, reviewed by James): `params.greeting = 'Hello World'`, `outputDir = 'results/nextflow'`, `process.container = 'bio-project-template:dev'`, profiles `test`, `docker`, `docker_amd64`, `apptainer`. Keys for the template `CLAUDE.md`: `params.greeting`, `outputDir`. Known limit accepted by James: greetings containing `$`, `` ` ``, `"` or `\` are changed by bash.
- Step 5 (container), committed in `635d48b`: `containers/Dockerfile` is `FROM ubuntu:24.04` with OCI labels (title, description, licence MIT) and no added tools. `pixi run test-nextflow` stays on `-profile test,docker`; on the Macs it runs with Docker's platform-mismatch warning.
- Step 6 (CI), committed in `20ad230`: `.github/workflows/ci.yml` on push and pull request, `ubuntu-26.04`, actions pinned by SHA, `pixi-version: v0.84.2`, builds `bio-project-template:dev`, then `pixi run test`.
- Step 6b (template finalisation), drafted by Code, reviewed by James:
  - (a) Committed in `1ef68ed`. `pixi.toml` `[dependencies]`: `snakemake = "9.27.*"` replaces `snakemake-minimal` (which stays in the lock as a dependency of `snakemake`; James predicted this), and `python = "3.14.*"` added. Before the pin, the lock had Python 3.13.18 on `linux-64` and 3.14.10 on `osx-arm64`. Code tested in a scratch copy that nothing forces 3.13 and that 3.14 solves on both platforms; James chose 3.14 (see inbox). New lock: Python 3.14.10 on both platforms, Snakemake 9.27.2.
  - (b) Committed in `eefce5b`. `.editorconfig`: `root = true`; all files UTF-8, LF, final newline, trimmed trailing whitespace; `*.md` keeps trailing whitespace; `pixi.lock` rules `unset`. Indentation block left commented out (James's choice). Code checked that no tracked file broke the rules before the commit.
  - (c) Committed in `eefce5b`. CI step "Check whitespace" after checkout: `git diff --check 4b825dc642cb6eb9a060e54bf8d69288fbee4904` (git's SHA-1 empty tree; the computed form `$(git hash-object -t tree /dev/null)` was offered, and James kept the literal). `.gitattributes` adds `*.md -whitespace`; `pixi.lock` is skipped through its existing `-diff` attribute, which also applies to projects made from the template. Code tested in a scratch clone: passes on the repo, fails (exit 2) on trailing spaces in `workflow/Snakefile`, ignores the same error in `README.md` and `pixi.lock`.
- Step 7 (cross-machine run) at `eefce5b`: same `pixi.lock` SHA-256 `0c6d6ca335460d18fa834cfa5e28f38480a714ba3590f81f8c5727e541605c7e` and full `pixi run test` passing on the PC, the Studio and the MacBook (see Results).

## In progress

- None.

## Blocked

- None.

## Deviations from the design

- Step 6b(a) also pins `python = "3.14.*"` in `pixi.toml`; not in the design. See inbox.
- Pixi versions differ between machines (MacBook 0.85.0, others 0.84.2), against the 2026-11-25 decision. James's choice; see inbox.
- Step 7 on the PC was run by Code over SSH in `tmux`, at James's request (design says James runs).

## Results

| Output | Host | Path | Produced by (command, commit) |
|---|---|---|---|
| Step 2 check passed: `pixi install --locked` ok; Nextflow 26.10.7, Snakemake 9.27.2 | Studio | `.pixi/envs/default` (ignored) | `pixi install --locked`; `275e6ce` |
| Step 3 check passed: `hello_rule_1.txt` = `Hello World`, `hello_rule_2.txt` = `HELLO WORLD` | Studio | `results/snakemake/helloworld/` (ignored) | `pixi run test-snakemake`; `2af6321` |
| Step 4 check passed with `ubuntu:24.04` | Studio | `results/nextflow/helloworld/` (ignored) | `pixi run test-nextflow`; `f6ee037` |
| Step 5 image built: `bio-project-template:dev`, `amd64` | Studio, PC | Docker image store | `docker build [--platform linux/amd64] -t bio-project-template:dev containers/`; `635d48b` |
| CI run 45719956294 green (step 6) | GitHub Actions | runner workspace (not kept) | `.github/workflows/ci.yml`; `20ad230` |
| Step 6b(a) check passed: `pixi lock`, `pixi install --locked`, `pixi run test` ok (reported by James); `pixi run python --version` = 3.14.10, lock has `python-3.14.10` for both platforms (checked by Code) | Studio | `.pixi/envs/default` (ignored) | `pixi lock && pixi install --locked && pixi run test`; working tree later committed as `1ef68ed` |
| CI run 45792921356 green | GitHub Actions | not kept | `ci.yml`; `1ef68ed` |
| CI run 45795842749 green: "Check whitespace", image build and `pixi run test` all succeeded; "Set up Pixi" logged `Cache hit` and `Cache restored successfully` (lock unchanged since `1ef68ed`) (checked by Code with `gh run view`) | GitHub Actions | not kept | `ci.yml`; `eefce5b` |
| Step 7 PC: clean tree, lock hash `0c6d6ca3…`, image `amd64` ID `b8454587947c` (differs from step 5's `95c67e2fa729`; cause not checked, Dockerfile unchanged, likely a newer `ubuntu:24.04`), Python 3.14.10, fresh run: Snakemake 3 of 3, Nextflow both tasks ✔, `EXIT=0`, outputs `Hello World` / `HELLO WORLD` (checked by Code over SSH) | PC | `~/repos/bio-project-template/results/` (ignored); log `~/step7-test.log` | `docker build -t bio-project-template:dev containers/ && pixi install --locked && pixi run test` in `tmux` (run by Code); `eefce5b` |
| Step 7 Studio: clean tree, lock hash `0c6d6ca3…`, `pixi run test` passed (reported by James); after deleting `results/snakemake/`, `pixi run test-snakemake` reran both rules, outputs `Hello World` / `HELLO WORLD` (checked by Code) | Studio | `results/snakemake/helloworld/`, `results/nextflow/helloworld/` (ignored) | `pixi run test`, then `pixi run test-snakemake`; `eefce5b` |
| Step 7 MacBook: Pixi 0.85.0, clean tree, lock hash `0c6d6ca3…`, image `amd64` (output pasted by James); fresh `pixi run test` passed (reported by James) | MacBook | `results/` (ignored) | `docker build --platform linux/amd64 -t bio-project-template:dev containers/`, `pixi install --locked`, `pixi run test`; `eefce5b` |

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
| 2026-11-26 | 1.5 | 11.25 | /sync-context, step 6b (full Snakemake, Python pin, `.editorconfig`, CI whitespace check), step 7 on PC, Studio and MacBook |

## Next

1. Step 8 (smoke test, James runs): `nf-core/demo` with the template's Pixi `nextflow`, launched from a scratch folder outside the repo with `-w` set: `-profile test,docker,emulate_amd64` on a Mac, `-profile test,apptainer` on the PC (in `tmux`). Check: 8 of 8 tasks on each. Log host, commit, command and result here.
2. If the Project updates the Pixi version decision (see inbox), James adjusts the comments in `pixi.toml` ("Same version on the Studio, MacBook, PC and in CI") and `ci.yml` ("keep equal to requires-pixi").
3. Step 9 (README, James) notes carried forward: no placeholder `data/`, `results/` or `work/` folders in the template; the README describes the layout (workflows create `results/`, data outside the repo with its path in `config/config.yaml`, Nextflow `work/` in a scratch folder set with `-w` for real runs). Design step 9 adds: build the image on each machine first, the expected platform-mismatch warning on the Macs, and renaming the `bio-project-template:dev` tag in the create-a-project steps. Possibly mention `.editorconfig` (Positron may need the EditorConfig extension; not checked) and the local whitespace check `git diff --check 4b825dc642cb6eb9a060e54bf8d69288fbee4904`.
4. Note: folders only reach another machine once they hold a tracked file.
