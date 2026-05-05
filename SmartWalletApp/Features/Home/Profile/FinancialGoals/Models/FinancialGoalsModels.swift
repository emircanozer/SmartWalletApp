import Foundation
import UIKit

struct FinancialGoalsViewData {
    let titleText: String
    let subtitleText: String
    let totalGoalCountText: String
    let totalSavedAmountText: String
    let totalTargetAmountText: String
    let completionText: String
    let remainingAmountText: String
    let progress: CGFloat
    let sectionTitleText: String
    let items: [FinancialGoalItemViewData]
}

struct FinancialGoalItemViewData {
    let id: UUID
    let titleText: String
    let deadlineText: String
    let currentAmountText: String
    let targetAmountText: String
    let progress: CGFloat
    let iconName: String
    let iconTintColor: UIColor
    let iconBackgroundColor: UIColor
}

struct FinancialGoalDraft {
    let title: String
    let targetAmount: Decimal
    let deadline: Date
    let note: String?
}

struct FinancialGoalRecord {
    let id: UUID
    let title: String
    let targetAmount: Decimal
    let savedAmount: Decimal
    let deadline: Date
    let note: String?
    let iconName: String
    let iconTintColor: UIColor
    let iconBackgroundColor: UIColor
}
