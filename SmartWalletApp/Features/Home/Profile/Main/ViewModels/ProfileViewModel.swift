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
        ProfileViewData(
            titleText: "Profil",
            isDarkModeEnabled: isDarkModeEnabled,
            header: ProfileHeaderViewData(
                initialText: response.initial,
                nameText: response.name
            ),
            email: ProfileEmailViewData(
                titleText: "E-posta Adresim",
                valueText: response.email
            ),
            accountSection: ProfileSectionViewData(
                items: [
                    ProfileRowItem(titleText: "Finansal Hedefler", iconName: "target", accessory: .chevron, action: .financialGoals, isDestructive: false),
                    ProfileRowItem(titleText: "Geçmiş Transfer Dekontları", iconName: "doc.text", accessory: .chevron, action: .transferReceipts, isDestructive: false),
                    ProfileRowItem(titleText: "Geçmiş Varlık İşlemleri", iconName: "clock.arrow.circlepath", accessory: .chevron, action: .tradeHistory, isDestructive: false)
                ]
            ),
            historySection: ProfileSectionViewData(
                items: [
                    ProfileRowItem(titleText: "Şifre Değiştir", iconName: "key", accessory: .chevron, action: .changePassword, isDestructive: false),
                    ProfileRowItem(titleText: "Veri & Gizlilik", iconName: "shield", accessory: .chevron, action: .privacy, isDestructive: false)
                ]
            ),
            supportSection: ProfileSectionViewData(
                items: [
                    ProfileRowItem(titleText: "Bize Yazın", iconName: "message", accessory: .chevron, action: .contactUs, isDestructive: false),
                    ProfileRowItem(titleText: "Hesabımı Sil", iconName: "trash", accessory: .chevron, action: .deleteAccount, isDestructive: true)
                ]
            ),
            lastFailedLoginCard: makeLastFailedLoginCard(from: lastFailedLogin),
            logoutTitleText: "ÇIKIŞ YAP"
        )
    }

    func makeLastFailedLoginCard(from response: LastFailedLoginResponse?) -> ProfileInfoCardViewData {
        guard let response else {
            return ProfileInfoCardViewData(
                titleText: "Son Hatalı Giriş",
                valueText: "Kayıt bulunamadı",
                accentText: nil
            )
        }

        return ProfileInfoCardViewData(
            titleText: "Son Hatalı Giriş",
            valueText: response.message,
            accentText: AppDateTextFormatter.string(
                from: response.lastFailedLoginDate,
                style: .profileFailedLoginDateTime
            )
        )
    }
}
