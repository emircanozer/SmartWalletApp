import UIKit

enum InvestmentHistoryViewState {
    case idle
    case loading
    case loaded(InvestmentHistoryViewData)
    case aiSummaryLoading
    case aiSummaryLoaded(InvestmentHistorySummaryViewData)
    case aiSummaryFailed(String)
    case failure(String)
}

enum InvestmentHistoryFilter: CaseIterable {
    case all
    case buy
    case sell

    var title: String {
        switch self {
        case .all:
            return "Tümü"
        case .buy:
            return "Alım"
        case .sell:
            return "Satım"
        }
    }
}

struct InvestmentHistoryTransactionItem {
    let assetName: String
    let amountText: String
    let totalPriceText: String
    let dateText: String
    let transactionTypeText: String
    let transactionTypeColor: UIColor
    let isBuy: Bool
}

struct InvestmentHistoryViewData {
    let titleText: String
    let selectedFilter: InvestmentHistoryFilter
    let items: [InvestmentHistoryTransactionItem]
    let emptyMessageText: String?
}

struct InvestmentHistorySummaryViewData {
    let titleText: String
    let bodyText: String
}
