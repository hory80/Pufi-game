# Pufi iOS build and verification report

Date: 2026-11-02. Branch: `ios-build`; base: `main`.

## Changes, by file

- `PufiStars/Services/SpeechService.swift`: isolate speech state on the main actor for the current SDK's Sendable delegate; stop paused utterances too.
- `PufiStars/Services/PurchaseService.swift`: isolate purchase state on the main actor; update entitlement state on the main queue; select the configured `unlock_all` product rather than whichever package happens to be first.
- `PufiStars/Services/RecognitionService.swift`: use the current Bluetooth option; clean up the engine/tap after startup failure or recognition completion; ignore callbacks from cancelled recognition sessions.
- `PufiStars/Services/RecorderService.swift`: check recording/playback startup results, restore playback audio on recording failure, and resolve interrupted/failed playback callbacks so JS Promises do not remain pending.
- `PufiStars/Web/Bridge.swift`: isolate bridge state on the main actor and stop competing recording/recognition before switching audio operations. Command names, arguments, Promise results and event names are unchanged.
- `PufiStars/Web/GameWebView.swift`: install a WebKit rule blocking HTTP(S) resources before loading the bundled game, including its external Google Fonts stylesheet. External navigation remains blocked. This does not block native StoreKit/RevenueCat or Apple speech services.
- `PufiStars/UI/ParentalGateView.swift`: always provide four positive answer choices.
- `project.yml`: add hosted bridge integration and UI test targets to the reproducible XcodeGen scheme.
- `PufiStarsTests/BridgeTests.swift`: exercise the real bundled game and WKWebView bridge: language/voice selection, native speech word events, Debug IAP, backup storage, gate resolution, blocked external navigation and absent recording playback.
- `PufiStarsUITests/GameUITests.swift`: verify orientations, language persistence across termination/relaunch, cancelled/successful parental gate, recording/play/delete, and entry into story read-aloud with system permissions. Save layout screenshots in test results.
- `README.md`: preserve the required bundle ID; document simulator tests and the temporary DerivedData workaround for iCloud metadata.
- `BUILD_REPORT.md`: this report.

No repository files outside `ios/` were edited. No generated WebContent, Xcode project, DerivedData or secrets are committed. Bundle ID `ch.hory.pufistars`, product `unlock_all` and entitlement `premium` are unchanged.

## Environment and commands

- Xcode 27.0 (27A266a), XcodeGen 2.46.0; RevenueCat resolved to 5.101.0.
- iPad (A16), iOS 26.5; iPhone 17 Pro, iOS 26.5.
- Ran `./sync_web.sh`, `xcodegen`, simulator builds and tests.
- The initial iPad build succeeded with concurrency/deprecation warnings. Those app-source warnings are fixed. Xcode's informational “Metadata extraction skipped, no AppIntents.framework dependency found” remains; the app has no App Intents.
- A build under the iCloud-synced Documents folder acquired Finder metadata that prevented simulator code signing. Final builds use `/tmp/pufi-derived`. No physical-device signing team was invented or selected.
- Simulator tests also log Apple voice-database fallback, audio/QoS and WebKit teardown diagnostics. These are distinguished from compiler warnings and test failures.

Reproduce (change the destination to the installed iPhone to repeat):

```sh
cd ios
./sync_web.sh
xcodegen
xcodebuild -project PufiStars.xcodeproj -scheme PufiStars \
  -destination 'platform=iOS Simulator,name=iPad (A16),OS=26.5' \
  -derivedDataPath /tmp/pufi-derived \
  -parallel-testing-enabled NO -collect-test-diagnostics never test
```

## Final results

Both complete simulator suites passed: **7/7 tests on iPad (A16)** and
**7/7 tests on iPhone 17 Pro**, with zero test failures. The app builds for both.
Final result bundles (local, not committed):

- `/tmp/pufi-derived/Logs/Test/Test-PufiStars-2026.11.02_12-59-38-+0100.xcresult`
- `/tmp/pufi-derived/Logs/Test/Test-PufiStars-2026.11.02_13-01-01-+0100.xcresult`

