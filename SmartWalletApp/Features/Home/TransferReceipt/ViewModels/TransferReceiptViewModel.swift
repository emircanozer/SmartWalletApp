import Foundation

enum TransferReceiptViewState {
    case idle
    case loading
    case loaded(TransferReceiptViewData)
}

//ui model
struct TransferReceiptViewData {
    let senderNameText: String
    let receiverNameText: String
    let ibanText: String
    let amountText: String
    let transactionDateText: String
    let referenceNumberText: String
    let categoryTitleText: String
    let noteText: String
}

final class TransferReceiptViewModel {
    var onStateChange: ((TransferReceiptViewState) -> Void)?

    private let walletService: WalletService // servisten response çekip ui model için ek bilgi alıcaz
    private let response: WalletTransferResponse

    init(walletService: WalletService, response: WalletTransferResponse) {
        self.walletService = walletService
        self.response = response
    }

    func load() async {
        onStateChange?(.loading)

        let wallet = try? await walletService.fetchMyWallet()
        let data = makeViewData(wallet: wallet)
        onStateChange?(.loaded(data))
    }
}

// ui modeli oluşturuyoruz 
 extension TransferReceiptViewModel {
    func makeViewData(wallet: MyWalletResponse?) -> TransferReceiptViewData {
        TransferReceiptPresentationMapper.makeViewData(wallet: wallet, response: response)
    }
}
