import Foundation

enum RegisterViewState {
    case idle
    case loading
    case verificationRequired(PendingRegistrationContext)
    case failure(String)
}

final class RegisterViewModel {
    var onStateChange: ((RegisterViewState) -> Void)?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    @MainActor
    func register(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        isTermsAccepted: Bool
    ) async {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty, !trimmedPassword.isEmpty, !trimmedConfirmPassword.isEmpty else {
            onStateChange?(.failure("Tüm alanları doldurun."))
            return
        }

        guard trimmedPassword.count >= 8 else {
            onStateChange?(.failure("Şifre en az 8 karakter olmalıdır."))
            return
        }

        guard trimmedPassword == trimmedConfirmPassword else {
            onStateChange?(.failure("Şifreler eşleşmiyor."))
            return
        }

        guard isTermsAccepted else {
            onStateChange?(.failure("Devam etmek için kullanım şartlarını kabul edin."))
            return
        }

        onStateChange?(.loading)

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

            onStateChange?(.verificationRequired(context))
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}