Earlier test failures were corrected accessibility queries (switches versus buttons,
scrolling to offscreen controls, and Apple's speech-permission disclosure prefix),
plus the Documents-folder signing metadata issue. The final suites pass without
suppressing functional assertions. Screenshots use full-screen capture to avoid
an XCTest app-screenshot rotation artifact.

## Checklist

| Check | Result and scope |
| --- | --- |
| iPad simulator build | PASS. |
| iPhone simulator build | PASS. |
| Offline bundled game | PASS: file-based page loads with remote HTTP(S) web resources blocked; host networking was not switched off. |
| iPad portrait/landscape and iPhone | PASS: the game fills the screen in both orientations; iPhone menus scroll to lower cards. Full-screen screenshots reviewed; app-only XCTest screenshots during rotation were misleading. |
| Language switch and native voice | PASS: UI switch to English, German `voiceInfo` returns a named German voice, real native speech emits word events. Enhanced/Premium installed-voice quality needs a device. |
| Stories → microphone and permission text | PASS: story read-aloud opens on both simulators. Fresh microphone prompt text verified; the fresh iPhone speech prompt contains the exact project explanation after Apple’s standard disclosure. |
| Words turn green from live reading | NOT TESTABLE in this run: iPad recognition reported unavailable; iPhone entered Listening, but no child speech or fabricated recognition events were supplied. |
| Parental gate | PASS: cancel does not open Parents; correct multiplication opens it. |
| Praise record/play/delete | PASS on both simulators through the actual Parents UI. Audio fidelity requires a physical device. |
| Recorded praise after a correct answer | NOT TESTED end-to-end: playback works, but the web success hook is randomized (45%, with a 15-second cooldown). Verify an audible success on device. |
| Progress after app kill/relaunch | PASS for a saved language setting; `store.set`/`store.get` and a new ProgressStore instance also round-trip the backup. Full scores/streaks and WebKit storage eviction recovery were not simulated. |
| IAP without RevenueCat key | PASS: Debug status/buy/restore return unlocked, price returns empty, and no unconfigured SDK access crashes. |
| Real purchases and restore | NOT TESTABLE without RevenueCat/App Store configuration and sandbox account. Release remains locked without a key. |
| Romanian on-device recognition | NOT TESTABLE: verify `asr.available` on Hory's actual device and locale installation. |
| External links/resources | PASS for blocked HTTPS navigation; all HTTP(S) WebKit subresources are blocked by the installed content rule. |
| Physical-device signing | NOT TESTED: Hory must choose his Apple Developer Team in Signing & Capabilities before a device build. |

## Web-game changes to hand to the web maintainer

These findings are from source inspection; `index.html` was left unchanged.

1. `openCard`, `openStory`, reading Back handlers and other navigation paths call browser `speechSynthesis.cancel()`. Native `AVSpeechSynthesizer` speech is separate and can continue after navigation. Route cancellation through `native.call('stopSpeak')` as well when the bridge exists.
2. `window.__nativeKaraoke` calculates word offsets against the original text, then sends text transformed by `fixSpeech` and the language-specific Pufi replacement. A length-changing replacement shifts later native UTF-16 word offsets. Derive offsets from exactly the spoken text, or preserve a mapping back to displayed words.
3. `window.__nativeKaraoke` marks every word as read when `speak` resolves, even when native returns `false` for cancellation. Check the completion value and cancellation token before marking the remainder read.
4. `window.__parentsExtra`: native recordings stop after 12 seconds, but the web button remains in the recording state until tapped. Add a matching UI timeout, refresh the actual recording list, and show success only if the slot exists. Closing Parents should call `rec.stop`.
5. `snap()` / `store.get` restore block: `localStorage.length < 2` is a heuristic, not a check for missing game progress. A partially populated store can prevent recovery; one-key snapshots are never restored. Validate known progress keys, merge only missing values, and avoid overwriting a valid backup with an empty snapshot. A force-kill before the 20-second timer can also leave the native backup behind localStorage; save on meaningful progress changes.
6. The document `<head>` loads Google Fonts over HTTPS. The iOS wrapper now blocks it and uses fallback fonts. Bundle a licensed local font if the exact web typography is required offline.
7. `window.__premium` is only referenced by the purchase-panel display; no game-content access checks use it. Define which content the non-consumable should unlock before implementing a paywall.

## Open questions for Hory

- Select your Apple Developer Team before a real-device build; provide the intended 1024px app icon (the current catalog has no image).
- Configure the RevenueCat public iOS key and the current offering containing `unlock_all`; verify App Store sandbox buy/restore before release.
- Should Romanian recognition fall back to Apple's servers when on-device recognition is unavailable, as currently implemented? Confirm the intended privacy disclosure and behavior.
- Confirm the content that should be premium, and assign the web-side corrections above to the web maintainer.
- Complete a device acceptance pass for live green-word recognition, audio quality, audible praise after success, all progress types, and real purchases. Simulator passes do not replace those checks.
