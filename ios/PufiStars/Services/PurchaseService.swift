import Foundation
import RevenueCat

/// O singură cumpărare: „Deblochează tot” (non-consumable), prin RevenueCat.
/// În RevenueCat: entitlement `premium`, offering curent cu un pachet care conține produsul `unlock_all`.
@MainActor
final class PurchaseService {
    static let shared = PurchaseService()

    /// Pune aici cheia publică iOS din RevenueCat (începe cu `appl_`).
    private let apiKey = "appl_REPLACE_ME"
    private let entitlement = "premium"
    private(set) var isPremium = false
    private var configured = false

    func configure() {
        guard !apiKey.contains("REPLACE") else {
            #if DEBUG
            isPremium = true   // în dezvoltare, fără cheie: totul deblocat
            #endif
            return
        }
        Purchases.logLevel = .warn
        Purchases.configure(withAPIKey: apiKey)
        configured = true
        refresh { _ in }
    }

    func refresh(_ done: @escaping (Bool) -> Void) {
        guard configured else { done(isPremium); return }
        Purchases.shared.getCustomerInfo { [weak self] info, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isPremium = info?.entitlements[self.entitlement]?.isActive == true
                done(self.isPremium)
            }
        }
    }

    func price(_ done: @escaping (String?) -> Void) {
        guard configured else { done(nil); return }
        Purchases.shared.getOfferings { offerings, _ in
            let p = offerings?.current?.availablePackages.first(where: { $0.storeProduct.productIdentifier == "unlock_all" })?.storeProduct.localizedPriceString
            DispatchQueue.main.async { done(p) }
        }
    }

    func buy(_ done: @escaping (Bool) -> Void) {
        guard configured else { done(isPremium); return }
        Purchases.shared.getOfferings { [weak self] offerings, _ in
            guard let self, let pkg = offerings?.current?.availablePackages.first(where: { $0.storeProduct.productIdentifier == "unlock_all" }) else {
                DispatchQueue.main.async { done(false) }; return
            }
            Purchases.shared.purchase(package: pkg) { _, info, _, _ in
                DispatchQueue.main.async {
                    self.isPremium = info?.entitlements[self.entitlement]?.isActive == true
                    done(self.isPremium)
                }
            }
        }
    }

    func restore(_ done: @escaping (Bool) -> Void) {
        guard configured else { done(isPremium); return }
        Purchases.shared.restorePurchases { [weak self] info, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isPremium = info?.entitlements[self.entitlement]?.isActive == true
                done(self.isPremium)
            }
        }
    }
}

/// Copie a progresului jocului (localStorage), ca să nu se piardă dacă iOS curăță datele web.
final class ProgressStore {
    private let key = "pufi.localStorage.snapshot"
    func load() -> String? { UserDefaults.standard.string(forKey: key) }
    func save(_ snapshot: String) {
        guard !snapshot.isEmpty else { return }
        UserDefaults.standard.set(snapshot, forKey: key)
    }
}
