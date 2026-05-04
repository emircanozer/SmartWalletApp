import Foundation

struct FinancialGoalResponse: Decodable {
    let id: UUID
    let title: String
    let targetAmount: Decimal
    let currentAmount: Decimal
    let targetDate: String
    let completionPercentage: Int
    let remainingAmount: Decimal
    let daysRemaining: Int
}
