# Release Guide (Maintainers Only, macOS non-App Store)

This document is for developers/maintainers who publish new app versions.
It is not an end-user install guide.

For users:
- Install instructions are in `README.md`.
- Download binaries from GitHub Releases.

This repository is public open source. Keep release steps reproducible and avoid leaking credentials.

## Prerequisites

- Active Apple Developer Program membership.
- `Developer ID Application` certificate installed in Keychain.
- Xcode signed in with the same team used in this project.
- Project signing points to your team and bundle ID.
- `xcodebuild`, `notarytool`, `codesign`, and `spctl` available.

## 1) Set version

In Xcode target settings:

- `MARKETING_VERSION`: user version (example: `1.0.0`)
- `CURRENT_PROJECT_VERSION`: build number (example: `1`)

## 2) Build signed artifact

From repo root:

```bash
scripts/release-macos.sh 1.0.0
```

Expected output:

```text
build/aaza-v1.0.0-macOS.zip
```

## 3) Notarization (recommended for public distribution)

Preferred: use a keychain profile created by `notarytool store-credentials`.

Fallback (supported by the script): export env vars and re-run:

```bash
export APPLE_ID="you@example.com"
export APPLE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"
export TEAM_ID="ABCD123456"
scripts/release-macos.sh 1.0.0
```

The script will submit, wait, staple, and recreate the final zip.

## 4) Validate release artifact

Run verification checks before publishing:

```bash
codesign --verify --deep --strict --verbose=2 build/export/aaza.app
spctl -a -vvv -t install build/export/aaza.app
shasum -a 256 build/aaza-v1.0.0-macOS.zip
```

Also test on a clean user account or separate Mac:

- Unzip and move `aaza.app` to `/Applications`.
- Launch from Finder.
- Confirm no Gatekeeper warning after notarization.

## 5) Publish on GitHub

1. Create and push tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

2. Create a GitHub Release for `v1.0.0`.
3. Upload `build/aaza-v1.0.0-macOS.zip`.
4. Add release notes and include SHA-256 checksum.
5. Keep install instructions short in the release body.

## Security and hygiene

- Never commit Apple credentials, app passwords, or notarization secrets.
- Prefer short-lived/revocable credentials.
- Keep release notes and changelog user-facing and concise.
- Re-run release from a clean `git` state to improve reproducibility.
