import Foundation

enum ResetPasswordViewState {
    case idle
    case loading
    case success(String)
    case failure(String)
}

final class ResetPasswordViewModel {
    var onStateChange: ((ResetPasswordViewState) -> Void)?

    let context: PendingPasswordResetContext
    private let authService: AuthService

    init(context: PendingPasswordResetContext, authService: AuthService) {
        self.context = context
        self.authService = authService
    }

    @MainActor
    func resetPassword(newPassword: String, confirmPassword: String) async {
        let trimmedPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPassword.isEmpty, !trimmedConfirmPassword.isEmpty else {
            onStateChange?(.failure("Lütfen yeni şifre alanlarını doldurun."))
            return
        }

        guard trimmedPassword.count >= 6 else {
            onStateChange?(.failure("Yeni şifre en az 6 karakter olmalıdır."))
            return
        }

        guard trimmedPassword == trimmedConfirmPassword else {
            onStateChange?(.failure("Şifreler birbiriyle eşleşmiyor."))
            return
        }

        onStateChange?(.loading)

        do {
            let response = try await authService.resetPassword(
                request: ResetPasswordRequest(
                    email: context.email,
                    code: context.code,
                    newPassword: trimmedPassword
                )
            )

            guard response.success else {
                onStateChange?(.failure(response.message))
                return
            }

            onStateChange?(.success(response.message))
        } catch {
            onStateChange?(.failure("Şifre güncellenemedi. \(error.localizedDescription)"))
        }
    }
}
