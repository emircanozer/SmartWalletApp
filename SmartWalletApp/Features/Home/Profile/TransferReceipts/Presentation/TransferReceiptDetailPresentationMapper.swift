import Foundation

enum TransferReceiptDetailPresentationMapper {
    static func makeViewData(from response: WalletTransactionReceiptResponse) -> TransferReceiptViewData {
        let counterpartyIBAN = response.isIncoming ? response.senderIban : response.receiverIban

        return TransferReceiptViewData(
            senderNameText: response.senderName,
            receiverNameText: response.receiverName,
            ibanText: AppStringTextFormatter.spacedIBAN(counterpartyIBAN),
            amountText: AppNumberTextFormatter.prefixedLira(response.amount),
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber,
            categoryTitleText: AppStringTextFormatter.prettifiedCategory(response.category),
            noteText: AppStringTextFormatter.normalizedOptionalText(response.description)
        )
    }
}
