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
            ibanText: formatIBAN(response.receiverIban.isEmpty ? wallet?.iban ?? "" : response.receiverIban),
            amountText: formatAmount(response.amount),
            transactionDateText: formatDate(response.transactionDate),
            referenceNumberText: response.referenceNumber,
            categoryTitleText: categoryTitle(for: response.category),
            noteText: normalizedNoteText(response.description)
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
        default:
            return "Diğer"
        }
    }

    func normalizedNoteText(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "-" : trimmed
    }

    func formatAmount(_ amount: Decimal) -> String {
        AppNumberTextFormatter.prefixedLira(amount)
    }

    func formatDate(_ rawValue: String) -> String {
        AppDateTextFormatter.string(from: rawValue, style: .transactionDateTime)
    }

    func formatIBAN(_ iban: String) -> String {
        let trimmed = iban.replacingOccurrences(of: " ", with: "")
        guard !trimmed.isEmpty else { return "-" }

        var chunks: [String] = []
        var index = trimmed.startIndex
        while index < trimmed.endIndex {
            let nextIndex = trimmed.index(index, offsetBy: 4, limitedBy: trimmed.endIndex) ?? trimmed.endIndex
            chunks.append(String(trimmed[index..<nextIndex]))
            index = nextIndex
        }
        return chunks.joined(separator: " ")
    }
}
