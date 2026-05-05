import Foundation

struct CreateFinancialGoalResponse: Decodable {
    let success: Bool
    let goalId: UUID
    let message: String
}
