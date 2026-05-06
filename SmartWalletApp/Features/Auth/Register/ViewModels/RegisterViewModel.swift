import Foundation

enum RegisterViewState {
    case idle
    case loading
    case verificationRequired(PendingRegistrationContext)
    case failure(String)
}

@MainActor
final class RegisterViewModel: BaseViewModel {
    var onStateChange: ((RegisterViewState) -> Void)?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func register(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        isTermsAccepted: Bool
    ) async {
        let trimmedName = trimmed(name)
        let trimmedEmail = trimmed(email)
        let trimmedPassword = trimmed(password)
        let trimmedConfirmPassword = trimmed(confirmPassword)

        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty, !trimmedPassword.isEmpty, !trimmedConfirmPassword.isEmpty else {
            emitFailure("Tüm alanları doldurun.", using: onStateChange, transform: RegisterViewState.failure)
            return
        }

        guard trimmedPassword.count >= 8 else {
            emitFailure("Şifre en az 8 karakter olmalıdır.", using: onStateChange, transform: RegisterViewState.failure)
            return
        }

        guard trimmedPassword == trimmedConfirmPassword else {
            emitFailure("Şifreler eşleşmiyor.", using: onStateChange, transform: RegisterViewState.failure)
            return
        }

        guard isTermsAccepted else {
            emitFailure("Devam etmek için kullanım şartlarını kabul edin.", using: onStateChange, transform: RegisterViewState.failure)
            return
        }

        emit(.loading, using: onStateChange)

        do {
            let response = try await authService.register(
                request: RegisterRequest(name: trimmedName, email: trimmedEmail, password: trimmedPassword)
            )
            print("DEBUG Auth: register basarili. userId=\(response.userId), walletId=\(response.walletId), iban=\(response.iban)")

            let context = PendingRegistrationContext(
                name: trimmedName,
                email: trimmedEmail,
                password: trimmedPassword,
                registration: response
            )

            emit(.verificationRequired(context), using: onStateChange)
        } catch {
            emitFailure(error.localizedDescription, using: onStateChange, transform: RegisterViewState.failure)
        }
    }
}
