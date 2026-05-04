import Foundation
import UIKit

final class FinancialGoalDetailViewModel {
    private let goal: FinancialGoalRecord

    init(goal: FinancialGoalRecord) {
        self.goal = goal
    }
}

extension FinancialGoalDetailViewModel {
    func makeViewData() -> FinancialGoalDetailViewData {
        let progress = goal.targetAmount > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: goal.savedAmount / goal.targetAmount).doubleValue))
            : 0
        let completionPercent = Int((progress * 100).rounded())
        let remainingAmount = max(goal.targetAmount - goal.savedAmount, .zero)
        let monthlyGap = max(remainingAmount / Decimal(3), .zero)

        return FinancialGoalDetailViewData(
            navigationTitleText: "Hedef Detayi",
            goalTitleText: goal.title,
            deadlineText: "Hedef Tarihi: \(Self.goalDateFormatter.string(from: goal.deadline))",
            badgeText: "%\(completionPercent)",
            savedTitleText: "BIRIKEN",
            savedAmountText: AppNumberTextFormatter.prefixedLira(goal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            targetAmountText: "/ \(AppNumberTextFormatter.prefixedLira(goal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0))",
            remainingTitleText: "KALAN",
            remainingAmountText: "\(AppNumberTextFormatter.prefixedLira(remainingAmount, minimumFractionDigits: 0, maximumFractionDigits: 0)) kaldi",
            progressText: "%\(completionPercent) tamamlandi",
            progress: progress,
            daysRemainingText: "Kalan gun: \(remainingDaysText())",
            addMoneyButtonTitleText: "Para Ekle",
            editButtonTitleText: "Duzenle",
            aiSuggestionTitleText: "AI Onerisi",
            aiSuggestionBodyText: "Bu hedef icin mevcut birikim seviyen yetersiz. Hedefe zamaninda ulasmak icin aylik yaklasik \(AppNumberTextFormatter.prefixedLira(monthlyGap, minimumFractionDigits: 0, maximumFractionDigits: 0)) birikim yapman onerilir. Alternatif olarak hedef tarihini guncelleyebilirsin.",
            historySectionTitleText: "Katki Gecmisi",
            viewAllTitleText: "Tumunu Gor",
            historyItems: makeHistoryItems()
        )
    }

    private func remainingDaysText() -> String {
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: goal.deadline)).day ?? 0
        return "\(max(days, 0)) gun"
    }

    private func makeHistoryItems() -> [FinancialGoalContributionItemViewData] {
        let contributions = mockContributionAmounts()
        return contributions.enumerated().map { index, amount in
            let date = Calendar.current.date(byAdding: .day, value: -((index * 7) + 5), to: Date()) ?? Date()
            return FinancialGoalContributionItemViewData(
                titleText: "+\(AppNumberTextFormatter.prefixedLira(amount, minimumFractionDigits: 0, maximumFractionDigits: 0)) eklendi",
                dateText: Self.historyDateFormatter.string(from: date)
            )
        }
    }

    private func mockContributionAmounts() -> [Decimal] {
        if goal.savedAmount == .zero {
            return [Decimal(2_000), Decimal(1_500)]
        }

        let first = max(goal.savedAmount / Decimal(3), Decimal(1_000))
        let second = max(goal.savedAmount / Decimal(2), Decimal(2_000))
        return [first, second]
    }

    private static let goalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()

    private static let historyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
}
