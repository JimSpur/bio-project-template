# Image for the template's Nextflow processes.
# Build (amd64, also on Apple Silicon):
#   docker build --platform linux/amd64 -t bio-project-template:dev containers/
#
# Base image pinned to a release tag. The release image built in CI is
# pinned by digest (step 6); local builds use the tag.
# ubuntu:24.04 already has what Nextflow and the hello-world need:
# bash (runs each task), ps (task metrics) and tr.
FROM ubuntu:24.04

LABEL org.opencontainers.image.title="bio-project-template" \
      org.opencontainers.image.description="Base image for the bioinformatics project template's Nextflow processes" \
      org.opencontainers.image.licenses="MIT"

# Tools for later projects go here. How to install them (apt, micromamba,
# or Pixi from pixi.lock) is still open; see docs/context/inbox.md.
