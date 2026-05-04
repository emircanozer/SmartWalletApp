import Foundation
import UIKit

final class FinancialGoalsViewModel {
    var onStateChange: ((FinancialGoalsViewData) -> Void)?
    var onError: ((String) -> Void)?

    private let walletService: WalletService
    private let tokenStore: TokenStore
    private var goals: [FinancialGoalRecord] = []
    private var summary: FinancialGoalSummaryResponse?

    init(walletService: WalletService, tokenStore: TokenStore) {
        self.walletService = walletService
        self.tokenStore = tokenStore
    }
}

extension FinancialGoalsViewModel {
    @MainActor
    func load() async {
        guard let userID = currentUserID else {
            goals = []
            summary = nil
            emitState()
            onError?("Kullanici bilgisi alinamadi. Lutfen tekrar giris yapin.")
            return
        }

        do {
            async let goalsResponse = walletService.fetchFinancialGoals()
            async let summaryResponse = walletService.fetchFinancialGoalsSummary(userID: userID)

            let (fetchedGoals, fetchedSummary) = try await (goalsResponse, summaryResponse)
            goals = fetchedGoals.map(mapGoalResponse)
            summary = fetchedSummary
            emitState()
        } catch {
            goals = []
            summary = nil
            emitState()
            onError?("Finansal hedefler alinamadi. Lutfen tekrar deneyin.")
        }
    }

    func goalRecord(for id: UUID) -> FinancialGoalRecord? {
        goals.first { $0.id == id }
    }

    func addContribution(to id: UUID, amount: Decimal) {
        guard let index = goals.firstIndex(where: { $0.id == id }) else { return }
        let goal = goals[index]
        goals[index] = FinancialGoalRecord(
            id: goal.id,
            title: goal.title,
            targetAmount: goal.targetAmount,
            savedAmount: goal.savedAmount + amount,
            deadline: goal.deadline,
            note: goal.note,
            iconName: goal.iconName,
            iconTintColor: goal.iconTintColor,
            iconBackgroundColor: goal.iconBackgroundColor
        )
        emitState()
    }

    func updateGoal(_ updatedGoal: FinancialGoalRecord) {
        guard let index = goals.firstIndex(where: { $0.id == updatedGoal.id }) else { return }
        goals[index] = updatedGoal
        emitState()
    }

    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        emitState()
    }

    func addGoal(_ draft: FinancialGoalDraft) {
        let icon = suggestedIcon(for: draft.title)
        let newGoal = FinancialGoalRecord(
            id: UUID(),
            title: draft.title,
            targetAmount: draft.targetAmount,
            savedAmount: .zero,
            deadline: draft.deadline,
            note: draft.note,
            iconName: icon.name,
            iconTintColor: icon.tint,
            iconBackgroundColor: icon.background
        )
        goals.append(newGoal)
        emitState()
    }
}

 extension FinancialGoalsViewModel {
    func emitState() {
        onStateChange?(makeViewData())
    }

    func makeViewData() -> FinancialGoalsViewData {
        let totalSaved = summary?.totalSavedAmount ?? .zero
        let totalTarget = summary?.totalTargetAmount ?? .zero
        let totalGoalCount = summary?.totalGoalCount ?? goals.count
        let completionPercent = summary?.completionPercentage ?? 0
        let progress = CGFloat(completionPercent) / 100
        let remaining = max(totalTarget - totalSaved, .zero)

        return FinancialGoalsViewData(
            titleText: "Finansal Hedefler",
            subtitleText: "Toplam birikim ilerlemen",
            totalGoalCountText: "TOPLAM HEDEF: \(totalGoalCount)",
            totalSavedAmountText: AppNumberTextFormatter.prefixedLira(totalSaved, minimumFractionDigits: 0, maximumFractionDigits: 0),
            totalTargetAmountText: AppNumberTextFormatter.prefixedLira(totalTarget, minimumFractionDigits: 0, maximumFractionDigits: 0),
            completionText: "%\(completionPercent) Tamamlandi",
            remainingAmountText: AppNumberTextFormatter.prefixedLira(remaining, minimumFractionDigits: 0, maximumFractionDigits: 0) + " kaldi",
            progress: progress,
            sectionTitleText: "HEDEFLERIN",
            items: goals.map(mapGoal)
        )
    }

    func mapGoal(_ goal: FinancialGoalRecord) -> FinancialGoalItemViewData {
        let progress = goal.targetAmount > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: goal.savedAmount / goal.targetAmount).doubleValue))
            : 0
        return FinancialGoalItemViewData(
            id: goal.id,
            titleText: goal.title,
            deadlineText: "Son tarih: " + Self.goalDateFormatter.string(from: goal.deadline),
            currentAmountText: AppNumberTextFormatter.prefixedLira(goal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            targetAmountText: AppNumberTextFormatter.prefixedLira(goal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            progress: progress,
            iconName: goal.iconName,
            iconTintColor: goal.iconTintColor,
            iconBackgroundColor: goal.iconBackgroundColor
        )
    }

    func mapGoalResponse(_ goal: FinancialGoalResponse) -> FinancialGoalRecord {
        let icon = suggestedIcon(for: goal.title)
        return FinancialGoalRecord(
            id: goal.id,
            title: goal.title,
            targetAmount: goal.targetAmount,
            savedAmount: goal.currentAmount,
            deadline: AppDateTextFormatter.parseServerDate(goal.targetDate),
            note: nil,
            iconName: icon.name,
            iconTintColor: icon.tint,
            iconBackgroundColor: icon.background
        )
    }

    var currentUserID: UUID? {
        guard let token = tokenStore.accessToken else { return nil }
        return decodeUserID(from: token)
    }

    func decodeUserID(from token: String) -> UUID? {
        let segments = token.split(separator: ".")
        guard segments.count >= 2 else { return nil }

        var payload = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let remainder = payload.count % 4
        if remainder != 0 {
            payload += String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: payload),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }

        let candidateKeys = [
            "nameid",
            "nameidentifier",
            "sub",
            "userId",
            "userid",
            "id",
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
        ]

        for key in candidateKeys {
            if let value = json[key] as? String, let uuid = UUID(uuidString: value) {
                return uuid
            }
        }

        return nil
    }

    func suggestedIcon(for title: String) -> (name: String, tint: UIColor, background: UIColor) {
        let normalized = title.lowercased()
        if normalized.contains("telefon") || normalized.contains("iphone") {
            return ("iphone.gen3", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        if normalized.contains("tatil") || normalized.contains("gezi") {
            return ("sun.max", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        if normalized.contains("araba") {
            return ("car", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        return ("target", AppColor.navigationTint, AppColor.surfaceMuted)
    }

    static let goalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
}
