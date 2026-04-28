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
        TransferReceiptViewData(
            senderNameText: wallet?.fullName ?? "-",
            receiverNameText: response.receiverName,
            ibanText: AppStringTextFormatter.formattedIBAN(response.receiverIban.isEmpty ? wallet?.iban ?? "" : response.receiverIban),
            amountText: AppNumberTextFormatter.prefixedLira(response.amount),
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber,
            categoryTitleText: categoryTitle(for: response.category),
            noteText: AppStringTextFormatter.normalizedOptionalText(response.description)
        )
    }

    func categoryTitle(for backendValue: Int) -> String {
        switch backendValue {
        case 1:
            return "Market"
        case 2:
            return "Yemek"
        case 3:
            return "Fatura"
        case 4:
            return "Eğlence"
        case 5:
            return "Eğitim"
        case 6:
            return "Sağlık"
        case 7:
            return "Para Transferi"
        case 8:
            return "Kira Ödemesi"
        default:
            return "Diğer"
        }
    }
}
