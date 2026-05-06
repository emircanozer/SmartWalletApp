import Foundation

enum VerificationCodeViewState {
    case idle
    case loading
    case success(PendingRegistrationContext, VerifyEmailResponse)
    case resendSuccess(String)
    case failure(String)
}

@MainActor
final class VerificationCodeViewModel: BaseViewModel {
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

    func verify(code: String) async {
        let trimmedCode = trimmed(code)

        guard trimmedCode.count == 6 else {
            emitFailure("Doğrulama kodu 6 haneli olmalıdır.", using: onStateChange, transform: VerificationCodeViewState.failure)
            return
        }

        emit(.loading, using: onStateChange)

        do {
            let verifyResponse = try await authService.verifyEmail(
                request: VerifyEmailRequest(email: context.email, code: trimmedCode)
            )
            print("DEBUG Auth: verify-email cevabi. success=\(verifyResponse.success), message=\(verifyResponse.message)")

            guard verifyResponse.success else {
                emitFailure(verifyResponse.message, using: onStateChange, transform: VerificationCodeViewState.failure)
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
                emitFailure(
                    "Doğrulama başarılı oldu ama otomatik giriş tamamlanamadı. \(error.localizedDescription)",
                    using: onStateChange,
                    transform: VerificationCodeViewState.failure
                )
                return
            }

            emit(.success(context, verifyResponse), using: onStateChange)
        } catch {
            print("DEBUG Auth: verify-email hatasi: \(error.localizedDescription)")
            emitFailure(
                "Doğrulama tamamlanamadı. \(error.localizedDescription)",
                using: onStateChange,
                transform: VerificationCodeViewState.failure
            )
        }
    }

    func resendCode() async {
        emit(.loading, using: onStateChange)

        do {
            let response = try await authService.resendVerificationCode(
                request: ResendVerificationCodeRequest(
                    email: context.email
                )
            )
            print("DEBUG Auth: verification code yeniden gonderildi. email=\(context.email), message=\(response.message)")
            emit(.resendSuccess(response.message), using: onStateChange)
        } catch {
            print("DEBUG Auth: verification code yeniden gonderme hatasi: \(error.localizedDescription)")
            emitFailure(error.localizedDescription, using: onStateChange, transform: VerificationCodeViewState.failure)
        }
    }
}
