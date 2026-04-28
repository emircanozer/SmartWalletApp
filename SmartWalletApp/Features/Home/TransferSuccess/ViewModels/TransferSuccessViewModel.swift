import Foundation

enum TransferSuccessViewState {
    case loaded(TransferSuccessViewData)
}

struct TransferSuccessViewData {
    let titleText: String
    let subtitleText: String
    let transactionDateText: String
    let referenceNumberText: String
}

final class TransferSuccessViewModel {
    var onStateChange: ((TransferSuccessViewState) -> Void)?

    private let response: WalletTransferResponse

    init(response: WalletTransferResponse) {
        self.response = response
    }

    func load() {
        onStateChange?(.loaded(makeViewData()))
    }
}

 extension TransferSuccessViewModel {
    func makeViewData() -> TransferSuccessViewData {
        TransferSuccessViewData(
            titleText: "Para Gönderildi",
            subtitleText: "\(response.receiverName) kişisine \(AppNumberTextFormatter.prefixedLira(response.amount)) transfer işlemi başarıyla gerçekleştirildi.",
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber
        )
    }
}
