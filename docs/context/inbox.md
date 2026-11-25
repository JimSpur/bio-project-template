# Inbox

<!-- Owner: Claude Code. Questions and proposed design changes for the Claude Project.
     The Claude Project resolves each entry, records the outcome in decisions.md or design.md,
     and marks it Resolved here on the next push. -->

## Open

<!-- ### YYYY-MM-DD: <title>
- Context: <what was found>
- Question or proposal: <...>
- Impact if ignored: <...> -->

### 2026-11-23: Pixi install method differs between machines
- Context: on the MacBook, Pixi 0.84.2 is installed through Homebrew (`/opt/homebrew/bin/pixi`). `CLAUDE.md` expects the official installer's path (`~/.pixi/bin/pixi`) on the PC. The Studio has not been checked yet. Design step 2 pins the minimum version with `requires-pixi`, and CI uses that same version.
- Question or proposal: should all three machines install Pixi the same way (official installer, or Homebrew on the Macs), and should the version be updated on purpose rather than by `brew upgrade`? This may be a dotfiles decision.
- Impact if ignored: `brew upgrade` could move the MacBook to a newer Pixi than the PC and CI, so the machines might write or read `pixi.lock` differently. Commands that call `~/.pixi/bin/pixi` by full path would also not work on the MacBook.
- Update 2026-11-24: checked on all three. Studio and PC: Pixi 0.84.2 from the official installer (`~/.pixi/bin/pixi`). James decided to remove Homebrew Pixi from the MacBook and install 0.84.2 with the official installer next session there, so all three match. `pixi.toml` now has `requires-pixi = ">=0.84.2"`. Proposed outcome: record "official installer on every machine, version changed on purpose" and mark this Resolved; dotfiles may need a note.

### 2026-11-24: `.gitattributes` is not in the plumbing list
- Context: `pixi init` (step 2) created `.gitattributes`, which marks `pixi.lock` as generated and binary for merges. It is committed in `275e6ce`. The plumbing list in `CLAUDE.md` names `.gitignore` but not `.gitattributes`.
- Question or proposal: add `.gitattributes` to the plumbing list (Code drafts, James reviews). Code is treating it that way until then.
- Impact if ignored: unclear ownership of the file. Low risk, it rarely changes.

### 2026-11-24: Switch to full Snakemake after Phase 0
- Context: `pixi.toml` uses `snakemake-minimal = "9.27.*"`, which is enough for the hello-world. James decided it should become full `snakemake` once Phase 0 is complete.
- Question or proposal: record this in the design or decisions, so the switch happens at close (template) or at the start of Phase 1.
- Impact if ignored: later projects start with `snakemake-minimal` and may miss plugins (executors, storage, reports) they expect.

### 2026-11-24: Add an `.editorconfig` to the template
- Context: `workflow/Snakefile` (`d5cd866`) has trailing spaces on lines 11 and 18 that James's editor (Positron) does not show; they were found with `cat -vet`. Trailing whitespace causes noisy diffs, breaks shell line continuations after `\`, and changes Markdown rendering.
- Question or proposal: add a plumbing file `.editorconfig` at the repo root (for example `trim_trailing_whitespace = true`, `insert_final_newline = true`, `charset = utf-8`, with `trim_trailing_whitespace = false` for `*.md`), drafted by Code and reviewed by James. Optionally a CI check with `git diff --check`. Needs a place in `design.md` and the plumbing list in `CLAUDE.md`.
- Impact if ignored: each project created from the template relies on per-editor settings; whitespace-only changes keep appearing in diffs.

### 2026-11-24: Step 4 check needs a container before step 5 makes one
- Context: design step 4 checks `pixi run test-nextflow` with `-profile test,docker`, but the template image (`containers/Dockerfile`) is only built in step 5. With the `docker` profile every process needs an image.
- Question or proposal (James's choice, being followed): develop `main.nf` with no profile (local executor), then pass the step 4 check with a small public base image set in `nextflow.config`; step 5 replaces it with the template image. The hello-world processes only call `echo` and `tr`. Please record this in `design.md` step 4.
- Impact if ignored: step 4's check cannot pass as written without reordering steps 4 and 5.

### 2026-11-25: How later projects install tools into the container
- Context: step 5 `containers/Dockerfile` is `FROM ubuntu:24.04` with labels only; the hello-world needs nothing extra (`bash`, `ps`, `tr` are in the base image, checked with `docker run`). James chose to keep it minimal and decide the install method later.
- Question or proposal: pick the pattern later projects follow to add tools: `apt-get` in the Dockerfile; micromamba with an environment file; or Pixi installing the `linux-64` environment from the same `pixi.lock` (official Pixi images exist), which keeps the container and the host environment in step. Record it in `design.md` before Phase 1.
- Impact if ignored: each project invents its own method, and container tool versions can drift from `pixi.lock`.

### 2026-11-25: CI step order and the image name in `nextflow.config`
- Context: design step 6 lists "run `pixi run test`, build the amd64 image, run the Nextflow test profile with it". `pixi run test` already includes `test-nextflow` (`-profile test,docker`), which needs the image, so `ci.yml` builds `bio-project-template:dev` first and runs `pixi run test` once (green, run 45719956294 at `20ad230`). `workflow/nextflow.config` now sets `process.container = 'bio-project-template:dev'`, a local tag that must be built on each machine (Studio, MacBook, PC, CI) before the Nextflow test.
- Question or proposal: update design step 6 to this order. Decide later how projects made from the template name the image (the tag carries the template's name) and when `process.container` switches to the digest-pinned release image.
- Impact if ignored: design and `ci.yml` disagree on the step order; new projects keep the template's image name.

### 2026-11-25: Image label for the repo URL
- Context: `containers/Dockerfile` has OCI labels for title, description and licence. `org.opencontainers.image.source` (the GitHub repo URL) was left out because it contains the GitHub username, and `CLAUDE.md` says no usernames in this public repo.
- Question or proposal: does the public repo URL count as a username under that rule? If not, add the `source` label (it links images in GitHub's registry to the repo).
- Impact if ignored: images have no link back to their source repo. Low impact in Phase 0.

## Resolved

