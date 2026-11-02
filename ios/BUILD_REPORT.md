# Pufi iOS build and verification report

Date: 2026-11-02. Branch: `ios-build`; base: `main`.

**Status: simulator verification passed; ready for review.**
Rebased `ios-build` onto `main` at `5d7fd89`, including the restored HTML
scaffold/UTF-8 metadata (`1d1597d`) and the web fixes from findings 1–6
(`5d7fd89`). No web files were edited on this branch.

## Changes, by file

- `PufiStars/Services/SpeechService.swift`: isolate speech state on the main actor for the current SDK's Sendable delegate; stop paused utterances too.
- `PufiStars/Services/PurchaseService.swift`: isolate purchase state on the main actor; update entitlement state on the main queue; select the configured `unlock_all` product rather than whichever package happens to be first.
- `PufiStars/Services/RecognitionService.swift`: use the current Bluetooth option; clean up the engine/tap after startup failure or recognition completion; ignore callbacks from cancelled recognition sessions.
- `PufiStars/Services/RecorderService.swift`: check recording/playback startup results, restore playback audio on recording failure, and resolve interrupted/failed playback callbacks so JS Promises do not remain pending.
- `PufiStars/Web/Bridge.swift`: isolate bridge state on the main actor and stop competing recording/recognition before switching audio operations. Command names, arguments, Promise results and event names are unchanged.
- `PufiStars/Web/GameWebView.swift`: install a WebKit rule blocking HTTP(S) resources before loading the bundled game, including any external stylesheets. External navigation remains blocked. This does not block native StoreKit/RevenueCat or Apple speech services.
- `PufiStars/UI/ParentalGateView.swift`: always provide four positive answer choices.
- `project.yml`: add hosted bridge integration and UI test targets to the reproducible XcodeGen scheme.
- `PufiStarsTests/BridgeTests.swift`: report document encoding and helper availability on initialization timeout; exercise the real bundled game and WKWebView bridge: language/voice selection, native speech word events, Debug IAP, backup storage, gate resolution, blocked external navigation and absent recording playback.
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

## Verification on repaired main `5d7fd89`

Both complete simulator suites passed against web baseline `5d7fd89`, copied
into the app by `sync_web.sh`:

| Simulator | Result |
| --- | --- |
| iPad (A16), iOS 26.5 | PASS — 7 tests, zero failures. |
| iPhone 17 Pro, iOS 26.5 | PASS — 7 tests, zero failures. |

Both runs completed with `TEST SUCCEEDED` and built/ran the app. Existing tests
and assertions are unchanged. The UTF-8/initialization blocker is resolved;
there are no remaining simulator-suite failures blocking review. Layout
screenshots confirm readable text and emoji with the embedded local font.

Result bundles (local, not committed):

- `/tmp/pufi-derived/Logs/Test/Test-PufiStars-2026.11.02_13-20-00-+0100.xcresult`
- `/tmp/pufi-derived/Logs/Test/Test-PufiStars-2026.11.02_13-21-29-+0100.xcresult`

Physical-device and purchase checks below remain outside simulator coverage.

## Simulator checklist

| Check | Result and scope |
| --- | --- |
| iPad simulator build | PASS. |
| iPhone simulator build | PASS. |
| Offline bundled game | PASS: file-based page loads with remote HTTP(S) web resources blocked; host networking was not switched off. |
| iPad portrait/landscape and iPhone | PASS: the game fills the screen in both orientations; iPhone menus scroll to lower cards. Full-screen screenshots reviewed; app-only XCTest screenshots during rotation were misleading. |
| Language switch and native voice | PASS: UI switch to English, German `voiceInfo` returns a named German voice, real native speech emits word events. Enhanced/Premium installed-voice quality needs a device. |
| Stories → microphone and permission text | PASS in the original run: story read-aloud opens; fresh microphone and speech permission explanations were verified. Permissions remain granted for these reruns, so fresh prompts are not re-tested. |
| Words turn green from live reading | NOT TESTED for live accuracy: no child speech or fabricated recognition events were supplied. Verify green-word tracking on a physical device. |
| Parental gate | PASS: cancel does not open Parents; correct multiplication opens it. |
| Praise record/play/delete | PASS on both simulators through the actual Parents UI. Audio fidelity requires a physical device. |
| Recorded praise after a correct answer | NOT TESTED end-to-end: playback works, but the web success hook is randomized (45%, with a 15-second cooldown). Verify an audible success on device. |
| Progress after app kill/relaunch | PASS for a saved language setting; `store.set`/`store.get` and a new ProgressStore instance also round-trip the backup. Full scores/streaks and WebKit storage eviction recovery were not simulated. |
| IAP without RevenueCat key | PASS: Debug status/buy/restore return unlocked, price returns empty, and no unconfigured SDK access crashes. |
| Real purchases and restore | NOT TESTABLE without RevenueCat/App Store configuration and sandbox account. Release remains locked without a key. |
| Romanian on-device recognition | NOT TESTABLE: verify `asr.available` on Hory's actual device and locale installation. |
| External links/resources | PASS for blocked HTTPS navigation; all HTTP(S) WebKit subresources are blocked by the installed content rule. |
| Physical-device signing | NOT TESTED: Hory must choose his Apple Developer Team in Signing & Capabilities before a device build. |

## Upstream web fixes reviewed

The previous blocking HTML/UTF-8 regression is fixed by `1d1597d`. Commit
`5d7fd89` also addresses the first six report findings:

1. Browser speech cancellation now calls native `stopSpeak` too.
2. Karaoke offsets use the transformed spoken text.
3. Cancelled karaoke no longer marks remaining words as read.
4. Parent recording controls stop/refresh after the native duration limit or panel removal, and confirm the slot exists.
5. Backup restoration merges missing keys; saving avoids empty snapshots and runs after localStorage writes, on hiding and on page exit.
6. Baloo 2 is embedded as a local data font; the remote Google Fonts request is removed.

These fixes were reviewed in source. The simulator suites exercise the overall
native/web flows; they do not separately prove every corrected edge case,
including karaoke offset accuracy, automatic 12-second recording stop and
storage-eviction recovery.

Remaining product decision: `window.__premium` still controls only purchase-panel
messaging. Define which game content `unlock_all` should unlock before adding a
paywall. This is independent of the resolved encoding blocker and Debug IAP tests.

## Open questions for Hory

- Select your Apple Developer Team before a real-device build; provide the intended 1024px app icon (the current catalog has no image).
- Configure the RevenueCat public iOS key and the current offering containing `unlock_all`; verify App Store sandbox buy/restore before release.
- Should Romanian recognition fall back to Apple's servers when on-device recognition is unavailable, as currently implemented? Confirm the intended privacy disclosure and behavior.
- Confirm the content that should be premium.
- Complete a device acceptance pass for live green-word recognition, audio quality, audible praise after success, all progress types, and real purchases. Simulator passes do not replace those checks.
