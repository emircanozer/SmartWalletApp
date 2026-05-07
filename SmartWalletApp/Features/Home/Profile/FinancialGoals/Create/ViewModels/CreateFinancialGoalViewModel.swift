import Foundation
import UIKit

@MainActor
final class CreateFinancialGoalViewModel: BaseViewModel {
    var onStateChange: ((CreateFinancialGoalFormState) -> Void)?
    var onGoalCreated: ((FinancialGoalRecord) -> Void)?

    private let walletService: WalletService
    private var title = ""
    private var amountText = ""
    private var selectedDate: Date?
    private var isSubmitting = false

    init(walletService: WalletService) {
        self.walletService = walletService
    }
}

extension CreateFinancialGoalViewModel {
    func makeViewData() -> CreateFinancialGoalViewData {
        CreateFinancialGoalViewData(
            titleText: "Yeni Hedef Olustur",
            subtitleText: "Hedef belirleyerek birikim surecini planlayabilirsiniz.",
            nameTitleText: "Hedef Adı",
            namePlaceholderText: "Orn: iPhone 15 Pro, Tatil",
            targetTitleText: "Hedef Tutar",
            targetPlaceholderText: "₺0",
            deadlineTitleText: "Son Tarih",
            deadlinePlaceholderText: "Tarih seç",
            aiHintTitleText: "SWAY'E SORUN",
            aiHintBodyText: "İlgili sorularınızı SWAY'e sorarak hedefinize daha hizli ulaşın.",
            approveButtonTitleText: "Hedefi Onayla"
        )
    }

    func updateTitle(_ value: String) {
        title = value.trimmingCharacters(in: .whitespacesAndNewlines)
        emitState()
    }

    func updateAmount(_ value: String) {
        amountText = value
        emitState()
    }

    func updateDate(_ value: Date) {
        selectedDate = value
        emitState()
    }

    func submit() async -> String? {
        guard !title.isEmpty else {
            return "Lutfen hedef adini girin."
        }

        guard let amount = parsedAmount, amount > .zero else {
            return "Lütfen geçerli bir hedef tutar girin."
        }

        guard let selectedDate else {
            return "Lütfen son tarihi seçin."
        }

        do {
            let response = try await performSubmission(
                setSubmitting: { [weak self] in self?.isSubmitting = $0 },
                emitState: { [weak self] in self?.emitState() }
            ) {
                try await self.walletService.createFinancialGoal(
                    request: CreateFinancialGoalRequest(
                        title: self.title,
                        targetAmount: amount,
                        targetDate: selectedDate
                    )
                )
            }

            guard response.success else {
                return response.message
            }

            let icon = suggestedIcon(for: title)
            onGoalCreated?(
                FinancialGoalRecord(
                    id: response.goalId,
                    title: title,
                    targetAmount: amount,
                    savedAmount: .zero,
                    deadline: selectedDate,
                    note: nil,
                    iconName: icon.name,
                    iconTintColor: icon.tint,
                    iconBackgroundColor: icon.background
                )
            )
            return nil
        } catch {
            return "Hedef oluşturulamadı. Lütfen tekrar deneyin."
        }
    }
}

 extension CreateFinancialGoalViewModel {
    var parsedAmount: Decimal? {
        let normalized = amountText
            .replacingOccurrences(of: "₺", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Decimal(string: normalized)
    }

    func emitState() {
        emit(
            CreateFinancialGoalFormState(
                selectedDateText: selectedDate.map { AppDateTextFormatter.string(from: $0, style: .financialGoalDayMonthYear) },
                isApproveEnabled: !isSubmitting && !title.isEmpty && parsedAmount != nil && parsedAmount! > .zero && selectedDate != nil,
                isSubmitting: isSubmitting
            ),
            using: onStateChange
        )
    }

    func suggestedIcon(for title: String) -> (name: String, tint: UIColor, background: UIColor) {
        let normalized = title.lowercased()
        if normalized.contains("telefon") || normalized.contains("iphone") {
            return ("iphone.gen3", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        if normalized.contains("tatil") || normalized.contains("gezi") || normalized.contains("eglence") {
            return ("sun.max", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        if normalized.contains("araba") {
            return ("car", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        return ("target", AppColor.navigationTint, AppColor.surfaceMuted)
    }
}
