import Foundation

enum ForgotPasswordCodeViewState {
    case idle
    case loading
    case success(PendingPasswordResetContext, String)
    case resendSuccess(String)
    case failure(String)
}

@MainActor
final class ForgotPasswordCodeViewModel: BaseViewModel {
    var onStateChange: ((ForgotPasswordCodeViewState) -> Void)?

    let email: String
    private let authService: AuthService

    init(email: String, authService: AuthService) {
        self.email = email
        self.authService = authService
    }

    func verify(code: String) async {
        let trimmedCode = trimmed(code)

        guard trimmedCode.count == 6 else {
            emitFailure("Doğrulama kodu 6 haneli olmalıdır.", using: onStateChange, transform: ForgotPasswordCodeViewState.failure)
            return
        }

        emit(.loading, using: onStateChange)

        do {
            
            let response = try await authService.verifyPasswordResetCode(
                request: VerifyPasswordResetCodeRequest(email: email, code: trimmedCode)
            )

            guard response.success else {
                emitFailure(response.message, using: onStateChange, transform: ForgotPasswordCodeViewState.failure)
                return
            }

            emit(.success(PendingPasswordResetContext(email: email, code: trimmedCode), response.message), using: onStateChange)
        } catch {
            emitFailure("Kod doğrulanamadı. \(error.localizedDescription)", using: onStateChange, transform: ForgotPasswordCodeViewState.failure)
        }
    }

    func resendCode() async {
        emit(.loading, using: onStateChange)

        do {
            let response = try await authService.forgotPassword(request: ForgotPasswordRequest(email: email))
            guard response.success else {
                emitFailure(response.message, using: onStateChange, transform: ForgotPasswordCodeViewState.failure)
                return
            }
            emit(.resendSuccess(response.message), using: onStateChange)
        } catch {
            emitFailure(error.localizedDescription, using: onStateChange, transform: ForgotPasswordCodeViewState.failure)
        }
    }
}
