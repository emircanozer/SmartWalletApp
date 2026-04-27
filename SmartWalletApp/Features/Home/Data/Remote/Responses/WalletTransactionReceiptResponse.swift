import Foundation

struct WalletTransactionReceiptResponse: Decodable {
    let referenceNumber: String
    let amount: Decimal
    let description: String
    let transactionDate: String
    let category: String
    let senderName: String
    let senderIban: String
    let receiverName: String
    let receiverIban: String
    let isIncoming: Bool
}
