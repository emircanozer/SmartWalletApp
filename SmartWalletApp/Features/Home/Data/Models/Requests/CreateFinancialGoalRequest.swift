import Foundation

struct CreateFinancialGoalRequest: Encodable {
    let title: String
    let targetAmount: Decimal
    let targetDate: Date

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case targetAmount = "TargetAmount"
        case targetDate = "TargetDate"
    }
}
