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
            messageTitleText: "Mesajınız",
            messagePlaceholderText: "Bize iletmek istediğiniz mesajı yazın",
            sendButtonTitleText: "Mesaj Gönder"
        )
    }

    func updateForm(name: String, message: String) {
        onStateChange?(.formUpdated(isSendEnabled: isFormValid(name: name, message: message)))
    }

    func sendMessage(name: String, message: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isFormValid(name: trimmedName, message: trimmedMessage) else {
            onStateChange?(.failure("Lütfen ad soyad ve mesaj alanlarını doldurun."))
            return
        }

        let body = """
        Ad Soyad: \(trimmedName)

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

    private func isFormValid(name: String, message: String) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
