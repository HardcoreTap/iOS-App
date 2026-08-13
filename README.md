# HardcoreTap
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![iOS](https://img.shields.io/badge/iOS-26.0%2B-yellow.svg)
![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen.svg)

_Originally built at the Swiftbook.ru hackathon (2nd place), rebuilt on a modern stack._

### About the game

You must be able to kill time. HardcoreTap helps to kill time, not in vain, but with benefit.
The player receives benefit in the form of training of attentiveness, rhythm and perseverance.
The main task of the player is to tap on the screen exactly 1 time per second with an accuracy of
hundredths. At first the game is not so cruel and forgives a few hundredths, but the tolerance
shrinks with every beat until it reaches 0.05 s. Miss the window and you start again.

Two modes: **Normal** starts at ±0.10 s and narrows to ±0.05 s, **Hardcore** is a flat ±0.01 s.

### Stack

- SwiftUI throughout, `@main App` lifecycle — no storyboards, no view controllers except the one
  Game Center hands back
- `@Observable` state, Swift 6 strict concurrency
- Timing on `ContinuousClock`, injected as a parameter so the engine is deterministic in tests
- GameKit for the leaderboard, degrading to local records when Game Center is unavailable
- Swift Testing, String Catalog localization (en/ru), SwiftLint
- Zero third-party dependencies

### Building

Requires Xcode 26 or newer.

```bash
cd Source
xcodebuild build -project HardcoreTap.xcodeproj -scheme HardcoreTap -destination 'platform=iOS Simulator,name=iPhone 17'
```

```bash
cd Source
xcodebuild test -project HardcoreTap.xcodeproj -scheme HardcoreTap -destination 'platform=iOS Simulator,name=iPhone 17'
```

The Xcode project uses folder-synchronized groups, so new files under `Source/HardcoreTap/` join
the target automatically.

### History

The version that shipped to the App Store (UIKit, storyboards, Firebase Realtime Database,
AdMob, CocoaPods) lives on the [`master`](../../tree/master) branch.

### Roadmap

- [x] Convert project to SwiftUI
- [x] New design
- [x] iPad support
- [ ] macOS support
- [ ] watchOS support
- [ ] Configure the Game Center leaderboards in App Store Connect

### Screenshots

<img src="https://raw.githubusercontent.com/bystritskiy/HardcoreTap/master/Media/01.png" width="250"> <img src="https://raw.githubusercontent.com/bystritskiy/HardcoreTap/master/Media/02.png" width="250"> <img src="https://raw.githubusercontent.com/bystritskiy/HardcoreTap/master/Media/03.png" width="250">
