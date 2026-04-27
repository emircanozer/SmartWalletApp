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
            allTransactions = transactions.sorted {
                AppDateTextFormatter.parseServerDate($0.transactionTime) > AppDateTextFormatter.parseServerDate($1.transactionTime)
            }
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
        let items = filteredTransactions().map(mapItem)
        return TransferReceiptsViewData(
            titleText: "Dekont Geçmişi",
            descriptionText: "Geçmiş işlemlere ait dekontları görüntüleyin, filtreleyin ve inceleyin.",
            searchPlaceholderText: "İşlem veya kişi ara...",
            selectedDateFilterTitleText: selectedDateFilter.title,
            selectedTypeFilterTitleText: selectedTypeFilter.title,
            sectionTitleText: "YAKIN ZAMANDAKİ İŞLEMLER",
            items: items,
            emptyMessageText: items.isEmpty ? "Filtreye uygun dekont bulunamadı." : nil
        )
    }

    private func filteredTransactions() -> [WalletTransactionResponse] {
        allTransactions.filter { transaction in
            matchesDateFilter(transaction)
                && matchesTypeFilter(transaction)
                && matchesSearch(transaction)
        }
    }

    private func matchesDateFilter(_ transaction: WalletTransactionResponse) -> Bool {
        let date = AppDateTextFormatter.parseServerDate(transaction.transactionTime)
        let calendar = Calendar.current
        let now = Date()

        switch selectedDateFilter {
        case .all:
            return true
        case .last7Days:
            guard let start = calendar.date(byAdding: .day, value: -7, to: now) else { return true }
            return date >= start
        case .last15Days:
            guard let start = calendar.date(byAdding: .day, value: -15, to: now) else { return true }
            return date >= start
        case .last30Days:
            guard let start = calendar.date(byAdding: .day, value: -30, to: now) else { return true }
            return date >= start
        case .last3Months:
            guard let start = calendar.date(byAdding: .month, value: -3, to: now) else { return true }
            return date >= start
        case .last6Months:
            guard let start = calendar.date(byAdding: .month, value: -6, to: now) else { return true }
            return date >= start
        }
    }

    private func matchesTypeFilter(_ transaction: WalletTransactionResponse) -> Bool {
        switch selectedTypeFilter {
        case .all:
            return true
        case .incoming:
            return transaction.isIncoming
        case .outgoing:
            return !transaction.isIncoming
        }
    }

    private func matchesSearch(_ transaction: WalletTransactionResponse) -> Bool {
        guard !searchText.isEmpty else { return true }
        let category = TransactionCategory(backendValue: transaction.category)
        let normalizedSearch = searchText.lowercased()
        let title = category.title.lowercased()
        let subtitle = normalizedSubtitle(for: transaction, category: category).lowercased()
        return title.contains(normalizedSearch) || subtitle.contains(normalizedSearch)
    }

    private func mapItem(_ transaction: WalletTransactionResponse) -> TransferReceiptsItemViewData {
        let category = TransactionCategory(backendValue: transaction.category)
        let isIncoming = transaction.isIncoming
        let amountPrefix = isIncoming ? "+" : "-"
        return TransferReceiptsItemViewData(
            id: transaction.id,
            iconName: category.iconName,
            iconTintColor: category.iconTintColor,
            iconBackgroundColor: category.iconBackgroundColor,
            typeText: isIncoming ? "GELEN TRANSFER" : category.title.uppercased(),
            titleText: normalizedSubtitle(for: transaction, category: category),
            amountText: "\(amountPrefix)\(AppNumberTextFormatter.prefixedLira(transaction.amount))",
            amountColor: isIncoming ? AppColor.success : AppColor.danger,
            dateText: AppDateTextFormatter.string(from: transaction.transactionTime, style: .transactionDateTime),
            detailButtonTitleText: "Dekont Detayı"
        )
    }

    private func normalizedSubtitle(for transaction: WalletTransactionResponse, category: TransactionCategory) -> String {
        let trimmed = transaction.description.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? category.badgeTitle(isIncome: transaction.isIncoming) : trimmed
    }
}
