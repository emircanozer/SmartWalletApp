import Foundation

enum AppTransactionPresentationMapper {
    static func mapDashboardTransactions(_ transactions: [WalletTransactionResponse]) -> [DashboardTransaction] {
        transactions.map(mapDashboardTransaction)
    }

    static func mapDashboardTransaction(_ transaction: WalletTransactionResponse) -> DashboardTransaction {
        let category = TransactionCategory(backendValue: transaction.category)
        let badgeTitle = category.badgeTitle(isIncome: transaction.isIncoming)
        let amountPrefix = transaction.isIncoming ? "+" : "-"
        let date = AppDateTextFormatter.parseServerDate(transaction.transactionTime)
        let subtitle = AppStringTextFormatter.normalizedOptionalText(
            transaction.description,
            emptyFallback: badgeTitle
        )

        return DashboardTransaction(
            id: transaction.id,
            title: category.title,
            subtitle: subtitle,
            date: date,
            dateText: AppDateTextFormatter.string(from: date, style: .transactionDateTime),
            categoryBadgeText: badgeTitle,
            amount: transaction.amount,
            amountText: "\(amountPrefix)\(AppNumberTextFormatter.prefixedLira(transaction.amount))",
            isIncome: transaction.isIncoming,
            category: category
        )
    }
}
