import Foundation

// chip butonlar için
enum TransactionsFilterType: CaseIterable { // enum case’lerini liste yapar
    case all
    case income
    case expense

    var title: String {
        switch self {
        case .all:
            return "Tümü"
        case .income:
            return "Gelir"
        case .expense:
            return "Gider"
        }
    }
}

struct TransactionsListViewData {
    let transactions: [DashboardTransaction]
    let selectedFilter: TransactionsFilterType
    let summaryTitle: String
    let summaryAmountText: String
    let summaryIsPositive: Bool
    let summaryShowsPrefix: Bool
}

final class TransactionsListViewModel {
    var onTransactionsChange: ((TransactionsListViewData) -> Void)?
    var onError: ((String) -> Void)?

    private let reloadTransactions: (() async throws -> [DashboardTransaction])?
    private var allTransactions: [DashboardTransaction]
    private(set) var filteredTransactions: [DashboardTransaction]
    private var selectedFilter: TransactionsFilterType = .all
    private var startDate: Date
    private var endDate: Date

    init(
        transactions: [DashboardTransaction],
        reloadTransactions: (() async throws -> [DashboardTransaction])? = nil
    ) {
        let sortedTransactions = transactions.sorted { $0.date > $1.date }
        self.allTransactions = sortedTransactions
        self.filteredTransactions = sortedTransactions
        self.reloadTransactions = reloadTransactions
        self.endDate = Date()
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    }

    func applyFilter(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        refreshFilteredTransactions()
    }

    func applyFilterType(_ filterType: TransactionsFilterType) {
        selectedFilter = filterType
        refreshFilteredTransactions()
    }

    func resetFilter() {
        endDate = Date()
        startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        selectedFilter = .all
        refreshFilteredTransactions()
    }

    func loadInitialState() {
        refreshFilteredTransactions()
    }

    @MainActor
    func refreshTransactions() async {
        guard let reloadTransactions else {
            refreshFilteredTransactions()
            return
        }

        do {
            let transactions = try await reloadTransactions()
            allTransactions = transactions.sorted { $0.date > $1.date }
            refreshFilteredTransactions()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    static func mapTransactions(_ transactions: [WalletTransactionResponse]) -> [DashboardTransaction] {
        transactions.map { transaction in
            let category = TransactionCategory(backendValue: transaction.category)
            let badgeTitle = category.badgeTitle(isIncome: transaction.isIncoming)
            let amountPrefix = transaction.isIncoming ? "+" : "-"
            let amountText = "\(amountPrefix)\(formatDisplayAmount(transaction.amount))"
            let date = parseDate(transaction.transactionTime)
            let trimmedDescription = transaction.description.trimmingCharacters(in: .whitespacesAndNewlines)

            return DashboardTransaction(
                id: transaction.id,
                title: category.title,
                subtitle: trimmedDescription.isEmpty ? badgeTitle : trimmedDescription,
                date: date,
                dateText: formatDate(date),
                categoryBadgeText: badgeTitle,
                amount: transaction.amount,
                amountText: amountText,
                isIncome: transaction.isIncoming,
                category: category
            )
        }
    }
}

private extension TransactionsListViewModel {
    func refreshFilteredTransactions() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: startDate)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate

        filteredTransactions = allTransactions.filter {
            $0.date >= startOfDay
                && $0.date <= endOfDay
                && matchesSelectedFilter($0)
        }

        onTransactionsChange?(makeViewData())
    }

    func matchesSelectedFilter(_ transaction: DashboardTransaction) -> Bool {
        switch selectedFilter {
        case .all:
            return true
        case .income:
            return transaction.isIncome
        case .expense:
            return !transaction.isIncome
        }
    }

    func makeViewData() -> TransactionsListViewData {
        let totalAmount = filteredTransactions.reduce(Decimal.zero) { partialResult, transaction in
            partialResult + transaction.amount
        }

        let summaryTitle: String
        let summaryIsPositive: Bool
        let summaryShowsPrefix: Bool

        switch selectedFilter {
        case .all:
            summaryTitle = "TOPLAM HAREKET"
            summaryIsPositive = true
            summaryShowsPrefix = false
        case .income:
            summaryTitle = "TOPLAM GELİR"
            summaryIsPositive = true
            summaryShowsPrefix = true
        case .expense:
            summaryTitle = "TOPLAM GİDER"
            summaryIsPositive = false
            summaryShowsPrefix = true
        }

        return TransactionsListViewData(
            transactions: filteredTransactions,
            selectedFilter: selectedFilter,
            summaryTitle: summaryTitle,
            summaryAmountText: formatAmount(
                totalAmount,
                isPositive: summaryIsPositive,
                showsPrefix: summaryShowsPrefix
            ),
            summaryIsPositive: summaryIsPositive,
            summaryShowsPrefix: summaryShowsPrefix
        )
    }

    func formatAmount(_ amount: Decimal, isPositive: Bool, showsPrefix: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        let prefix = showsPrefix ? (isPositive ? "+" : "-") : ""
        let value = formatter.string(for: amount) ?? "0"
        return "\(prefix)₺\(value)"
    }

    static func formatDisplayAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        let formatted = formatter.string(for: amount) ?? "0"
        return "₺\(formatted)"
    }

    static func parseDate(_ rawValue: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]

        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = TimeZone.current
        localFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"

        let shortFractionFormatter = DateFormatter()
        shortFractionFormatter.locale = Locale(identifier: "en_US_POSIX")
        shortFractionFormatter.timeZone = TimeZone.current
        shortFractionFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        let plainFormatter = DateFormatter()
        plainFormatter.locale = Locale(identifier: "en_US_POSIX")
        plainFormatter.timeZone = TimeZone.current
        plainFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return formatter.date(from: rawValue)
            ?? fallbackFormatter.date(from: rawValue)
            ?? localFormatter.date(from: rawValue)
            ?? shortFractionFormatter.date(from: rawValue)
            ?? plainFormatter.date(from: rawValue)
            ?? Date()
    }

    static func formatDate(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "tr_TR")
        outputFormatter.dateFormat = "d MMMM yyyy, HH.mm"
        return outputFormatter.string(from: date)
    }
}
