import Foundation
import UIKit

struct FinancialGoalAddMoneyViewData {
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
    let amountFieldTitleText: String
    let amountPlaceholderText: String
    let quickAmounts: [FinancialGoalAddMoneyQuickAmountViewData]
    let noteTitleText: String
    let notePlaceholderText: String
    let infoText: String
}

struct FinancialGoalAddMoneyQuickAmountViewData {
    let amount: Decimal
    let titleText: String
}

struct FinancialGoalAddMoneyFormState {
    let amountText: String
    let selectedQuickAmount: Decimal?
    let projectedSavingsText: String
    let remainingAfterAddText: String
    let confirmButtonTitleText: String
    let isConfirmEnabled: Bool
}

struct FinancialGoalAddMoneySuccessContext {
    let originalGoal: FinancialGoalRecord
    let updatedGoal: FinancialGoalRecord
    let addedAmount: Decimal
}
