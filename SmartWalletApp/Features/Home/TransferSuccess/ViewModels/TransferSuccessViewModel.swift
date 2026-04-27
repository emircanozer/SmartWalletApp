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
        TransferSuccessPresentationMapper.makeViewData(from: response)
    }
}
