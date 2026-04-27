import Foundation
import UIKit

final class TransferReceiptsViewModel {
    var onStateChange: ((TransferReceiptsViewState) -> Void)?

    private let walletService: WalletService
    private var allTransactions: [WalletTransactionResponse] = []
    private var searchText = ""
    private var selectedDateFilter: TransferReceiptsDateFilter = .all
    private var selectedTypeFilter: TransferReceiptsTypeFilter = .all

    init(walletService: WalletService) {
        self.walletService = walletService
    }
}

extension TransferReceiptsViewModel {
    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let wallet = try await walletService.fetchMyWallet()
            let transactions = try await walletService.fetchTransactions(walletId: wallet.id)
            allTransactions = TransferReceiptsPresentationMapper.sortTransactions(transactions)
            emitLoadedState()
        } catch {
            onStateChange?(.failure("Dekont geçmişi alınamadı. Lütfen tekrar deneyin."))
        }
    }

    func updateSearchText(_ text: String) {
        searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        emitLoadedState()
    }

    func updateDateFilter(_ filter: TransferReceiptsDateFilter) {
        selectedDateFilter = filter
        emitLoadedState()
    }

    func updateTypeFilter(_ filter: TransferReceiptsTypeFilter) {
        selectedTypeFilter = filter
        emitLoadedState()
    }

    private func emitLoadedState() {
        onStateChange?(.loaded(makeViewData()))
    }

    private func makeViewData() -> TransferReceiptsViewData {
        TransferReceiptsPresentationMapper.makeViewData(
            allTransactions: allTransactions,
            searchText: searchText,
            selectedDateFilter: selectedDateFilter,
            selectedTypeFilter: selectedTypeFilter
        )
    }
}
