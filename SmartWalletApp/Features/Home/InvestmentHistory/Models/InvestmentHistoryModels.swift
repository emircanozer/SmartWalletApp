import UIKit

enum InvestmentHistoryViewState {
    case idle
    case loading
    case loaded(InvestmentHistoryViewData)
    case failure(String)
}

struct InvestmentHistoryTransactionItem {
    let assetName: String
    let amountText: String
    let totalPriceText: String
    let dateText: String
    let transactionTypeText: String
    let transactionTypeColor: UIColor
}

struct InvestmentHistoryViewData {
    let titleText: String
    let items: [InvestmentHistoryTransactionItem]
    let monthlySummaryTitleText: String
    let monthlySummaryBodyText: String
    let emptyMessageText: String?
}
