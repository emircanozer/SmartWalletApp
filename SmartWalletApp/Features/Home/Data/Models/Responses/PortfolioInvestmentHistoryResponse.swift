import Foundation

struct PortfolioInvestmentHistoryResponse: Decodable {
    let transactions: [PortfolioInvestmentHistoryTransactionResponse]
    let monthlyAiSummary: String?
}
