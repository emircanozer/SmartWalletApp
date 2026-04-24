import Foundation

final class ContactUsSuccessViewModel {
    func makeViewData() -> ContactUsSuccessViewData {
        ContactUsSuccessViewData(
            titleText: "Mesaj Gönderildi",
            headlineText: "Mesajınız bize ulaştı",
            bodyText: "Destek ekibimiz mesajınızı aldı. En kısa sürede e-posta adresiniz üzerinden sizinle iletişime geçeceğiz.",
            infoText: "Yanıtlar kayıtlı e-posta adresinize gönderilecektir. Yoğunluğa bağlı olarak dönüş süresi değişebilir.",
            footerTitleText: "TALEBİNİZ SİSTEMİMİZE BAŞARIYLA KAYDEDİLDİ.",
            supportEmailTitleText: "Destek e-postası:",
            supportEmailText: "desteksmartwalletai@gmail.com",
            homeButtonTitleText: "Ana Sayfaya Dön",
            newMessageButtonTitleText: "Yeni Mesaj Oluştur"
        )
    }
}
