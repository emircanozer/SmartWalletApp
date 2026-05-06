import Foundation

enum ResetPasswordViewState {
    case idle
    case loading
    case success(String)
    case failure(String)
}

@MainActor
final class ResetPasswordViewModel: BaseViewModel {
    var onStateChange: ((ResetPasswordViewState) -> Void)?

    let context: PendingPasswordResetContext
    private let authService: AuthService

    init(context: PendingPasswordResetContext, authService: AuthService) {
        self.context = context
        self.authService = authService
    }

    func resetPassword(newPassword: String, confirmPassword: String) async {
        let trimmedPassword = trimmed(newPassword)
        let trimmedConfirmPassword = trimmed(confirmPassword)

        guard !trimmedPassword.isEmpty, !trimmedConfirmPassword.isEmpty else {
            emitFailure("Lütfen yeni şifre alanlarını doldurun.", using: onStateChange, transform: ResetPasswordViewState.failure)
            return
        }

        guard trimmedPassword.count >= 6 else {
            emitFailure("Yeni şifre en az 6 karakter olmalıdır.", using: onStateChange, transform: ResetPasswordViewState.failure)
            return
        }

        guard trimmedPassword == trimmedConfirmPassword else {
            emitFailure("Şifreler birbiriyle eşleşmiyor.", using: onStateChange, transform: ResetPasswordViewState.failure)
            return
        }

        emit(.loading, using: onStateChange)

        do {
            let response = try await authService.resetPassword(
                request: ResetPasswordRequest(
                    email: context.email,
                    code: context.code,
                    newPassword: trimmedPassword
                )
            )

            guard response.success else {
                emitFailure(response.message, using: onStateChange, transform: ResetPasswordViewState.failure)
                return
            }

            emit(.success(response.message), using: onStateChange)
        } catch {
            emitFailure("Şifre güncellenemedi. \(error.localizedDescription)", using: onStateChange, transform: ResetPasswordViewState.failure)
        }
    }
}
