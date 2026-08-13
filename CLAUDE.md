# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

HardcoreTap is a rhythm game: tap the screen exactly once per second, accurate to hundredths.
The tolerance window shrinks as the round goes on. Miss it and the round ends.

The app targets **iOS 26**, builds with **Swift 6 language mode**, and has **no third-party
dependencies** — no SPM packages, no CocoaPods, no Carthage.

## Commands

All Xcode commands run from `Source/`.

Build:

```bash
xcodebuild build -project HardcoreTap.xcodeproj -scheme HardcoreTap -destination 'platform=iOS Simulator,name=iPhone 17'
```

Run the full test suite:

```bash
xcodebuild test -project HardcoreTap.xcodeproj -scheme HardcoreTap -destination 'platform=iOS Simulator,name=iPhone 17'
```

Run a single test or suite (Swift Testing, so filter by name):

```bash
xcodebuild test -project HardcoreTap.xcodeproj -scheme HardcoreTap -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:HardcoreTapTests/GameEngineTests/tapOnTheBeatScores
```

Lint:

```bash
swiftlint lint --quiet
```

Fastlane lanes (`test`, `lint`, `beta`, `release`) live in `Source/fastlane/Fastfile`:

```bash
bundle exec fastlane test
```

## Architecture

### The project file is folder-synchronized

`project.pbxproj` uses `PBXFileSystemSynchronizedRootGroup` (Xcode 16+). **Adding a Swift file
to `Source/HardcoreTap/` puts it in the target automatically** — there are no per-file
`PBXBuildFile` entries to maintain, and nothing to edit in the project file when you add,
move, or delete sources.

There is no `Info.plist`. It is generated from `INFOPLIST_KEY_*` build settings
(`GENERATE_INFOPLIST_FILE = YES`), so plist changes are build-setting changes.

Asset symbols are generated (`ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS`),
which is why colours are referenced as `.lipstick` / `.robinSEgg` and images as `Image(.rule1)`
rather than by string.

### The engine is the game, and it is pure

`Features/Game/GameEngine.swift` holds all the rules. The one design decision worth knowing:
**every method takes the current `ContinuousClock.Instant` as a parameter** rather than reading
the clock itself. That is what lets `GameEngineTests` play out a full round — hits, misses,
tolerance decay, the restart cool-down — in 11 ms of wall clock. Preserve that when changing it;
if a method starts calling `.now` internally, the tests lose their grip on time.

The engine drives itself with a `Task` polling at 8 ms (`startTicking`), which is what detects a
beat that was never tapped. Views never poll it.

The judging rule, inherited from the 2017 build: the beat after `score` hits is due at
`score + 1` seconds, and a tap counts if `|elapsed - nextBeat| <= tolerance`. Tolerance starts at
0.10 s and shrinks by 0.01 s per beat to a 0.05 s floor (`GameMode.tolerance(forScore:)`).

### State lives in `@Observable` classes injected through the environment

`HardcoreTapApp` owns four of them and injects them with `.environment(_:)`:

| Object | Responsibility |
| --- | --- |
| `PlayerProfile` | Nickname and per-mode records in `UserDefaults` |
| `GameCenterService` | GameKit authentication, score submission, leaderboard entries |
| `Metronome` | The 60 BPM backing loop, and the setting that toggles it |
| `ToastCenter` | Transient banners |

`GameEngine` is the exception: it is `@State` inside `GameScreen`, because a round belongs to
that screen and should not survive it.

### Two behaviours that look like bugs but are deliberate

**Game Center sign-in is never auto-presented.** `GKLocalPlayer`'s handler fires during launch
and may hand back a view controller. Presenting it immediately throws a modal over the game
before the player has asked for anything — and when Game Center is misconfigured, that modal is
blank. `GameCenterService` stores the controller in `signInController`; `LeaderboardScreen`
offers a button that presents it. Any Game Center failure degrades to showing the local record.

**A defeat is handled in `onChange(of: engine.phase)`, not in the tap handler.** A round can end
two ways — a bad tap, or a beat that was never tapped — and only the first passes through
`handleTap`. Recording the score in the phase observer covers both.

### Legacy the code still honours

`UserDefaults` keys `userNAME`, `highscore_normal` and `bgSound` are the ones the shipped 1.x app
wrote. They are kept verbatim so an existing install keeps its nickname and record. Don't rename
them.

The original UIKit implementation is not in the working tree; it is on the `master` branch
(`HardcoreTap/HardcoreTap/ViewController.swift`), which is the code that actually shipped to the
App Store. Read it there if you need the historical behaviour of something.

### Localization

`Resources/Localizable.xcstrings` is a String Catalog, source language `en` with `ru`
translations. Keys are the English source strings. Numbers must go through
`.formatted(.number…)` rather than `String(format:)` so the decimal separator follows the
locale — Russian writes `0,10`.

## Known gaps

- The Game Center leaderboard IDs in `GameMode.leaderboardID`
  (`hardcoretap.leaderboard.normal` / `.hardcore`) do not exist in App Store Connect yet.
  Until they do, submissions no-op and the leaderboard shows local records only.
- `Source/Gemfile.lock` is maintained by Dependabot; leave version bumps to it.
