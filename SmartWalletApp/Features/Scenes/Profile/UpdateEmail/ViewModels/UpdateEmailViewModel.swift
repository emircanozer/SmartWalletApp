import Foundation

final class UpdateEmailViewModel {
    var onStateChange: ((UpdateEmailViewState) -> Void)?

    private let currentEmail: String
    private let authService: AuthService

    init(currentEmail: String, authService: AuthService) {
        self.currentEmail = currentEmail
        self.authService = authService
    }
}

extension UpdateEmailViewModel {
    func makeViewData() -> UpdateEmailViewData {
        UpdateEmailViewData(
            titleText: "E-posta Adresim",
            descriptionText: "Hesabınıza bağlı e-posta adresinizi burada görüntüleyebilir ve güncelleyebilirsiniz.",
            currentEmailTitleText: "MEVCUT E-POSTA",
            currentEmailText: currentEmail,
            newEmailTitleText: "Yeni E-posta Adresi",
            newEmailPlaceholderText: "Yeni e-posta adresinizi girin",
            confirmEmailTitleText: "E-posta Tekrar",
            confirmEmailPlaceholderText: "Yeni e-posta adresinizi tekrar girin",
            sendButtonTitleText: "Doğrulama Kodu Gönder",
            cancelButtonTitleText: "Vazgeç"
        )
    }

    func updateForm(newEmail: String, confirmEmail: String) {
        onStateChange?(.formUpdated(makeFormState(newEmail: newEmail, confirmEmail: confirmEmail)))
    }

    @MainActor
    func sendVerificationCode(newEmail: String, confirmEmail: String) async {
        let newEmail = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmEmail = confirmEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        let formState = makeFormState(newEmail: newEmail, confirmEmail: confirmEmail)

        guard formState.isSendEnabled else {
            onStateChange?(.formUpdated(formState))
            return
        }

        onStateChange?(.loading)

        do {
            let response = try await authService.updateEmail(
                request: UpdateEmailRequest(newEmail: newEmail, confirmEmail: confirmEmail)
            )
            onStateChange?(.success(response.message, UpdateEmailVerificationContext(newEmail: newEmail, confirmEmail: confirmEmail)))
        } catch {
            onStateChange?(.failure("E-posta güncelleme isteği gönderilemedi. Lütfen tekrar deneyin."))
        }
    }

    private func makeFormState(newEmail: String, confirmEmail: String) -> UpdateEmailFormState {
        let newEmail = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmEmail = confirmEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasMismatch = !confirmEmail.isEmpty && newEmail != confirmEmail
        let isFilled = !newEmail.isEmpty && !confirmEmail.isEmpty
        let isEmailValid = newEmail.contains("@") && confirmEmail.contains("@")

        return UpdateEmailFormState(
            isSendEnabled: isFilled && isEmailValid && !hasMismatch,
            confirmEmailErrorText: hasMismatch ? "E-posta adresleri eşleşmiyor" : nil
        )
    }
}
