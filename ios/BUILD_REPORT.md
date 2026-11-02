# Pufi — free-launch entitlement implementation report

Date: 2026-11-02. Branch: `codex/free-launch-entitlements`; tested web base: `main` at `59a4e71` (including Pufi’s Island).
Task: `ios/tasks/01-free-until-dec-15.md`.

The app now grants full access before **15 December 2026, 00:00 Europe/Zurich**
(`2026-12-14T23:00:00Z`), permanently to verified early users, or while RevenueCat
entitlement `premium` is active. The strict comparison excludes an original
purchase exactly at the cutoff. Eligibility is based on Apple's verified
`AppTransaction.shared.originalPurchaseDate`, never a local installation date
or app version. [Apple AppTransaction](https://developer.apple.com/documentation/storekit/apptransaction),
[originalPurchaseDate](https://developer.apple.com/documentation/storekit/apptransaction/originalpurchasedate).

Hory confirmed **`com.horace.pufistars`** as the app's bundle identifier. The
project generator and documentation now retain that ID. The fox/star AppIcon
from PR #2 is included as a tracked 1024×1024 opaque asset, so regenerating the
Xcode project does not remove it. Only repository files inside `ios/` changed;
no generated WebContent, Xcode project, DerivedData, or secrets are committed.

## Changes, file by file

- `PufiStars/Services/EntitlementPolicy.swift`: pure access rule and Debug-only, isolated launch overrides.
- `PufiStars/Services/GrandfatheredStore.swift`: persistent, app-scoped Keychain flag for verified early users, available after first device unlock. New devices recover eligibility from Apple's transaction rather than a device-local date.
- `PufiStars/Services/PurchaseService.swift`: combine the policy with verified StoreKit evidence and RevenueCat's cached/current CustomerInfo; bound status waits to three seconds; coalesce StoreKit requests; preserve known data on fetch errors. `iap.status`, `iap.buy`, and `iap.restore` return the policy result. Already-entitled users are not sent into another purchase.
- `PufiStars/Web/GameWebView.swift`: log content-rule compilation failure and still load the bundled game. External-navigation blocking remains in place; the content rule is installed when compilation succeeds.
- `PufiStarsTests/EntitlementPolicyTests.swift`: cutoff/time-zone boundaries, all four scenarios, missing StoreKit/offline evidence, and Keychain persistence across new store instances.
- `PufiStarsUITests/GameUITests.swift`: scroll the first recording row into the visible area before tapping on tall home pages.
- `PufiStarsUITests/EntitlementUITests.swift`: all four Debug scenarios; new users after the cutoff see the lock on “Lumea numerelor → Strada vecinilor,” enter the paywall, pass the native parental gate, and reach buy/restore controls.
- `project.yml`, `README.md`, `CODEX_PROMPT.md`: retain the confirmed bundle ID through XcodeGen; document the policy and simulator overrides.
- `PufiStars/Assets.xcassets/AppIcon.appiconset/Contents.json`, `PufiIcon-1024.png`, `Design/AppIcon-prompt.txt`: retain the generated fox/star icon and its original prompt in Git.
- `BUILD_REPORT.md`: current implementation, verification, limitations, and App Store setup.

## Offline and Debug behavior

Production uses the Keychain flag and RevenueCat CustomerInfo cache when store
lookups fail. A successful verified early purchase sets the permanent flag; test
overrides never read or write it. A StoreKit request that stalls cannot keep the
JS status Promise waiting beyond the scheduled three-second fallback. Late
results are retained for subsequent status/foreground checks. RevenueCat is only
accessed after configuration; without a key the policy still works and the game
loads. No error clears an existing grandfathered flag.
[RevenueCat cache behavior](https://www.revenuecat.com/docs/test-and-launch/debugging/caching).

Debug defaults to fully unlocked. Supplying any test flag activates an isolated
simulation that bypasses real StoreKit, RevenueCat, purchases, and persistent
eligibility. All override code is excluded from Release:

| Scenario | Debug launch arguments |
| --- | --- |
| Before cutoff | `-PufiNow 2026-12-14T22:59:59Z -PufiOriginalPurchase none` |
| Early user after cutoff | `-PufiNow 2026-12-15T00:00:00Z -PufiOriginalPurchase 2026-12-14T22:59:59Z` |
| New user after cutoff | `-PufiNow 2026-12-15T00:00:00Z -PufiOriginalPurchase none` |
| New paid user after cutoff | `-PufiNow 2026-12-15T00:00:00Z -PufiOriginalPurchase none -PufiPremium true` |

The paid scenario simulates an active entitlement; it does not perform a real
purchase. Unit tests cover cached/offline access, not live server outages.

## Verification

Environment: Xcode 27.0 (27A266a), XcodeGen 2.46.0, RevenueCat 5.101.0;
iPad (A16) and iPhone 17 Pro, iOS 26.5. Build output is under `/tmp` because
Finder metadata in the synced Documents folder can interfere with signing.

- iPhone full suite: **PASS — 19 tests**, zero failures after simulator restart; rotation assertions unchanged.
- iPad full suite: **PASS — 19 tests**, zero failures after simulator restart; rotation assertions unchanged.
- Release build: **PASS**; installed and launched on iPad with the confirmed bundle ID and compiled AppIcon.
- Release Debug-override exclusion: **PASS**; override flag strings absent from the Release executable. Launching Release with test arguments still loads the real policy path.
- Policy boundaries/time zone: **PASS**.
- Four access scenarios and parental paywall: **PASS on iPad and iPhone**.
- Keychain flag round trip/new instance: **PASS**.
- Existing voice, language, persistence, recording, and gate regression tests: run as part of each complete suite.
- Offline-rule compilation-error branch: fixed and source-reviewed; not forced through an injected WebKit error.
- Real purchases, sandbox restore, verified early-user recovery after uninstall or on another device: **NOT TESTABLE here** without App Store/RevenueCat configuration. These remain device acceptance checks.
- Romanian live recognition, audio quality and audible randomized praise: **NOT TESTED** in this task.

The first paywall test used Romanian purchase labels, but the current web page
uses English fallback labels; the final test verifies the actual buy/restore
controls. Earlier simulator runs ignored a requested orientation change; the
rotation assertion was kept intact and each affected simulator restarted for a full rerun.
The new Island banner made the home page taller. On iPhone the existing
recording test tapped its first recording row beneath the status bar; an exported
UI hierarchy confirmed the button at y=24, above the web view’s visible area.
The test now scrolls the row below the status bar before tapping; all recording,
playback and deletion assertions remain. The microphone permission was explicitly
granted in the simulator during diagnosis; a new permission prompt was not tested.
The app-source concurrency warning found during compilation was corrected.
Xcode's no-AppIntents metadata notice and simulator audio/QoS diagnostics remain.

Final local result bundles (not committed):

- iPad: `/tmp/pufi-derived/Logs/Test/Test-PufiStars-2026.11.02_17-31-19-+0100.xcresult`
- iPhone: `/tmp/pufi-island-iphone/Logs/Test/Test-PufiStars-2026.11.02_17-31-12-+0100.xcresult`

Reproduce (repeat with the iPhone simulator destination):

```sh
cd ios
./sync_web.sh
xcodegen
xcodebuild -project PufiStars.xcodeproj -scheme PufiStars \
  -destination 'platform=iOS Simulator,name=iPad (A16),OS=26.5' \
  -derivedDataPath /tmp/pufi-derived \
  -parallel-testing-enabled NO -collect-test-diagnostics never test
```

## Web follow-up (index.html remains unchanged)

The paywall's `NT()` helper reads `window.L10N.nt`, while the Romanian native
purchase labels are defined in a private `NT` object in the integration IIFE.
After the parental gate, the current Romanian paywall therefore displays
“Unlock” and “Restore” and no localized purchase heading. Publish the native
translations through `L10N.nt` or a shared localized getter and use it in
`paywall().buy()`. The lock, parental gate, and native commands work; localization
is a separate web follow-up.

## Required setup by Hory before release

1. Use the App Store Connect app record matching **`com.horace.pufistars`** (create it only if none exists) and select Hory's Apple Developer Team in Xcode for physical-device signing. Reuse the existing record for updates; no Team ID was invented.
2. Create the **non-consumable** `unlock_all` in that app's In-App Purchases. [Apple setup](https://developer.apple.com/help/app-store-connect/configure-in-app-purchase-settings/overview-for-configuring-in-app-purchases/).
3. Enable **Family Sharing** for the product if desired. [Apple Family Sharing](https://developer.apple.com/documentation/storekit/supporting-family-sharing-in-your-app).
4. Set the product's price, localization and review information.
5. Submit the first IAP together with this app version for App Review.
6. In RevenueCat, connect this app/product, create entitlement **`premium`**, attach `unlock_all`, and place its package in the **current offering**.
7. Set this app's public iOS SDK key (`appl_…`) in `PurchaseService.swift`; the placeholder is unchanged. [RevenueCat SDK configuration](https://www.revenuecat.com/docs/getting-started/configuring-sdk).
8. Test StoreKit/RevenueCat purchase, cancellation, restore, offline relaunch, and original-download eligibility on real devices/Apple IDs before release.

An app's bundle ID is its store identity and cannot be changed on an existing
uploaded app record. The confirmed original ID must match the record used for
updates and IAP. [Apple bundle ID guidance](https://developer.apple.com/documentation/bundleresources/information-property-list/cfbundleidentifier).
