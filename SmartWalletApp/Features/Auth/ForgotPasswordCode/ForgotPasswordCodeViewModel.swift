import Foundation

enum ForgotPasswordCodeViewState {
    case idle
    case loading
    case success(PendingPasswordResetContext, String)
    case resendSuccess(String)
    case failure(String)
}

final class ForgotPasswordCodeViewModel {
    var onStateChange: ((ForgotPasswordCodeViewState) -> Void)?

    let email: String
    private let authService: AuthService

    init(email: String, authService: AuthService) {
        self.email = email
        self.authService = authService
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
            let response = try await authService.verifyPasswordResetCode(
                request: VerifyPasswordResetCodeRequest(email: email, code: trimmedCode)
            )

            guard response.success else {
                onStateChange?(.failure(response.message))
                return
            }

            onStateChange?(.success(PendingPasswordResetContext(email: email, code: trimmedCode), response.message))
        } catch {
            onStateChange?(.failure("Kod doğrulanamadı. \(error.localizedDescription)"))
        }
    }

    @MainActor
    func resendCode() async {
        onStateChange?(.loading)

        do {
            let response = try await authService.forgotPassword(request: ForgotPasswordRequest(email: email))
            guard response.success else {
                onStateChange?(.failure(response.message))
                return
            }
            onStateChange?(.resendSuccess(response.message))
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}
