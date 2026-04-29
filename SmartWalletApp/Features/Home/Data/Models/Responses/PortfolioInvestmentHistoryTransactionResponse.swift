import Foundation

struct PortfolioInvestmentHistoryTransactionResponse: Decodable {
    let assetName: String
    let transactionType: String
    let amount: Decimal
    let totalPrice: Decimal
    let date: String
}
