import Foundation
import StoreKit

/// Acces gratuit la lansare, apoi o singură achiziție Apple: `unlock_all`.
@MainActor
final class PurchaseService {
    static let shared = PurchaseService()
    static let productID = "unlock_all"

    private let grandfatheredStore = GrandfatheredStore()
    private var configured = false
    private var purchased = false
    private var originalPurchaseDate: Date?
    private var product: Product?
    private var updatesTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?
    private var refreshWaiters: [UUID: (Bool) -> Void] = [:]
    private var purchasing = false
    private(set) var isPremium = false

    #if DEBUG
    private let testOverrides: EntitlementTestOverrides?
    private let storeKitTest: Bool

    init(arguments: [String] = ProcessInfo.processInfo.arguments) {
        testOverrides = EntitlementTestOverrides(arguments: arguments)
        storeKitTest = arguments.contains("-PufiStoreKitTest")
    }
    #endif

    deinit {
        updatesTask?.cancel()
        refreshTask?.cancel()
    }

    private var simulated: Bool {
        #if DEBUG
        return !storeKitTest
        #else
        return false
        #endif
    }

    private var isolatedStoreKitTest: Bool {
        #if DEBUG
        return storeKitTest
        #else
        return false
        #endif
    }

    private func access() -> Bool {
        #if DEBUG
        if let testOverrides {
            return EntitlementPolicy.isUnlocked(now: testOverrides.now,
                originalPurchaseDate: testOverrides.originalPurchaseDate, grandfathered: false,
                premium: storeKitTest ? purchased : testOverrides.premium)
        }
        if !storeKitTest { return true }
        // StoreKit Test fără dată explicită verifică accesul unui utilizator nou după limită.
        if storeKitTest { return purchased }
        #endif
        return EntitlementPolicy.isUnlocked(now: Date(), originalPurchaseDate: originalPurchaseDate,
            grandfathered: grandfatheredStore.isGrandfathered, premium: purchased)
    }

    func configure() {
        guard !configured else { return }
        configured = true
        isPremium = access()
        guard !simulated else { return }
        // Ascultăm înaintea oricărei achiziții, inclusiv aprobări Ask to Buy și rambursări.
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                guard !Task.isCancelled else { break }
                guard case .verified(let transaction) = result,
                      transaction.productID == Self.productID else { continue }
                await self?.readEntitlements()
                await transaction.finish()
            }
        }
        refresh { _ in }
    }

    private func readEntitlements() async {
        var active = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID,
               transaction.productType == .nonConsumable,
               transaction.revocationDate == nil {
                active = true
            }
        }
        purchased = active
        isPremium = access()
    }

    func refresh(_ done: @escaping (Bool) -> Void) {
        guard !simulated else { isPremium = access(); done(isPremium); return }
        let id = UUID()
        refreshWaiters[id] = done
        // Răspundem o singură dată; AppTransaction lent nu blochează jocul.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            self.isPremium = self.access()
            self.refreshWaiters.removeValue(forKey: id)?(self.isPremium)
        }
        guard refreshTask == nil else { return }
        refreshTask = Task { [weak self] in
            guard let self else { return }
            await self.readEntitlements()
            if !self.isolatedStoreKitTest, self.originalPurchaseDate == nil {
                do {
                    if case .verified(let transaction) = try await AppTransaction.shared {
                        self.originalPurchaseDate = transaction.originalPurchaseDate
                        if EntitlementPolicy.qualifies(self.originalPurchaseDate), !self.grandfatheredStore.save() {
                            NSLog("Pufi could not persist grandfathered access in Keychain")
                        }
                    }
                } catch {
                    NSLog("Pufi AppTransaction unavailable: %@", error.localizedDescription)
                }
            }
            self.isPremium = self.access()
            self.refreshTask = nil
            let callbacks = Array(self.refreshWaiters.values)
            self.refreshWaiters.removeAll()
            callbacks.forEach { $0(self.isPremium) }
        }
    }

    private func loadProduct() async throws -> Product? {
        if let product { return product }
        let loaded = try await Product.products(for: [Self.productID])
            .first { $0.id == Self.productID && $0.type == .nonConsumable }
        product = loaded
        return loaded
    }

    func price(_ done: @escaping (String?) -> Void) {
        guard !simulated else { done(nil); return }
        Task {
            do { done(try await loadProduct()?.displayPrice) }
            catch { done(nil) }
        }
    }

    func buy(_ done: @escaping (Bool) -> Void) {
        guard !simulated, !access() else { refresh(done); return }
        guard !purchasing else { done(false); return }
        purchasing = true
        Task {
            defer { purchasing = false }
            do {
                guard let product = try await loadProduct() else { done(false); return }
                switch try await product.purchase() {
                case .success(let result):
                    guard case .verified(let transaction) = result,
                          transaction.productID == Self.productID,
                          transaction.revocationDate == nil else { done(false); return }
                    await readEntitlements()
                    await transaction.finish()
                    done(isPremium)
                case .pending, .userCancelled:
                    done(false)
                @unknown default:
                    done(false)
                }
            } catch {
                NSLog("Pufi purchase unavailable: %@", error.localizedDescription)
                done(false)
            }
        }
    }

    func restore(_ done: @escaping (Bool) -> Void) {
        guard !simulated else { refresh(done); return }
        Task {
            do { try await AppStore.sync() }
            catch { NSLog("Pufi restore unavailable: %@", error.localizedDescription) }
            refresh(done)
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
