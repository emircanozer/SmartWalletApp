import Foundation

class LoginViewModel {
    struct Shortcut: Hashable {
        let title: String
        let iconName: String
    }

    struct TabItem: Hashable {
        let title: String
        let iconName: String
        let isHighlighted: Bool
    }

    let welcomeTitle = "Hoş Geldiniz"
    let welcomeSubtitle = "Finansal asistanınız her an yanınızda."
    let primaryButtonTitle = "Giriş Yap"
    let secondaryButtonTitle = "Kayıt Ol"
    let tertiaryButtonTitle = "Dijital Şifre Al"
    let languageTitle = "TR/EN"
    let shortcuts: [Shortcut] = [
        .init(title: "AI Analiz", iconName: "brain.head.profile"),
        .init(title: "Smart Limit", iconName: "gauge"),
        .init(title: "Hızlı Trf.", iconName: "arrow.left.arrow.right"),
        .init(title: "Birikim", iconName: "dollarsign.circle"),
        .init(title: "Piyasalar", iconName: "chart.line.uptrend.xyaxis")
    ]
    let tabItems: [TabItem] = [
        .init(title: "Hizmetler", iconName: "bolt.fill", isHighlighted: false),
        .init(title: "Piyasalar", iconName: "chart.bar.fill", isHighlighted: false),
        .init(title: "", iconName: "cpu", isHighlighted: true),
        .init(title: "Hesaplarım", iconName: "person.text.rectangle", isHighlighted: false),
        .init(title: "Diğer", iconName: "square.grid.2x2", isHighlighted: false)
    ]
}
