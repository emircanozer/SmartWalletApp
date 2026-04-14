import Foundation

struct PortfolioInvestmentHistoryResponse: Decodable {
    let transactions: [PortfolioInvestmentHistoryTransactionResponse]
    let monthlyAiSummary: String
}

struct PortfolioInvestmentHistoryTransactionResponse: Decodable {
    let assetName: String
    let transactionType: String
    let amount: Decimal
    let totalPrice: Decimal
    let date: String
}
