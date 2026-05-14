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

enum InvestmentHistoryTypeFilter: CaseIterable {
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

enum InvestmentHistoryDateFilter: CaseIterable {
    case all
    case last7Days
    case last15Days
    case last30Days
    case last3Months
    case last6Months

    var title: String {
        switch self {
        case .all:
            return "Tüm Tarihler"
        case .last7Days:
            return "Son 7 Gün"
        case .last15Days:
            return "Son 15 Gün"
        case .last30Days:
            return "Son 30 Gün"
        case .last3Months:
            return "Son 3 Ay"
        case .last6Months:
            return "Son 6 Ay"
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
    let selectedDateFilterTitleText: String
    let selectedTypeFilterTitleText: String
    let items: [InvestmentHistoryTransactionItem]
    let emptyMessageText: String?
}

struct InvestmentHistorySummaryViewData {
    let titleText: String
    let bodyText: String
}
