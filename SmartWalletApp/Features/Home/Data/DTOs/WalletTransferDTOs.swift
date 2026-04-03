import Foundation

struct WalletTransferRequest: Encodable {
    let receiverIban: String
    let amount: Decimal
    let description: String
    let category: Int
}

struct WalletTransferResponse: Decodable {
    let success: Bool
    let message: String
    let transactionID: String
    let referenceNumber: String
    let receiverName: String
    let amount: Decimal
    let transactionDate: String
    let description: String
    let category: Int

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case transactionID = "transactionId"
        case transactionIDUpper = "transactionID"
        case referenceNumber
        case referenceNo
        case receiverName
        case amount
        case transactionDate
        case description
        case category
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        message = try container.decode(String.self, forKey: .message)
        transactionID =
            try container.decodeIfPresent(String.self, forKey: .transactionID)
            ?? container.decodeIfPresent(String.self, forKey: .transactionIDUpper)
            ?? ""
        referenceNumber =
            try container.decodeIfPresent(String.self, forKey: .referenceNumber)
            ?? container.decodeIfPresent(String.self, forKey: .referenceNo)
            ?? ""
        receiverName = try container.decode(String.self, forKey: .receiverName)
        amount = try container.decode(Decimal.self, forKey: .amount)
        transactionDate = try container.decode(String.self, forKey: .transactionDate)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(Int.self, forKey: .category)
    }
}
