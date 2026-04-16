import Foundation

@MainActor
final class AIAssistantViewModel {
    var onStateChange: ((AIAssistantViewState) -> Void)?
    var onNavigationRequested: ((AIAssistantNavigationTarget) -> Void)?

    private let assistantService: AssistantService
    private var messages: [AIAssistantMessageItem] = []
    private var draftMessage = ""
    private let welcomeTimestamp = AIAssistantViewModel.makeCurrentTimeText()

    init(assistantService: AssistantService) {
        self.assistantService = assistantService
        messages = [
            AIAssistantMessageItem(
                id: UUID(),
                kind: .text,
                sender: .assistant,
                text: "Merhaba ben SmartWallet AI. Her zaman yanınızdayım, size nasıl yardımcı olabilirim?",
                timestampText: welcomeTimestamp,
                action: nil
            )
        ]
    }

    func load() {
        emitState()
    }

    func updateDraft(_ text: String) {
        draftMessage = text
        emitState()
    }

    func sendMessage(_ rawMessage: String? = nil) async {
        let sourceMessage = rawMessage ?? draftMessage
        let trimmedMessage = sourceMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        let timestamp = Self.makeCurrentTimeText()
        messages.append(
            AIAssistantMessageItem(
                id: UUID(),
                kind: .text,
                sender: .user,
                text: trimmedMessage,
                timestampText: timestamp,
                action: nil
            )
        )

        let typingID = UUID()
        messages.append(
            AIAssistantMessageItem(
                id: typingID,
                kind: .typing,
                sender: .assistant,
                text: "",
                timestampText: timestamp,
                action: nil
            )
        )

        draftMessage = ""
        emitState()

        do {
            let response = try await assistantService.sendMessage(trimmedMessage)
            removeTypingMessage(with: typingID)
            messages.append(makeAssistantMessage(from: response))
            emitState()
        } catch {
            removeTypingMessage(with: typingID)
            emitState()
            onStateChange?(.failure("AI asistan cevabı alınamadı. Lütfen tekrar deneyin."))
        }
    }

    func acceptAction(for messageID: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == messageID }),
              let action = messages[index].action
        else {
            return
        }

        messages[index] = AIAssistantMessageItem(
            id: messages[index].id,
            kind: messages[index].kind,
            sender: messages[index].sender,
            text: messages[index].text,
            timestampText: messages[index].timestampText,
            action: AIAssistantMessageAction(
                titleText: action.titleText,
                secondaryTitleText: action.secondaryTitleText,
                target: action.target,
                state: .accepted
            )
        )
        emitState()
        onNavigationRequested?(action.target)
    }

    func declineAction(for messageID: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == messageID }),
              let action = messages[index].action
        else {
            return
        }

        messages[index] = AIAssistantMessageItem(
            id: messages[index].id,
            kind: messages[index].kind,
            sender: messages[index].sender,
            text: messages[index].text,
            timestampText: messages[index].timestampText,
            action: AIAssistantMessageAction(
                titleText: action.titleText,
                secondaryTitleText: action.secondaryTitleText,
                target: action.target,
                state: .declined
            )
        )
        emitState()
    }
}

 extension AIAssistantViewModel {
     // state e verileri verdim controller kullanıp ekrana basacak
    func emitState() {
        onStateChange?(
            .loaded(
                AIAssistantViewData(
                    titleText: "SmartWallet AI",
                    subtitleText: "Akıllı Finansal Asistan",
                    placeholderText: "SmartWallet AI’a mesaj yaz...",
                    sendButtonImageName: "arrow.up",
                    messages: messages,
                    draftText: draftMessage,
                    isSendEnabled: !draftMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            )
        )
    }

    func removeTypingMessage(with id: UUID) {
        messages.removeAll { $0.id == id }
    }

    func makeAssistantMessage(from response: AssistantChatResponse) -> AIAssistantMessageItem {
        let target = makeNavigationTarget(from: response.actionType, isActionExecuted: response.isActionExecuted)
        let action: AIAssistantMessageAction?

        if let target, !response.isActionExecuted {
            action = AIAssistantMessageAction(
                titleText: "Kabul Et",
                secondaryTitleText: "İptal Et",
                target: target,
                state: .pending
            )
        } else {
            action = nil
        }

        return AIAssistantMessageItem(
            id: UUID(),
            kind: .text,
            sender: .assistant,
            text: response.reply,
            timestampText: Self.makeCurrentTimeText(),
            action: action
        )
    }

    func makeNavigationTarget(from actionType: String?, isActionExecuted: Bool) -> AIAssistantNavigationTarget? {
        guard let normalizedAction = actionType?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),
              !normalizedAction.isEmpty,
              !isActionExecuted
        else {
            return nil
        }

        if normalizedAction.contains("ANALYSIS") {
            return .expenseAnalysis
        }

        if normalizedAction.contains("TRANSFER") || normalizedAction.contains("SEND_MONEY") {
            return .sendMoney
        }

        if normalizedAction.contains("PORTFOLIO") {
            return .investmentPortfolio
        }

        if normalizedAction.contains("MARKET") || normalizedAction.contains("PRICE") {
            return .marketPrices
        }

        if normalizedAction.contains("GOLD") || normalizedAction.contains("SILVER") || normalizedAction.contains("USD") || normalizedAction.contains("EUR") || normalizedAction.contains("GBP") || normalizedAction.contains("CHF") || normalizedAction.contains("SAR") || normalizedAction.contains("KWD") || normalizedAction.contains("BUY") || normalizedAction.contains("SELL") {
            return .investmentTrading(
                asset: assetType(from: normalizedAction),
                direction: direction(from: normalizedAction)
            )
        }

        return nil
    }

    func assetType(from actionType: String) -> InvestmentTradingAssetType? {
        let tokens = tokens(from: actionType)
        if tokens.contains("GOLD") { return .gold }
        if tokens.contains("SILVER") { return .silver }
        if tokens.contains("USD") || tokens.contains("DOLLAR") { return .usd }
        if tokens.contains("EUR") || tokens.contains("EURO") { return .eur }
        if tokens.contains("GBP") { return .gbp }
        if tokens.contains("CHF") { return .chf }
        if tokens.contains("SAR") { return .sar }
        if tokens.contains("KWD") { return .kwd }
        return nil
    }

    func direction(from actionType: String) -> InvestmentTradeDirection? {
        let tokens = tokens(from: actionType)
        if tokens.contains("BUY") || tokens.contains("AL") {
            return .buy
        }
        if tokens.contains("SELL") || tokens.contains("SAT") {
            return .sell
        }
        return nil
    }

    func tokens(from value: String) -> Set<String> {
        Set(
            value
                .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
                .map { String($0).uppercased() }
        )
    }

    static func makeCurrentTimeText() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}
