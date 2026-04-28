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
            ibanText: AppStringTextFormatter.formattedIBAN(counterpartyIBAN),
            amountText: AppNumberTextFormatter.prefixedLira(response.amount),
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber,
            categoryTitleText: AppStringTextFormatter.prettifiedCategory(response.category),
            noteText: AppStringTextFormatter.normalizedOptionalText(response.description)
        )
    }
}
