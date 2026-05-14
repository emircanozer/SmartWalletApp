import Foundation

final class ChangePasswordViewModel {
    var onStateChange: ((ChangePasswordViewState) -> Void)?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }
}

extension ChangePasswordViewModel {
    func makeViewData() -> ChangePasswordViewData {
        ChangePasswordViewData(
            titleText: "Şifre Değiştir",
            headlineText: "Güvenliğinizi Koruyun",
            descriptionText: "Hesap güvenliğiniz için şifrenizi düzenli aralıklarla güncellemeyi unutmayın.",
            currentPasswordTitleText: "MEVCUT ŞİFRE",
            currentPasswordPlaceholderText: "Mevcut şifrenizi girin",
            newPasswordTitleText: "YENİ ŞİFRE",
            newPasswordPlaceholderText: "Yeni şifrenizi girin",
            newPasswordHelperText: "Şifreniz en az 8 karakter, büyük harf ve sayı içermelidir.",
            confirmPasswordTitleText: "YENİ ŞİFRE TEKRAR",
            confirmPasswordPlaceholderText: "Yeni şifrenizi tekrar girin",
            updateButtonTitleText: "Şifreyi Güncelle",
            forgotPasswordTitleText: "Şifremi Unuttum"
        )
    }

    func updateForm(currentPassword: String, newPassword: String, confirmPassword: String) {
        onStateChange?(
            .formUpdated(
                makeFormState(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    confirmPassword: confirmPassword
                )
            )
        )
    }

    @MainActor
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async {
        let currentPassword = currentPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let formState = makeFormState(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        )

        guard formState.isUpdateEnabled else {
            onStateChange?(.formUpdated(formState))
            return
        }

        onStateChange?(.loading)

        do {
            let response = try await authService.changePassword(
                request: ChangePasswordRequest(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    confirmNewPassword: confirmPassword
                )
            )
            onStateChange?(.success(response.message))
        } catch {
            onStateChange?(.failure("Şifre güncellenemedi. Lütfen bilgilerinizi kontrol edip tekrar deneyin."))
        }
    }

    private func makeFormState(
        currentPassword: String,
        newPassword: String,
        confirmPassword: String
    ) -> ChangePasswordFormState {
        let hasMismatch = !confirmPassword.isEmpty && newPassword != confirmPassword
        let isFilled = !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty
        return ChangePasswordFormState(
            isUpdateEnabled: isFilled && !hasMismatch,
            confirmPasswordErrorText: hasMismatch ? "Şifreler eşleşmiyor" : nil
        )
    }
}
