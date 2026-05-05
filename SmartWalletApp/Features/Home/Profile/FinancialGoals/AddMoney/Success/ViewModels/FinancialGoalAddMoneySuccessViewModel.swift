import Foundation
import UIKit

final class FinancialGoalAddMoneySuccessViewModel {
    private let context: FinancialGoalAddMoneySuccessContext

    init(context: FinancialGoalAddMoneySuccessContext) {
        self.context = context
    }
}

extension FinancialGoalAddMoneySuccessViewModel {
    var updatedGoal: FinancialGoalRecord {
        context.updatedGoal
    }

    func makeViewData() -> FinancialGoalAddMoneySuccessViewData {
        let updatedGoal = context.updatedGoal
        let progress = updatedGoal.targetAmount > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: updatedGoal.savedAmount / updatedGoal.targetAmount).doubleValue))
            : 0
        let completionPercent = Int((progress * 100).rounded())
        let remainingAmount = max(updatedGoal.targetAmount - updatedGoal.savedAmount, .zero)

        return FinancialGoalAddMoneySuccessViewData(
            heroImageName: "background",
            titleText: "Hedefe Para Eklendi",
            subtitleText: context.message,
            previousAmountTitleText: "ONCEKI BIRIKIM",
            previousAmountValueText: AppNumberTextFormatter.prefixedLira(context.originalGoal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            addedAmountTitleText: "EKLENEN TUTAR",
            addedAmountValueText: AppNumberTextFormatter.prefixedLira(context.addedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            updatedAmountTitleText: "YENI TOPLAM",
            updatedAmountValueText: AppNumberTextFormatter.prefixedLira(updatedGoal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            returnButtonTitleText: "Hedefe Don",
            goalTitleText: updatedGoal.title,
            deadlineText: "Hedef Tarihi: \(AppDateTextFormatter.string(from: updatedGoal.deadline, style: .financialGoalDayMonth))",
            badgeText: "%\(completionPercent)",
            progressText: "%\(completionPercent) tamamlandi",
            progressAmountText: "\(AppNumberTextFormatter.prefixedLira(updatedGoal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0)) / \(AppNumberTextFormatter.prefixedLira(updatedGoal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0))",
            remainingAmountText: "\(AppNumberTextFormatter.prefixedLira(remainingAmount, minimumFractionDigits: 0, maximumFractionDigits: 0)) kaldi",
            progress: progress,
            iconName: updatedGoal.iconName,
            iconTintColor: updatedGoal.iconTintColor,
            iconBackgroundColor: updatedGoal.iconBackgroundColor
        )
    }
}
