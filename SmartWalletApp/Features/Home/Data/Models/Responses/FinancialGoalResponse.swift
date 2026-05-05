import Foundation

struct FinancialGoalResponse: Decodable {
    let id: UUID
    let title: String
    let targetAmount: Decimal
    let currentAmount: Decimal
    let targetDate: String
    let completionPercentage: Decimal
    let remainingAmount: Decimal
    let daysRemaining: Int
}
