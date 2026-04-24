import Foundation

final class DeleteAccountViewModel {
    var onStateChange: ((DeleteAccountViewState) -> Void)?

    private let authService: AuthService
    private let tokenStore: TokenStore

    init(authService: AuthService, tokenStore: TokenStore) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    func makeViewData() -> DeleteAccountViewData {
        DeleteAccountViewData(
            titleText: "Hesabımı Sil",
            warningTitleText: "Dikkat: Bu işlem geri alınamaz",
            warningBodyText: "Hesabınızı sildiğinizde tüm finansal geçmişiniz ve tanımlı verileriniz kalıcı olarak sistemlerimizden kaldırılacaktır.",
            deletedItemsTitleText: "SİLİNECEK VERİLER",
            deletedItems: [
                DeleteAccountDeletedItem(title: "Kişisel Bilgiler", iconName: "person"),
                DeleteAccountDeletedItem(title: "Transfer Geçmişi", iconName: "arrow.left.arrow.right"),
                DeleteAccountDeletedItem(title: "Yatırım Verileri", iconName: "chart.line.downtrend.xyaxis"),
                DeleteAccountDeletedItem(title: "Uygulama Ayarları", iconName: "gearshape")
            ],
            securityTitleText: "Güvenlik Doğrulaması",
            confirmationText: "Hesabımın silinmesi sonucunda tüm haklarımdan feragat ettiğimi onaylıyorum.",
            deleteButtonTitleText: "Hesabımı Kalıcı Olarak Sil",
            cancelButtonTitleText: "Vazgeç"
        )
    }

    @MainActor
    func deleteAccount(password: String) async {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPassword.isEmpty else {
            onStateChange?(.failure("Lütfen mevcut şifrenizi girin."))
            return
        }

        onStateChange?(.loading)

        do {
            let response = try await authService.deleteAccount(request: DeleteAccountRequest(password: trimmedPassword))
            try tokenStore.clearTokens()
            onStateChange?(.deleted(response.message))
        } catch {
            onStateChange?(.failure("Hesap silinemedi. Lütfen bilgilerinizi kontrol edip tekrar deneyin."))
        }
    }
}
