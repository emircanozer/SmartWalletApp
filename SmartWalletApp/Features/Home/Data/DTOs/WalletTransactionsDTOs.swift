import Foundation

// kategoriler için backenden gelen ham response modeli 
struct WalletTransactionResponse: Decodable {
    let id: String
    let amount: Decimal
    let transactionTime: String
    let category: Int
    let description: String
    let isIncoming: Bool
}
