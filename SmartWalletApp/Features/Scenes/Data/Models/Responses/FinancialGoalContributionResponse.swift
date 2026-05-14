import Foundation

struct FinancialGoalContributionResponse: Decodable {
    let amount: Decimal
    let contributionDate: String
}
