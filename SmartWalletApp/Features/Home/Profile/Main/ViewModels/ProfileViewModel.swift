import Foundation

final class ProfileViewModel {
    var onStateChange: ((ProfileViewState) -> Void)?

    private let authService: AuthService
    private let tokenStore: TokenStore
    private(set) var isDarkModeEnabled: Bool

    init(authService: AuthService, tokenStore: TokenStore, isDarkModeEnabled: Bool = false) {
        self.authService = authService
        self.tokenStore = tokenStore
        self.isDarkModeEnabled = isDarkModeEnabled
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await authService.fetchProfile()
            let lastFailedLogin = try? await authService.fetchLastFailedLogin()
            onStateChange?(.loaded(makeViewData(from: response, lastFailedLogin: lastFailedLogin)))
        } catch {
            onStateChange?(.failure("Profil bilgileri alınamadı. Lütfen tekrar deneyin."))
        }
    }

    @MainActor
    func updateDarkMode(_ isEnabled: Bool) {
        isDarkModeEnabled = isEnabled
        ThemePreferenceStore.shared.setDarkModeEnabled(isEnabled)
        onStateChange?(.idle)
    }

    @MainActor
    func logout() async {
        onStateChange?(.loading)

        do {
            try await authService.logout()
            try tokenStore.clearTokens()
            onStateChange?(.logoutSucceeded)
        } catch {
            onStateChange?(.failure("Çıkış yapılamadı. Lütfen tekrar deneyin."))
        }
    }
}

 extension ProfileViewModel {
    func makeViewData(from response: ProfileResponse, lastFailedLogin: LastFailedLoginResponse?) -> ProfileViewData {
        ProfilePresentationMapper.makeViewData(
            from: response,
            lastFailedLogin: lastFailedLogin,
            isDarkModeEnabled: isDarkModeEnabled
        )
    }
}
