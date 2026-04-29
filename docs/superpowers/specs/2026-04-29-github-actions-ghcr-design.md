---
title: GitHub Actions — Build & Push to GHCR
date: 2026-04-29
status: approved
---

# GitHub Actions: Build & Push to GHCR

## Problem

The repository has no CI/CD. Container images are built and run locally. We need an automated pipeline that validates code and publishes a versioned image to GitHub Container Registry on every merge to `main` and on explicit version tags.

## Goals

- Run unit/API tests as a fail-fast gate before any image is produced
- Build and push the Docker image to `ghcr.io` on push to `main` and on `v*` tags
- Tag images in a conventional, human-readable way (`latest` + semver)
- Require no extra secrets — use the built-in `GITHUB_TOKEN` for GHCR auth

## Non-Goals

- Multi-platform builds (arm64 deferred until needed)
- Running integration tests in CI (requires a live PostgreSQL; out of scope for now)
- Deployment or CD beyond image publication

## Design

### Trigger

```
on:
  push:
    branches: ["main"]
    tags:     ["v*"]
```

- Push to `main` → `:latest`
- Push of a `v*` tag (e.g., `v1.2.3`) → `:1.2.3` **and** `:latest`

### Workflow Structure

Single file: `.github/workflows/docker-publish.yml`

Two sequential jobs:

```
test  ──→  build-push
```

`build-push` has `needs: test`, so a test failure cancels the build immediately.

### Job: `test`

| Step | Action |
|---|---|
| Checkout | `actions/checkout@v4` |
| Python 3.12 | `actions/setup-python@v5` with `cache: pip` |
| Install deps | `pip install -r requirements-dev.txt` |
| Run tests | `pytest tests/` |

Uses Python 3.12 to match the Dockerfile runtime. Runs only `tests/` (unit + API tests; no DB or network required per CLAUDE.md).

### Job: `build-push`

| Step | Action |
|---|---|
| Checkout | `actions/checkout@v4` |
| GHCR login | `docker/login-action@v3` with `GITHUB_TOKEN` |
| Extract tags/labels | `docker/metadata-action@v5` |
| Build & push | `docker/build-push-action@v6` with GHA layer cache |

**Image name:** `ghcr.io/${{ github.repository }}` → `ghcr.io/OWNER/aws-pricing-list-loader`

**Tag rules:**

| Event | Tags produced |
|---|---|
| Push to `main` | `:latest` |
| Push of tag `v1.2.3` | `:1.2.3`, `:latest` |

**Permissions:** `packages: write` scoped to the `build-push` job only (principle of least privilege).

**Layer caching:** `type=gha` (GitHub Actions cache). Unchanged layers are reused on repeat pushes, keeping build times short.

### Auth

`GITHUB_TOKEN` is automatically provisioned by GitHub Actions for every run. No repository secrets need to be configured manually. GHCR accepts this token for pushes when `packages: write` is granted.

## File Created

`.github/workflows/docker-publish.yml`

## Verification

1. Push to `main` → GitHub Actions tab shows `test` and `build-push` both succeed
2. `ghcr.io/OWNER/aws-pricing-list-loader:latest` appears under GitHub → Packages
3. Push tag `v0.1.0` → both `:0.1.0` and `:latest` appear in the package registry
4. `docker pull ghcr.io/OWNER/aws-pricing-list-loader:latest` succeeds locally
