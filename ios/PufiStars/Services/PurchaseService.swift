import Foundation
import RevenueCat
import StoreKit

/// Acces gratuit la lansare, păstrat pentru primii utilizatori; apoi `unlock_all`.
@MainActor
final class PurchaseService {
    static let shared = PurchaseService()

    /// Cheia publică iOS RevenueCat (appl_…), pentru aceeași aplicație din App Store Connect.
    private let apiKey = "appl_REPLACE_ME"
    private let entitlement = "premium"
    private let grandfatheredStore = GrandfatheredStore()
    private var configured = false
    private var revenueCatPremium = false
    private var originalPurchaseDate: Date?
    private var transactionTask: Task<Void, Never>?
    private var transactionWaiters: [UUID: () -> Void] = [:]
    private(set) var isPremium = false

    #if DEBUG
    private let testOverrides = EntitlementTestOverrides(arguments: ProcessInfo.processInfo.arguments)
    #endif

    func configure() {
        guard !configured else { return }
        #if DEBUG
        // În modul de test nu contactăm magazinele și nu modificăm Keychain-ul real.
        if testOverrides != nil { isPremium = access(); return }
        #endif
        if !apiKey.contains("REPLACE") && !apiKey.isEmpty {
            Purchases.logLevel = .warn
            Purchases.configure(withAPIKey: apiKey)
            configured = true
            updatePremium(Purchases.shared.cachedCustomerInfo)
        }
        isPremium = access()
        refresh { _ in }
    }

    private var isDebugSimulation: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    private func access() -> Bool {
        #if DEBUG
        if let testOverrides { return testOverrides.isUnlocked }
        return true
        #else
        return EntitlementPolicy.isUnlocked(now: Date(), originalPurchaseDate: originalPurchaseDate,
                                            grandfathered: grandfatheredStore.isGrandfathered,
                                            premium: revenueCatPremium)
        #endif
    }

    private func updatePremium(_ info: CustomerInfo?) {
        // O eroare fără CustomerInfo nu șterge o eligibilitate deja cunoscută.
        if let info { revenueCatPremium = info.entitlements[entitlement]?.isActive == true }
    }

    func refresh(_ done: @escaping (Bool) -> Void) {
        if isDebugSimulation { isPremium = access(); done(isPremium); return }
        if configured { updatePremium(Purchases.shared.cachedCustomerInfo) }
        var pending = configured ? 2 : 1
        var reply: ((Bool) -> Void)? = done
        let deliver = { [weak self] in
            guard let self else { return }
            self.isPremium = self.access()
            let callback = reply
            reply = nil
            callback?(self.isPremium)
        }
        let arrived = {
            pending -= 1
            if pending == 0 { deliver() }
        }
        // Accesul cunoscut este imediat. Lipsa rețelei nu ține Promise-ul JS în așteptare.
        if access() { deliver() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { deliver() }
        loadOriginalPurchaseDate { arrived() }
        if configured {
            Purchases.shared.getCustomerInfo { [weak self] info, _ in
                DispatchQueue.main.async {
                    self?.updatePremium(info ?? Purchases.shared.cachedCustomerInfo)
                    arrived()
                }
            }
        }
    }

    private func loadOriginalPurchaseDate(_ done: @escaping () -> Void) {
        if originalPurchaseDate != nil { done(); return }
        let id = UUID()
        transactionWaiters[id] = done
        // Și așteptătorii unei cereri StoreKit lente sunt eliberați în cel mult 3 secunde.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.transactionWaiters.removeValue(forKey: id)?()
        }
        guard transactionTask == nil else { return }
        transactionTask = Task { [weak self] in
            var date: Date?
            do {
                let result = try await AppTransaction.shared
                if case .verified(let transaction) = result { date = transaction.originalPurchaseDate }
            } catch {
                NSLog("Pufi AppTransaction unavailable: %@", error.localizedDescription)
            }
            guard let self else { return }
            self.originalPurchaseDate = date
            if EntitlementPolicy.qualifies(date), !self.grandfatheredStore.save() {
                NSLog("Pufi could not persist grandfathered access in Keychain")
            }
            self.transactionTask = nil
            let callbacks = Array(self.transactionWaiters.values)
            self.transactionWaiters.removeAll()
            callbacks.forEach { $0() }
            self.isPremium = self.access()
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
        guard !isDebugSimulation, configured, !access() else { refresh(done); return }
        Purchases.shared.getOfferings { [weak self] offerings, _ in
            DispatchQueue.main.async {
                guard let self else { return }
                guard let pkg = offerings?.current?.availablePackages.first(where: { $0.storeProduct.productIdentifier == "unlock_all" }) else {
                    self.refresh(done)
                    return
                }
                Purchases.shared.purchase(package: pkg) { _, info, _, _ in
                    DispatchQueue.main.async {
                        self.updatePremium(info ?? Purchases.shared.cachedCustomerInfo)
                        self.refresh(done)
                    }
                }
            }
        }
    }

    func restore(_ done: @escaping (Bool) -> Void) {
        guard !isDebugSimulation, configured else { refresh(done); return }
        Purchases.shared.restorePurchases { [weak self] info, _ in
            DispatchQueue.main.async {
                guard let self else { return }
                self.updatePremium(info ?? Purchases.shared.cachedCustomerInfo)
                self.refresh(done)
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
