import Foundation

enum TransferSuccessPresentationMapper {
    static func makeViewData(from response: WalletTransferResponse) -> TransferSuccessViewData {
        TransferSuccessViewData(
            titleText: "Para Gönderildi",
            subtitleText: "\(response.receiverName) kişisine \(AppNumberTextFormatter.prefixedLira(response.amount)) transfer işlemi başarıyla gerçekleştirildi.",
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber
        )
    }
}
