# Task: free launch until 15 December 2026, then "Unlock all" — early users keep everything

Read `AGENTS.md` first (only change `ios/`, branch + PR, no merge).

## Product rule (decided by Hory)
- Until **15 December 2026, 00:00 Europe/Zurich** (= `2026-12-14T23:00:00Z`) everything is unlocked for everyone.
- Anyone whose **original download of the app happened before that moment** keeps everything unlocked forever (also after updates, reinstalls, new devices with the same Apple ID).
- After the cutoff, new users get the free part only, until they buy the non-consumable `unlock_all` (RevenueCat entitlement `premium`).

## What the web game already does (do not change it)
- On start and every time the app comes back to the foreground it calls `native.call('iap.status')`.
  `true` = show everything; `false` = locked cards get a 🔒 and open a paywall (parental gate → `iap.price`, `iap.buy`, `iap.restore`).
- The free/locked split lives in the web game; native only answers "is the full version unlocked".

## Native work
1. Add `EntitlementPolicy` (pure Swift, unit-testable) that returns unlocked if ANY is true:
   - `now < cutoff`
   - `originalPurchaseDate < cutoff`, from StoreKit 2 `AppTransaction.shared` (verified). Use `originalPurchaseDate`, not `originalAppVersion`.
   - RevenueCat entitlement `premium` is active.
2. Once the user qualifies by original purchase date, store a "grandfathered" flag (Keychain preferred, so it survives reinstall on the same device), so it also works offline later.
3. Offline / AppTransaction error / no RevenueCat key:
   - before the cutoff → unlocked;
   - after it → use the stored flag or RevenueCat's cached customer info. Never crash and never block the game from loading.
4. `iap.status`, `iap.buy`, `iap.restore` return the policy result (a purchase or restore that activates `premium` → `true`).
   In **Debug** keep the current behaviour (everything unlocked) unless a test override is set.
5. Test overrides, Debug only: launch arguments `-PufiNow <ISO date>` and `-PufiOriginalPurchase <ISO date>` (or `none`). These let us check the four cases in the simulator:
   - before the cutoff;
   - after the cutoff for an early user;
   - after the cutoff for a new user;
   - after the cutoff for a new user who bought.
6. Unit tests for `EntitlementPolicy` covering those cases plus offline fallbacks; a UI test that a new user after the cutoff sees the 🔒 on "Lumea numerelor → Vecinii" and the paywall opens.
7. Small fix from the last review: in `GameWebView`, if compiling the offline content rule fails, still load the game (log the error) instead of showing an error page.

## Report
Same format as before (`ios/BUILD_REPORT.md` + PR description). Also list what Hory must do in App Store Connect:
- create the non-consumable `unlock_all`;
- enable Family Sharing for it if he wants;
- set the price;
- submit it together with this app version;
- RevenueCat: entitlement `premium` + offering;
- public SDK key in `PurchaseService.swift`.
