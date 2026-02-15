#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/release-macos.sh 1.0.0
# Optional notarization env vars:
#   APPLE_ID=you@example.com APPLE_APP_PASSWORD=xxxx TEAM_ID=ABCD123456 scripts/release-macos.sh 1.0.0

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>"
  exit 1
fi

PROJECT="aaza.xcodeproj"
SCHEME="aaza"
CONFIG="Release"
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/${SCHEME}.xcarchive"
EXPORT_PATH="$BUILD_DIR/export"
APP_PATH="$EXPORT_PATH/${SCHEME}.app"
TEMP_ZIP_PATH="$BUILD_DIR/${SCHEME}-notary.zip"
FINAL_ZIP_PATH="$BUILD_DIR/${SCHEME}-v${VERSION}-macOS.zip"

rm -rf "$ARCHIVE_PATH" "$EXPORT_PATH" "$TEMP_ZIP_PATH" "$FINAL_ZIP_PATH"
mkdir -p "$BUILD_DIR"

echo "[1/6] Archiving app..."
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -archivePath "$ARCHIVE_PATH" \
  -destination "generic/platform=macOS"

echo "[2/6] Exporting signed app..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "scripts/ExportOptions.plist"

if [[ ! -d "$APP_PATH" ]]; then
  echo "Export failed: app not found at $APP_PATH"
  exit 1
fi

echo "[3/6] Verifying code signature..."
codesign --verify --deep --strict --verbose=2 "$APP_PATH"

# Create a temporary zip used for notarization submission.
echo "[4/6] Preparing zip for notarization..."
ditto -c -k --keepParent "$APP_PATH" "$TEMP_ZIP_PATH"

if [[ -n "${APPLE_ID:-}" && -n "${APPLE_APP_PASSWORD:-}" && -n "${TEAM_ID:-}" ]]; then
  echo "[5/6] Submitting for notarization..."
  xcrun notarytool submit "$TEMP_ZIP_PATH" \
    --apple-id "$APPLE_ID" \
    --password "$APPLE_APP_PASSWORD" \
    --team-id "$TEAM_ID" \
    --wait

  echo "Stapling notarization ticket..."
  xcrun stapler staple "$APP_PATH"
else
  echo "[5/6] Skipping notarization (APPLE_ID/APPLE_APP_PASSWORD/TEAM_ID not set)."
fi

echo "[6/6] Creating final distributable zip..."
ditto -c -k --keepParent "$APP_PATH" "$FINAL_ZIP_PATH"

echo "Done. Artifact: $FINAL_ZIP_PATH"
echo "Tip: test on a clean Mac user account before publishing."
