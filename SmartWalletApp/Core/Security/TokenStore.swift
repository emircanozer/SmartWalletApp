import Foundation

/* LoginResponse geldi
 TokenStore bu tokenları alır
 KeychainManager ile Keychain'e kaydeder
 Sonra ihtiyaç olunca tekrar okur*/

final class TokenStore {
    // sabit key isimleri
     enum Keys {
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        static let refreshTokenExpiration = "refresh_token_expiration"
    }

    private let keychainManager: KeychainManager

    
    init(keychainManager: KeychainManager = KeychainManager()) {
        self.keychainManager = keychainManager
    }

    // computed
    var accessToken: String? {
        try? keychainManager.readValue(for: Keys.accessToken)
    }

    func saveTokens(from response: LoginResponse) throws {
        try keychainManager.save(response.accessToken, for: Keys.accessToken)
        try keychainManager.save(response.refreshToken, for: Keys.refreshToken)
        try keychainManager.save(response.refreshTokenExpiration, for: Keys.refreshTokenExpiration)
    }

    // logout için mantıklı 
    func clearTokens() throws {
        try keychainManager.deleteValue(for: Keys.accessToken)
        try keychainManager.deleteValue(for: Keys.refreshToken)
        try keychainManager.deleteValue(for: Keys.refreshTokenExpiration)
    }
}
