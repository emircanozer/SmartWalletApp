import Foundation

struct WalletTransferRequest: Encodable {
    let receiverIban: String
    let amount: Decimal
    let description: String
    let category: Int
}
