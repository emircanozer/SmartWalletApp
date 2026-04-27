import Foundation
import UIKit

enum TransferReceiptsPresentationMapper {
    static func sortTransactions(_ transactions: [WalletTransactionResponse]) -> [WalletTransactionResponse] {
        transactions.sorted {
            AppDateTextFormatter.parseServerDate($0.transactionTime) > AppDateTextFormatter.parseServerDate($1.transactionTime)
        }
    }

    static func makeViewData(
        allTransactions: [WalletTransactionResponse],
        searchText: String,
        selectedDateFilter: TransferReceiptsDateFilter,
        selectedTypeFilter: TransferReceiptsTypeFilter
    ) -> TransferReceiptsViewData {
        let items = filteredTransactions(
            allTransactions: allTransactions,
            searchText: searchText,
            selectedDateFilter: selectedDateFilter,
            selectedTypeFilter: selectedTypeFilter
        ).map(mapItem)

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

    private static func filteredTransactions(
        allTransactions: [WalletTransactionResponse],
        searchText: String,
        selectedDateFilter: TransferReceiptsDateFilter,
        selectedTypeFilter: TransferReceiptsTypeFilter
    ) -> [WalletTransactionResponse] {
        allTransactions.filter { transaction in
            matchesDateFilter(transaction, selectedDateFilter: selectedDateFilter)
                && matchesTypeFilter(transaction, selectedTypeFilter: selectedTypeFilter)
                && matchesSearch(transaction, searchText: searchText)
        }
    }

    private static func matchesDateFilter(_ transaction: WalletTransactionResponse, selectedDateFilter: TransferReceiptsDateFilter) -> Bool {
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

    private static func matchesTypeFilter(_ transaction: WalletTransactionResponse, selectedTypeFilter: TransferReceiptsTypeFilter) -> Bool {
        switch selectedTypeFilter {
        case .all:
            return true
        case .incoming:
            return transaction.isIncoming
        case .outgoing:
            return !transaction.isIncoming
        }
    }

    private static func matchesSearch(_ transaction: WalletTransactionResponse, searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        let category = TransactionCategory(backendValue: transaction.category)
        let normalizedSearch = searchText.lowercased()
        let title = category.title.lowercased()
        let subtitle = normalizedSubtitle(for: transaction, category: category).lowercased()
        return title.contains(normalizedSearch) || subtitle.contains(normalizedSearch)
    }

    private static func mapItem(_ transaction: WalletTransactionResponse) -> TransferReceiptsItemViewData {
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

    private static func normalizedSubtitle(for transaction: WalletTransactionResponse, category: TransactionCategory) -> String {
        AppStringTextFormatter.normalizedOptionalText(
            transaction.description,
            emptyFallback: category.badgeTitle(isIncome: transaction.isIncoming)
        )
    }
}
