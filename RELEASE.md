# aaza macOS Distribution (v1)

This guide is for direct download distribution outside the Mac App Store.

## Prerequisites

- Apple Developer Program membership.
- A **Developer ID Application** certificate installed on your Mac.
- Xcode signed in with the same team used by the project.
- Project signing settings already point to your team and bundle id (`pray3m.aaza`).

## 1) Set release version

In Xcode target settings:
- `MARKETING_VERSION`: user-facing version (example: `1.0.0`)
- `CURRENT_PROJECT_VERSION`: build number (example: `1`)

## 2) Build + export + zip

Run from repo root:

```bash
scripts/release-macos.sh 1.0.0
```

Artifact is created at:

```text
build/aaza-v1.0.0-macOS.zip
```

## 3) Notarize (recommended for public release)

Set credentials and run the same script:

```bash
export APPLE_ID="you@example.com"
export APPLE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"
export TEAM_ID="ABCD123456"
scripts/release-macos.sh 1.0.0
```

The script will:
- submit to Apple notary service,
- wait for completion,
- staple ticket to the app,
- rebuild final zip for distribution.

## 4) Verify before publish

- Unzip on a separate Mac user account.
- Launch `aaza.app` from Finder.
- Confirm no Gatekeeper warning after notarization.

Optional checks:

```bash
codesign --verify --deep --strict --verbose=2 build/export/aaza.app
spctl -a -vvv -t install build/export/aaza.app
```

## 5) Publish

- Create a GitHub Release tag (`v1.0.0`).
- Upload `build/aaza-v1.0.0-macOS.zip` as release asset.
- Add install note: "Download, unzip, move `aaza.app` to Applications, then open."
