import Foundation
import UIKit

struct FinancialGoalDetailViewData {
    let navigationTitleText: String
    let goalTitleText: String
    let deadlineText: String
    let badgeText: String
    let savedTitleText: String
    let savedAmountText: String
    let targetAmountText: String
    let remainingTitleText: String
    let remainingAmountText: String
    let progressText: String
    let progress: CGFloat
    let daysRemainingText: String
    let addMoneyButtonTitleText: String
    let editButtonTitleText: String
    let aiSuggestionTitleText: String
    let aiSuggestionBodyText: String
    let historySectionTitleText: String
    let viewAllTitleText: String
    let historyItems: [FinancialGoalContributionItemViewData]
}

struct FinancialGoalContributionItemViewData {
    let titleText: String
    let dateText: String
}
