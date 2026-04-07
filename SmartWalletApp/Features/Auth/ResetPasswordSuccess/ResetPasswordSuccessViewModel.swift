import Foundation

struct ResetPasswordSuccessViewData {
    let titleText: String
    let subtitleText: String
    let loginButtonTitle: String
    let homeButtonTitle: String
}

enum ResetPasswordSuccessViewState {
    case loaded(ResetPasswordSuccessViewData)
    case countdown(Int)
    case routeToLogin
}

final class ResetPasswordSuccessViewModel {
    var onStateChange: ((ResetPasswordSuccessViewState) -> Void)?

    private var countdownTask: Task<Void, Never>?

    deinit {
        countdownTask?.cancel()
    }

    func load() {
        onStateChange?(
            .loaded(
                ResetPasswordSuccessViewData(
                    titleText: "Şifreniz Başarıyla\nGüncellendi",
                    subtitleText: "Artık yeni şifreniz ile güvenli bir şekilde\ngiriş yapabilirsiniz.",
                    loginButtonTitle: "Giriş Yap",
                    homeButtonTitle: "ANA SAYFAYA DÖN"
                )
            )
        )
        startCountdown()
    }

    func cancelCountdown() {
        countdownTask?.cancel()
        countdownTask = nil
    }

    private func startCountdown() {
        countdownTask?.cancel()
        countdownTask = Task { [weak self] in
            guard let self else { return }

            for seconds in stride(from: 10, through: 1, by: -1) {
                await MainActor.run {
                    self.onStateChange?(.countdown(seconds))
                }

                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
            }

            await MainActor.run {
                self.onStateChange?(.routeToLogin)
            }
        }
    }
}
