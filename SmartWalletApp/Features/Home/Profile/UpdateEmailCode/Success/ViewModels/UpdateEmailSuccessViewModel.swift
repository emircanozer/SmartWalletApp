import Foundation

final class UpdateEmailSuccessViewModel {
    func makeViewData() -> UpdateEmailSuccessViewData {
        UpdateEmailSuccessViewData(
            brandText: "SmartWallet AI",
            titleText: "Doğrulama Başarılı",
            bodyText: "E-posta adresiniz başarıyla doğrulandı.",
            homeButtonTitleText: "Ana Sayfaya Dön",
            footerText: "Artık hesabınızı güvenle kullanabilirsiniz."
        )
    }
}
