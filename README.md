<img src="docs/assets/app-icon.png" alt="aaza app icon" width="64" height="64" />

# aaza (आज)

A minimal macOS menu bar app for Bikram Sambat (Nepali) date.

[![Release](https://img.shields.io/github/v/release/pray3m/aaza)](https://github.com/pray3m/aaza/releases)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![SwiftUI](https://img.shields.io/badge/SwiftUI-native-orange)
![License](https://img.shields.io/badge/license-MIT-blue)

`aaza` keeps today’s Nepali date visible in your macOS menu bar with a native, lightweight UI.

## Features

- Always-visible BS date in the menu bar.
- Built with `SwiftUI` + `MenuBarExtra`.
- Kathmandu timezone aware (`Asia/Kathmandu`).
- Midnight rollover refresh for date changes.

## Install

1. Download the latest `aaza-v*-macOS.zip` from [Releases](https://github.com/pray3m/aaza/releases).
2. Unzip and move `aaza.app` to `/Applications`.
3. Open `aaza.app`.

## Run Locally

1. Open `aaza.xcodeproj` in Xcode.
2. Select target `aaza` and run.
3. The date appears in your menu bar.

## Release

Public release/signing/notarization workflow is documented in [`RELEASE.md`](RELEASE.md).

## Roadmap

- [ ] Launch at Login.
- [ ] Devanagari/English numeral toggle.
- [ ] Quick copy to clipboard.
- [ ] Optional quick link to full monthly calendars.

## License

[MIT](LICENSE)

## Contributing

PRs are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).
