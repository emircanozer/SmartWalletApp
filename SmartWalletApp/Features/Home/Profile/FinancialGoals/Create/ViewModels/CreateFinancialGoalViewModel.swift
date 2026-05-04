import Foundation

final class CreateFinancialGoalViewModel {
    var onStateChange: ((CreateFinancialGoalFormState) -> Void)?
    var onGoalCreated: ((FinancialGoalDraft) -> Void)?

    private var title = ""
    private var amountText = ""
    private var selectedDate: Date?
}

extension CreateFinancialGoalViewModel {
    func makeViewData() -> CreateFinancialGoalViewData {
        CreateFinancialGoalViewData(
            titleText: "Yeni Hedef Olustur",
            subtitleText: "Hedef belirleyerek birikim surecini planlayabilirsiniz.",
            nameTitleText: "Hedef Adi",
            namePlaceholderText: "Orn: iPhone 15 Pro, Tatil",
            targetTitleText: "Hedef Tutar",
            targetPlaceholderText: "₺0",
            deadlineTitleText: "Son Tarih",
            deadlinePlaceholderText: "Tarih sec",
            aiHintTitleText: "SWAY'E SORUN",
            aiHintBodyText: "Ilgili sorularinizi SWAY'e sorarak hedefinize daha hizli ulasin.",
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

    func submit() -> String? {
        guard !title.isEmpty else {
            return "Lutfen hedef adini girin."
        }

        guard let amount = parsedAmount, amount > .zero else {
            return "Lutfen gecerli bir hedef tutar girin."
        }

        guard let selectedDate else {
            return "Lutfen son tarihi secin."
        }

        onGoalCreated?(FinancialGoalDraft(title: title, targetAmount: amount, deadline: selectedDate))
        return nil
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
        onStateChange?(
            CreateFinancialGoalFormState(
                selectedDateText: selectedDate.map { Self.dateFormatter.string(from: $0) },
                isApproveEnabled: !title.isEmpty && parsedAmount != nil && parsedAmount! > .zero && selectedDate != nil
            )
        )
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
}
