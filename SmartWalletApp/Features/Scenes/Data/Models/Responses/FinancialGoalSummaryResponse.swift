import Foundation

struct FinancialGoalSummaryResponse: Decodable {
    let totalGoalCount: Int
    let totalSavedAmount: Decimal
    let totalTargetAmount: Decimal
    let completionPercentage: Decimal
}
