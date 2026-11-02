import Foundation
import Security

/// Doar o tranzacție originală verificată poate seta acest indicator permanent.
struct GrandfatheredStore {
    let service: String

    init(service: String = (Bundle.main.bundleIdentifier ?? "com.horace.pufistars") + ".entitlements") {
        self.service = service
    }

    private var query: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: "grandfathered"]
    }

    var isGrandfathered: Bool {
        var request = query
        request[kSecReturnData as String] = true
        request[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        return SecItemCopyMatching(request as CFDictionary, &result) == errSecSuccess
            && (result as? Data) == Data([1])
    }

    @discardableResult
    func save() -> Bool {
        let attributes = [kSecValueData as String: Data([1])]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecSuccess { return true }
        guard status == errSecItemNotFound else { return false }
        var item = query
        item[kSecValueData as String] = Data([1])
        item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        return SecItemAdd(item as CFDictionary, nil) == errSecSuccess
    }
}
