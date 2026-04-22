import Foundation

final class ContactUsViewModel {
    var onStateChange: ((ContactUsViewState) -> Void)?

    private let supportEmail = "desteksmartwalletai@gmail.com"
}

extension ContactUsViewModel {
    func makeViewData() -> ContactUsViewData {
        ContactUsViewData(
            titleText: "Bize Yazın",
            subtitleText: "Sorun, öneri veya geri bildiriminizi bize iletin.",
            nameTitleText: "Ad Soyad",
            namePlaceholderText: "Adınızı ve soyadınızı yazın",
            emailTitleText: "E-posta",
            emailPlaceholderText: "E-posta adresinizi yazın",
            messageTitleText: "Mesajınız",
            messagePlaceholderText: "Bize iletmek istediğiniz mesajı yazın",
            sendButtonTitleText: "Mesaj Gönder"
        )
    }

    func updateForm(name: String, email: String, message: String) {
        onStateChange?(.formUpdated(isSendEnabled: isFormValid(name: name, email: email, message: message)))
    }

    func sendMessage(name: String, email: String, message: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isFormValid(name: trimmedName, email: trimmedEmail, message: trimmedMessage) else {
            onStateChange?(.failure("Lütfen ad soyad, e-posta ve mesaj alanlarını doldurun."))
            return
        }

        let body = """
        Ad Soyad: \(trimmedName)
        E-posta: \(trimmedEmail)

        Mesaj:
        \(trimmedMessage)
        """

        onStateChange?(
            .mailDraft(
                ContactUsMailDraft(
                    recipient: supportEmail,
                    subject: "SmartWallet AI Destek Talebi",
                    body: body
                )
            )
        )
    }

    private func isFormValid(name: String, email: String, message: String) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && email.trimmingCharacters(in: .whitespacesAndNewlines).contains("@")
            && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
