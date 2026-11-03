# Task 04 — diagnostic microfon pe iPad

Data: 3 noiembrie 2026. Branch: `ios/microfon-diagnostic`. Bază web: `3a9c561`.
Sarcină: `ios/tasks/04-microfon-ipad.md`, inclusiv secțiunea 1b.

## Cauza și modificările

Cauza exactă a eșecului inițial de pe iPad nu a fost reprodusă: pe dispozitivul
conectat permisiunile sunt deja acceptate, iar noua versiune pornește motorul
în română și engleză. Versiunea anterioară pierdea motivul oricărui eșec,
întorcând numai `false`. Au fost corectate și riscurile identificate în pornirea audio.

- `RecognitionService.swift`: starea permisiunilor fără dialoguri; motivele exacte
  cerute de sarcină; activarea sesiunii înainte de citirea formatului, o încercare
  cu `inputFormat` dacă `outputFormat` este invalid și refuzul formatului invalid
  înainte de `installTap`; callback audio fără acces la MainActor; o singură
  reluare cu rețeaua permisă dacă recunoașterea locală eșuează în primele 3 secunde
  fără text. `stop()` elimină tap-ul și restabilește `.playback` după ascultare.
- `Bridge.swift`: `asr.start` păstrează `true` la succes, întoarce `{ok:false,reason}`
  și `NSLog("Pufi ASR: …")` la eșec; `asr.perm` și `openSettings`; oprirea ASR
  înainte de TTS; cererile de autorizare întârziate nu mai pot reporni o ascultare
  anulată. Erorile apărute după pornire sunt logate și însoțesc `asr.end`.
- `RecorderService.swift`, `GameWebView.swift`: izolarea explicită a callback-urilor
  de autorizare și navigare, pentru verificarea strictă a concurenței. Blocarea
  navigării externe rămâne verificată de testul existent.
- `BridgeTests.swift`, `RecognitionServiceTests.swift`: teste pentru permisiuni,
  refuz, format, reluare și pornirea reală urmată de TTS pe dispozitiv.
- `README.md`: contractul comenzilor și comportamentul reluării prin rețea.

Descrierile `NSMicrophoneUsageDescription` și `NSSpeechRecognitionUsageDescription`
există în configurație și în aplicația compilată. Bundle ID păstrat:
`com.horace.pufistars`. Niciun fișier web nu a fost modificat.

## Rezultate confirmate

| Verificare | Rezultat |
|---|---|
| Build iPad (A16), iOS 26.5 Simulator | PASS |
| Build iPhone 17 Pro, iOS 26.5 Simulator | PASS; și `SWIFT_STRICT_CONCURRENCY=complete`, fără avertismente de concurență în aplicație |
| Suită nativă iPad Simulator | 18 teste, 0 eșecuri, 2 omise explicit: refuzul nu era setat, microfonul fizic lipsește |
| Suită nativă iPhone Simulator cu microfon refuzat în sistem | 18 teste, 0 eșecuri, 1 omis explicit: microfonul fizic lipsește |
| Refuz microfon în simulator | `{ok:false,reason:"mic-denied"}`; log `Pufi ASR: mic-denied`; starea inițială a permisiunii a fost restabilită după probă |
| Build, semnare și instalare pe iPad HR, iPad Pro 11-inch generația 4, iPadOS 26.6.1 | PASS; echipa deja configurată local, fără ștergerea aplicației/progresului |
| `asr.perm` pe iPad fizic | PASS: `speech=authorized`, `mic=granted`; interogarea nu a schimbat starea |
| `asr.available` pe iPad fizic | `available=true`, `onDevice=true` atât pentru `ro-RO`, cât și pentru `en-GB` |
| `asr.start` pe iPad fizic, `words:[]`, română și engleză | PASS: `true`; 3 secunde de ascultare în fiecare limbă, fără erori sau reluare prin rețea |
| TTS în timpul ascultării pe iPad fizic | PASS: oprire ASR înainte de TTS, sesiunea finală `.playback` |
| `openSettings` pe iPad fizic | PASS: răspuns `true` la deschiderea URL-ului oficial al paginii aplicației |

## Probe cu voce reală pe iPad, împreună cu Hory

După autorizarea automatizării, o sesiune Xcode/runner a rămas blocată la
lansare. Au fost oprite sesiunea de depanare și serviciul de test, apoi Pufi a
fost redeschis normal din iconiță. Hory a confirmat că jocul se afișează normal;
ecranul negru „Automation Running” aparținea sesiunii de test. Nu a fost nevoie
de modificarea jocului pentru a reveni la lansarea normală.

Testele vocale de mai jos sunt probe manuale pe iPad-ul fizic, confirmate de
Hory în această sesiune; nu sunt prezentate drept teste UI automate:

| Probă, cu permisiuni acceptate | Rezultat |
|---|---|
| Română → Povești → „Pufi și mingea” → „Citesc cu voce” | PASS: textul auzit apare și rama avansează pe cuvinte |
| Română → „Poveste nouă” → „Dictează” | PASS: textul rostit apare în câmp |
| English → Stories → „Pufi and the Ball” → „I read aloud” | PASS: textul auzit apare și cuvintele avansează |
| English → „New story” → „Dictate” | PASS: textul rostit apare în câmp |

Proba cu microfonul refuzat și revenirea prin Setări sunt în curs.
Starea „Activează dictarea” din Setări → General → Tastatură urmează să fie notată.

Probele native inițiale au fost fără voce (`partialCount=0`); cele patru probe
manuale de mai sus confirmă acum transcrierea și comportamentul în joc.
Reluarea prin rețea nu a fost necesară în proba nativă și nu este declarată
verificată pe iPad; condițiile/limita sunt acoperite de teste. Când este folosită,
audio poate fi prelucrat de serviciul Apple; logul consemnează reluarea, fără
textul copilului.

Automatizarea UI rămâne limitată de instalarea/lansarea runner-ului: Xcode a
raportat și `Developer App Certificate is not trusted`, deși Pufi și runner-ul
folosesc același certificat și Hory a confirmat autorizarea lui. Device Hub a
clarificat separat că partajarea ecranului necesită iPadOS 27 sau mai nou;
iPad-ul fizic rulează 26.6.1. Aceste limitări nu au fost confundate cu rezultatele
probelor vocale efectuate direct în Pufi.

## Observație pentru partea web (fără modificare în acest PR)

În `index.html`, `window.__micEnsure` apelează întotdeauna
`window.__micFail('speech-denied')` când detectează orice permisiune refuzată,
inclusiv `mic=denied` și `speech=restricted`. Pentru diagnosticul exact, Claude
ar trebui să păstreze motivul real (`mic-denied` / `speech-restricted` /
`speech-denied`). Bridge-ul întoarce separat stările corecte și codurile corecte.

---

# Pufi — free-launch entitlement implementation report

Date: 2026-11-02. Branch: `codex/free-launch-entitlements`; tested web base: `main` at `59a4e71` (including Pufi’s Island).
Task: `ios/tasks/01-free-until-dec-15.md`.

The final required publication rebase also included `1689413` (the separate
Soroban Arena Anzan web module). That diff was reviewed and the 12 unit/bridge
tests rerun on both devices, including bundled-page loading. The complete
19-test suites below were run against `59a4e71`; Arena gameplay was not tested.

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
