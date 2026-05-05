import Foundation

struct AddFinancialGoalFundsRequest: Encodable {
    let goalId: UUID
    let amount: Decimal
}
