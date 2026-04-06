import Foundation
import Security // **

// veriyi kaydetmek okumak silmeye işe yarıyor
final class KeychainManager {
    
    // keychain string ile değil data tipi ile çalışır
    func save(_ value: String, for key: String) throws {
        // stringi dataya çevirdik
        let data = Data(value.utf8)
        // bu veri hangi key ile saklanacak
        let query = baseQuery(for: key)

        // Aynı key varsa çakışmasın diye siliyoruz
        SecItemDelete(query as CFDictionary)

        var attributes = query
        // yeni veri ekliyor
        attributes[kSecValueData as String] = data
        //Telefon ilk açıldıktan sonra erişilebilir arka plan da da çalışır
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        // sisteme ekliyor
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandled(status)
        }
    }

    func readValue(for key: String) throws -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.unhandled(status)
        }

        guard let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func deleteValue(for key: String) throws {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandled(status)
        }
    }
}

 extension KeychainManager {
    func baseQuery(for key: String) -> [String: Any] {
        [
            // veri tipi (şifre gibi)
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.emircan.SmartWalletApp",
            kSecAttrAccount as String: key
        ]
    }
}

enum KeychainError: LocalizedError {
    case unhandled(OSStatus)

    var errorDescription: String? {
        switch self {
        case .unhandled:
            return "Güvenli veri saklama işlemi tamamlanamadı."
        }
    }
}
