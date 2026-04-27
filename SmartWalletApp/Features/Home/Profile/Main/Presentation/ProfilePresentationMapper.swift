import Foundation

enum ProfilePresentationMapper {
    static func makeViewData(
        from response: ProfileResponse,
        lastFailedLogin: LastFailedLoginResponse?,
        isDarkModeEnabled: Bool
    ) -> ProfileViewData {
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

    private static func makeLastFailedLoginCard(from response: LastFailedLoginResponse?) -> ProfileInfoCardViewData {
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
