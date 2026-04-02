import Foundation

// kategoriler için 
struct WalletTransactionResponse: Decodable {
    let id: String
    let amount: Decimal
    let transactionTime: String
    let category: Int
    let description: String
    let isIncoming: Bool
}
