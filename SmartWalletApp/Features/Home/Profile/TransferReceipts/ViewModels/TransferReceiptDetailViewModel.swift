import Foundation

enum TransferReceiptDetailViewState {
    case idle
    case loading
    case loaded(TransferReceiptViewData)
    case failure(String)
}

final class TransferReceiptDetailViewModel {
    var onStateChange: ((TransferReceiptDetailViewState) -> Void)?

    private let walletService: WalletService
    private let transactionId: String

    init(walletService: WalletService, transactionId: String) {
        self.walletService = walletService
        self.transactionId = transactionId
    }
}

extension TransferReceiptDetailViewModel {
    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchReceiptDetail(transactionId: transactionId)
            let data = makeViewData(from: response)
            onStateChange?(.loaded(data))
        } catch {
            onStateChange?(.failure("Dekont detayı alınamadı. Lütfen tekrar deneyin."))
        }
    }

    private func makeViewData(from response: WalletTransactionReceiptResponse) -> TransferReceiptViewData {
        let counterpartyIBAN = response.isIncoming ? response.senderIban : response.receiverIban

        return TransferReceiptViewData(
            senderNameText: response.senderName,
            receiverNameText: response.receiverName,
            ibanText: formatIBAN(counterpartyIBAN),
            amountText: AppNumberTextFormatter.prefixedLira(response.amount),
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber,
            categoryTitleText: prettifyCategory(response.category),
            noteText: normalizedNoteText(response.description)
        )
    }

    private func normalizedNoteText(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "-" : trimmed
    }

    private func prettifyCategory(_ text: String) -> String {
        guard !text.isEmpty else { return "-" }
        return text
            .replacingOccurrences(of: "Ö", with: " Ö")
            .replacingOccurrences(of: "İ", with: " İ")
            .replacingOccurrences(of: "([a-zçğıöşü])([A-ZÇĞİÖŞÜ])", with: "$1 $2", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func formatIBAN(_ iban: String) -> String {
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
