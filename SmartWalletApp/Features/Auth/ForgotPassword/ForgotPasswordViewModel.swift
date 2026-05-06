import Foundation

enum ForgotPasswordViewState {
    case idle
    case loading
    case success(String, ForgotPasswordResponse)
    case failure(String)
}

@MainActor
final class ForgotPasswordViewModel: BaseViewModel {
    var onStateChange: ((ForgotPasswordViewState) -> Void)?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func sendResetLink(email: String) async {
        let trimmedEmail = trimmed(email)

        guard !trimmedEmail.isEmpty else {
            emitFailure("E-posta alanını doldurun.", using: onStateChange, transform: ForgotPasswordViewState.failure)
            return
        }

        emit(.loading, using: onStateChange)

        do {
            let response = try await authService.forgotPassword(request: ForgotPasswordRequest(email: trimmedEmail))
            print("DEBUG Auth: forgot-password basarili. email=\(trimmedEmail)")
            emit(.success(trimmedEmail, response), using: onStateChange)
        } catch {
            print("DEBUG Auth: forgot-password hatasi: \(error.localizedDescription)")
            emitFailure(error.localizedDescription, using: onStateChange, transform: ForgotPasswordViewState.failure)
        }
    }
}
