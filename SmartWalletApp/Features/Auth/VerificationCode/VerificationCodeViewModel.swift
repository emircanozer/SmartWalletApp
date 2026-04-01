import Foundation

enum VerificationCodeViewState {
    case idle
    case loading
    case success(PendingRegistrationContext, VerifyEmailResponse)
    case resendSuccess(String)
    case failure(String)
}

final class VerificationCodeViewModel {
    var onStateChange: ((VerificationCodeViewState) -> Void)?

    private(set) var context: PendingRegistrationContext

    private let authService: AuthService
    private let tokenStore: TokenStore

    //kordinatördeki context burada kullanılır 
    init(context: PendingRegistrationContext, authService: AuthService, tokenStore: TokenStore) {
        self.context = context
        self.authService = authService
        self.tokenStore = tokenStore
    }

    @MainActor
    func verify(code: String) async {
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmedCode.count == 6 else {
            onStateChange?(.failure("Doğrulama kodu 6 haneli olmalıdır."))
            return
        }

        onStateChange?(.loading)

        do {
            let verifyResponse = try await authService.verifyEmail(
                request: VerifyEmailRequest(email: context.email, code: trimmedCode)
            )
            print("DEBUG Auth: verify-email cevabi. success=\(verifyResponse.success), message=\(verifyResponse.message)")

            guard verifyResponse.success else {
                onStateChange?(.failure(verifyResponse.message))
                return
            }

            do {
                let loginResponse = try await authService.login(
                    request: LoginRequest(email: context.email, password: context.password)
                )
                try tokenStore.saveTokens(from: loginResponse)
                print("DEBUG Auth: verify sonrasi otomatik login basarili. accessTokenEmpty=\(loginResponse.accessToken.isEmpty), refreshTokenEmpty=\(loginResponse.refreshToken.isEmpty)")
                print("DEBUG Auth: tokenlar keychain'e kaydedildi.")
            } catch {
                print("DEBUG Auth: verify basarili ama otomatik login hatasi: \(error.localizedDescription)")
                onStateChange?(.failure("Doğrulama başarılı oldu ama otomatik giriş tamamlanamadı. \(error.localizedDescription)"))
                return
            }

            onStateChange?(.success(context, verifyResponse))
        } catch {
            print("DEBUG Auth: verify-email hatasi: \(error.localizedDescription)")
            onStateChange?(.failure("Doğrulama tamamlanamadı. \(error.localizedDescription)"))
        }
    }

    @MainActor
    func resendCode() async {
        onStateChange?(.loading)

        do {
            let response = try await authService.resendVerificationCode(
                request: ResendVerificationCodeRequest(
                    email: context.email
                )
            )
            print("DEBUG Auth: verification code yeniden gonderildi. email=\(context.email), message=\(response.message)")
            onStateChange?(.resendSuccess(response.message))
        } catch {
            print("DEBUG Auth: verification code yeniden gonderme hatasi: \(error.localizedDescription)")
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}
