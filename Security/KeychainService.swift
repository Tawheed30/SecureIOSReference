import Foundation
import Security

enum KeychainService {
    static func save(service: String, account: String, data: Data) throws {
        // Delete any existing item first (idempotent)
        try? delete(service: service, account: account)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            // Accessible when device is unlocked; adjust as needed.
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainService", code: Int(status), userInfo: [
                NSLocalizedDescriptionKey: "Keychain save failed with status \(status)"
            ])
        }
    }

    static func load(service: String, account: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainService", code: Int(status), userInfo: [
                NSLocalizedDescriptionKey: "Keychain load failed with status \(status)"
            ])
        }
        return item as? Data
    }

    static func delete(service: String, account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecItemNotFound { return } // ok
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainService", code: Int(status), userInfo: [
                NSLocalizedDescriptionKey: "Keychain delete failed with status \(status)"
            ])
        }
    }
}
