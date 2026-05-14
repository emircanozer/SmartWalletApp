import Foundation

struct UpdateFinancialGoalRequest: Encodable {
    let title: String
    let targetAmount: Decimal
    let targetDate: Date
}
