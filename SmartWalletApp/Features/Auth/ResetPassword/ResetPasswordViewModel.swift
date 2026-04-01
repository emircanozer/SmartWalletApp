import Foundation

enum ResetPasswordViewState {
    case idle
    case loading
    case success(String)
    case failure(String)
}

final class ResetPasswordViewModel {
    var onStateChange: ((ResetPasswordViewState) -> Void)?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    @MainActor
    func sendResetLink(email: String) async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty else {
            onStateChange?(.failure("E-posta alanını doldurun."))
            return
        }

        onStateChange?(.loading)

        do {
            try await authService.forgotPassword(request: ForgotPasswordRequest(email: trimmedEmail))
            print("DEBUG Auth: forgot-password basarili. email=\(trimmedEmail)")
            onStateChange?(.success("Sıfırlama bağlantısı e-posta adresinize gönderildi."))
        } catch {
            print("DEBUG Auth: forgot-password hatasi: \(error.localizedDescription)")
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}
