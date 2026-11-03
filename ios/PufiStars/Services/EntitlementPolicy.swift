import Foundation

/// Regula de acces, independentă de StoreKit, RevenueCat și stocare.
struct EntitlementPolicy {
    // 15 decembrie 2026, 00:00 Europe/Zurich (CET).
    static let cutoff = ISO8601DateFormatter().date(from: "2026-12-14T23:00:00Z")!

    static func isUnlocked(now: Date, originalPurchaseDate: Date?,
                           grandfathered: Bool, premium: Bool) -> Bool {
        now < cutoff || qualifies(originalPurchaseDate) || grandfathered || premium
    }

    static func qualifies(_ originalPurchaseDate: Date?) -> Bool {
        originalPurchaseDate.map { $0 < cutoff } ?? false
    }
}

#if DEBUG
/// Scenarii izolate: nu citesc/scriu eligibilitatea reală și nu fac achiziții.
struct EntitlementTestOverrides {
    let now: Date
    let originalPurchaseDate: Date?
    let premium: Bool

    init?(arguments: [String], now: Date = Date()) {
        let flags = ["-PufiNow", "-PufiOriginalPurchase", "-PufiPremium"]
        guard flags.contains(where: arguments.contains) else { return nil }
        func value(_ flag: String) -> String? {
            guard let i = arguments.firstIndex(of: flag), i + 1 < arguments.count else { return nil }
            return arguments[i + 1]
        }
        func date(_ value: String?) -> Date? {
            guard let value else { return nil }
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: value) { return date }
            formatter.formatOptions.insert(.withFractionalSeconds)
            return formatter.date(from: value)
        }
        self.now = date(value("-PufiNow")) ?? now
        originalPurchaseDate = date(value("-PufiOriginalPurchase"))
        premium = value("-PufiPremium") == "true"
    }

    var isUnlocked: Bool {
        EntitlementPolicy.isUnlocked(now: now, originalPurchaseDate: originalPurchaseDate,
                                     grandfathered: false, premium: premium)
    }
}
#endif
