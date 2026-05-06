import Foundation
import UIKit

@MainActor
final class FinancialGoalDetailViewModel: BaseViewModel {
    var onStateChange: ((FinancialGoalDetailViewData) -> Void)?

    private let walletService: WalletService
    private var goal: FinancialGoalRecord
    private var contributions: [FinancialGoalContributionResponse] = []

    init(walletService: WalletService, goal: FinancialGoalRecord) {
        self.walletService = walletService
        self.goal = goal
    }
}

extension FinancialGoalDetailViewModel {
    var goalRecord: FinancialGoalRecord {
        goal
    }

    func replaceGoal(with updatedGoal: FinancialGoalRecord) {
        goal = updatedGoal
    }

    func load() async {
        do {
            contributions = try await walletService.fetchFinancialGoalContributions(goalID: goal.id)
            emitState()
        } catch {
            contributions = []
            emitState()
            emitError("Katkı geçmişi alınamadı. Lütfen tekrar deneyin.")
        }
    }

    func emitState() {
        emit(makeViewData(), using: onStateChange)
    }

    func makeViewData() -> FinancialGoalDetailViewData {
        let progress = goal.targetAmount > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: goal.savedAmount / goal.targetAmount).doubleValue))
            : 0
        let completionPercent = Int((progress * 100).rounded())
        let remainingAmount = max(goal.targetAmount - goal.savedAmount, .zero)

        return FinancialGoalDetailViewData(
            navigationTitleText: "Hedef Detayı",
            goalTitleText: goal.title,
            deadlineText: "Hedef Tarihi: \(AppDateTextFormatter.string(from: goal.deadline, style: .financialGoalDayMonth))",
            badgeText: "%\(completionPercent)",
            savedTitleText: "BİRİKEN",
            savedAmountText: AppNumberTextFormatter.prefixedLira(goal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            targetAmountText: "/ \(AppNumberTextFormatter.prefixedLira(goal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0))",
            remainingTitleText: "KALAN",
            remainingAmountText: "\(AppNumberTextFormatter.prefixedLira(remainingAmount, minimumFractionDigits: 0, maximumFractionDigits: 0)) kaldı",
            progressText: "%\(completionPercent) tamamlandı",
            progress: progress,
            daysRemainingText: "Kalan gün: \(remainingDaysText())",
            addMoneyButtonTitleText: "Para Ekle",
            editButtonTitleText: "Düzenle",
            historySectionTitleText: "Katkı Geçmişi",
            historyItems: makeHistoryItems()
        )
    }

    private func remainingDaysText() -> String {
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: goal.deadline)).day ?? 0
        return "\(max(days, 0)) gün"
    }

    private func makeHistoryItems() -> [FinancialGoalContributionItemViewData] {
        contributions.map { contribution in
            return FinancialGoalContributionItemViewData(
                titleText: "+\(AppNumberTextFormatter.prefixedLira(contribution.amount, minimumFractionDigits: 0, maximumFractionDigits: 0)) eklendi",
                dateText: AppDateTextFormatter.string(
                    from: AppDateTextFormatter.parseServerDate(contribution.contributionDate),
                    style: .financialGoalDayMonth
                )
            )
        }
    }
}
