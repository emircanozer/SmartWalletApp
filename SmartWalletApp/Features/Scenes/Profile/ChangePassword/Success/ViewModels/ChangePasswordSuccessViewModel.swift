import Foundation

final class ChangePasswordSuccessViewModel {
    func makeViewData() -> ChangePasswordSuccessViewData {
        ChangePasswordSuccessViewData(
            titleText: "Şifreniz\nGüncellendi",
            bodyText: "Dijital şifreniz başarıyla güncellendi.\nYeni şifrenizle güvenli şekilde giriş yapabilirsiniz.",
            homeButtonTitleText: "Ana Sayfa"
        )
    }
}
