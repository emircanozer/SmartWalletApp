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
        TransferReceiptDetailPresentationMapper.makeViewData(from: response)
    }
}
