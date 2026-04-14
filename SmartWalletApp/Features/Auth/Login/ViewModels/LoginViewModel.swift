import Foundation

enum LoginViewState {
    case idle
    case loading
    case success
    case failure(String)
}

final class LoginViewModel {
    var onStateChange: ((LoginViewState) -> Void)?

    private let authService: AuthService //DI için
    private let tokenStore: TokenStore

    init(authService: AuthService, tokenStore: TokenStore) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    @MainActor // ui tetiklendiği için
    func login(email: String, password: String) async { // boşlukları sil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            onStateChange?(.failure("E-posta ve şifre alanlarını doldurun."))
            return
        }

        onStateChange?(.loading)

        do { // api çağırımı ve keychaine token yazılımı 
            let response = try await authService.login(request: LoginRequest(email: trimmedEmail, password: trimmedPassword))
            try tokenStore.saveTokens(from: response)
            print("DEBUG Auth: login basarili. accessTokenEmpty=\(response.accessToken.isEmpty), refreshTokenEmpty=\(response.refreshToken.isEmpty)")
            print("DEBUG Auth: tokenlar keychain'e kaydedildi.")
            onStateChange?(.success)
        } catch {
            print("DEBUG Auth: login hatasi: \(error.localizedDescription)")
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}
