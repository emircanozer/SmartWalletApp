import Foundation

final class UpdateEmailCodeViewModel {
    var onStateChange: ((UpdateEmailCodeViewState) -> Void)?

    private let context: UpdateEmailVerificationContext
    private let authService: AuthService

    init(context: UpdateEmailVerificationContext, authService: AuthService) {
        self.context = context
        self.authService = authService
    }
}

extension UpdateEmailCodeViewModel {
    func makeViewData() -> UpdateEmailCodeViewData {
        UpdateEmailCodeViewData(
            brandText: "SmartWallet AI",
            titleText: "Doğrulama Kodunu Girin",
            subtitleText: "E-posta adresinize gönderilen 6 haneli doğrulama kodunu girin.",
            verifyButtonTitleText: "Kodu Doğrula",
            footerText: "Kod gelmedi mi?",
            resendButtonTitleText: "Tekrar gönder"
        )
    }

    @MainActor
    func verify(code: String) async {
        guard code.count == 6 else {
            onStateChange?(.failure("Lütfen 6 haneli doğrulama kodunu girin."))
            return
        }

        onStateChange?(.loading)

        do {
            let response = try await authService.confirmEmailUpdate(
                request: ConfirmEmailUpdateRequest(code: code)
            )
            if response.success {
                onStateChange?(.success(response.message))
            } else {
                onStateChange?(.failure(response.message))
            }
        } catch {
            onStateChange?(.failure("E-posta doğrulama işlemi tamamlanamadı. Lütfen tekrar deneyin."))
        }
    }

    @MainActor
    func resendCode() async {
        onStateChange?(.loading)

        do {
            let response = try await authService.updateEmail(
                request: UpdateEmailRequest(newEmail: context.newEmail, confirmEmail: context.confirmEmail)
            )
            onStateChange?(.resendSuccess(response.message))
        } catch {
            onStateChange?(.failure("Doğrulama kodu tekrar gönderilemedi. Lütfen tekrar deneyin."))
        }
    }
}
