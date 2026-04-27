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
        TransactionsPresentationMapper.mapTransactions(transactions)
    }
}

 extension TransactionsListViewModel {
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
        TransactionsPresentationMapper.makeViewData(
            filteredTransactions: filteredTransactions,
            selectedFilter: selectedFilter
        )
    }
}
