import Foundation

enum TransactionsPresentationMapper {
    static func mapTransactions(_ transactions: [WalletTransactionResponse]) -> [DashboardTransaction] {
        AppTransactionPresentationMapper.mapDashboardTransactions(transactions)
    }

    static func makeViewData(
        filteredTransactions: [DashboardTransaction],
        selectedFilter: TransactionsFilterType
    ) -> TransactionsListViewData {
        let totalAmount = filteredTransactions.reduce(Decimal.zero) { $0 + $1.amount }
        let summary = summaryState(for: selectedFilter)

        return TransactionsListViewData(
            transactions: filteredTransactions,
            selectedFilter: selectedFilter,
            summaryTitle: summary.title,
            summaryAmountText: amount(totalAmount, isPositive: summary.isPositive, showsPrefix: summary.showsPrefix),
            summaryIsPositive: summary.isPositive,
            summaryShowsPrefix: summary.showsPrefix
        )
    }

    private static func amount(_ amount: Decimal, isPositive: Bool, showsPrefix: Bool) -> String {
        let prefix = showsPrefix ? (isPositive ? "+" : "-") : ""
        return AppNumberTextFormatter.prefixedLira(amount, prefix: prefix)
    }

    private static func summaryState(for filter: TransactionsFilterType) -> (title: String, isPositive: Bool, showsPrefix: Bool) {
        switch filter {
        case .all:
            return ("TOPLAM HAREKET", true, false)
        case .income:
            return ("TOPLAM GELİR", true, true)
        case .expense:
            return ("TOPLAM GİDER", false, true)
        }
    }
}
