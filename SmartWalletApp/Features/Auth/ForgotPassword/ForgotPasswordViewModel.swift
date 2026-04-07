import Foundation

enum ForgotPasswordViewState {
    case idle
    case loading
    case success(String, ForgotPasswordResponse)
    case failure(String)
}

final class ForgotPasswordViewModel {
    var onStateChange: ((ForgotPasswordViewState) -> Void)?

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
            let response = try await authService.forgotPassword(request: ForgotPasswordRequest(email: trimmedEmail))
            print("DEBUG Auth: forgot-password basarili. email=\(trimmedEmail)")
            onStateChange?(.success(trimmedEmail, response))
        } catch {
            print("DEBUG Auth: forgot-password hatasi: \(error.localizedDescription)")
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}
