import Foundation

enum LoginViewState {
    case idle
    case loading
    case success
    case failure(String)
}

@MainActor
final class LoginViewModel: BaseViewModel {
    var onStateChange: ((LoginViewState) -> Void)?

    private let authService: AuthService //DI için
    private let tokenStore: TokenStore

    init(authService: AuthService, tokenStore: TokenStore) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    func login(email: String, password: String) async { // boşlukları sil
        let trimmedEmail = trimmed(email)
        let trimmedPassword = trimmed(password)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            emitFailure("E-posta ve şifre alanlarını doldurun.", using: onStateChange, transform: LoginViewState.failure)
            return
        }

        emit(.loading, using: onStateChange)

        do { // api çağırımı ve keychaine token yazılımı 
            let response = try await authService.login(request: LoginRequest(email: trimmedEmail, password: trimmedPassword))
            try tokenStore.saveTokens(from: response)
            print("DEBUG Auth: login basarili. accessTokenEmpty=\(response.accessToken.isEmpty), refreshTokenEmpty=\(response.refreshToken.isEmpty)")
            print("DEBUG Auth: tokenlar keychain'e kaydedildi.")
            emit(.success, using: onStateChange)
        } catch {
            print("DEBUG Auth: login hatasi: \(error.localizedDescription)")
            emitFailure(error.localizedDescription, using: onStateChange, transform: LoginViewState.failure)
        }
    }
}
