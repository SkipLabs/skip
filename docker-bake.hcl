# Docker image build definitions.
#
# Usage:
#   docker buildx bake [--push] [TARGET...]
#
# Override variables from the command line:
#   docker buildx bake --set '*.platform=linux/amd64,linux/arm64' --push
#
# BuildKit automatically parallelizes independent targets and deduplicates
# shared layers (e.g. skiplang and skip share the same Dockerfile).

# ---------------------------------------------------------------------------
# Groups
# ---------------------------------------------------------------------------

group "default" {
  targets = [
    "skiplang", "skiplang-bin-builder", "skip",
    "skdb-base", "skdb", "skdb-dev-server",
  ]
}

# The set of images published to Docker Hub, and the single source of truth for
# what both bin/release_docker_ci_images.sh and .github/workflows/docker-publish.yml
# publish. bin/check_ci_images.sh asserts that every skiplabs/ image CircleCI
# pulls appears here.
#
# Mostly toolchain images: their final stages contain compiled binaries and apt
# packages but no repo source, so any commit on main can rebuild them and
# republishing is not a release.
#
# skdb-dev-server is the exception. It bakes in source, so publishing it from
# main IS a release of main, and its :latest tracks main rather than the last
# tagged release. That is deliberate: left manual it went a year without a
# rebuild and rotted to 1 critical / 18 high (#1363), and it is the only one of
# these images that users actually run. A stale :latest is the worse failure.
# Release-semantic tags (e.g. skdb-dev-server:quickstart) stay manual, via
# bin/release_docker_skdb_dev_server.sh.
#
# skdb is absent but still gets rebuilt here, as a link-only dependency of
# skdb-dev-server: bake forces such targets to output=cacheonly, so it is built
# fresh and consumed but never pushed. Publishing skiplabs/skdb itself stays
# manual.
#
# skiplang-bin-builder is published but never pulled by CI, which is why this
# list cannot be derived from .circleci/ -- and why it went a year without a
# rebuild (#1338).
group "ci" {
  targets = [
    "skiplang", "skiplang-bin-builder", "skip", "skdb-base", "skdb-dev-server",
  ]
}

group "local" {
  targets = [
    "skiplang", "skiplang-bin-builder", "skip",
    "skdb-base", "skdb", "server-core", "skdb-dev-server",
  ]
}

# ---------------------------------------------------------------------------
# Targets
# ---------------------------------------------------------------------------

# Root Dockerfile — skiplang target (compiler only)
target "skiplang" {
  dockerfile = "Dockerfile"
  target     = "skiplang"
  tags       = ["skiplabs/skiplang:latest"]
}

# Separate Dockerfile for the bin-builder image (debian-based)
target "skiplang-bin-builder" {
  dockerfile = "skiplang/Dockerfile"
  tags       = ["skiplabs/skiplang-bin-builder:latest"]
}

# Root Dockerfile — full build (extends skiplang stage)
target "skip" {
  dockerfile = "Dockerfile"
  tags       = ["skiplabs/skip:latest"]
}

# sql/Dockerfile — base target (tools only, no source)
# Depends on skip: "FROM skiplabs/skip" is intercepted by the named context.
target "skdb-base" {
  dockerfile = "sql/Dockerfile"
  target     = "base"
  tags       = ["skiplabs/skdb-base:latest"]
  contexts   = { "skiplabs/skip" = "target:skip" }
}

# sql/Dockerfile — full build (extends base, compiles skdb)
target "skdb" {
  dockerfile = "sql/Dockerfile"
  tags       = ["skiplabs/skdb:latest"]
  contexts   = { "skiplabs/skip" = "target:skip" }
}

# Standalone Gradle build — not published, local/prod only
target "server-core" {
  dockerfile = "sql/server/core/Dockerfile"
  tags       = ["skiplabs/server-core:latest"]
}

# Multi-stage: copies artifacts from skdb + builds Gradle jar
target "skdb-dev-server" {
  dockerfile = "sql/server/dev/Dockerfile"
  tags       = ["skiplabs/skdb-dev-server:latest"]
  contexts   = { "skiplabs/skdb" = "target:skdb" }
}

# Native shared library for Skip runtime (opt-in, not in any group)
target "skipruntime" {
  dockerfile = "skipruntime-ts/Dockerfile"
  contexts   = { "skiplabs/skiplang-bin-builder" = "target:skiplang-bin-builder" }
}
