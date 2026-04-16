import UIKit

enum AIAssistantViewState {
    case loaded(AIAssistantViewData)
    case failure(String)
}

enum AIAssistantMessageSender {
    case assistant
    case user
}

enum AIAssistantMessageKind {
    case text
    case typing
}

enum AIAssistantActionState {
    case pending
    case accepted
    case declined
}

enum AIAssistantNavigationTarget {
    case investmentTrading(asset: InvestmentTradingAssetType?, direction: InvestmentTradeDirection?)
    case expenseAnalysis
    case sendMoney
    case investmentPortfolio
    case marketPrices
}

struct AIAssistantMessageAction {
    let titleText: String
    let secondaryTitleText: String
    let target: AIAssistantNavigationTarget
    let state: AIAssistantActionState
}

// ekranın veri kaynağı  her mesaj verisinde bu var array ile kullanıyorum 
struct AIAssistantMessageItem {
    let id: UUID
    let kind: AIAssistantMessageKind
    let sender: AIAssistantMessageSender
    let text: String
    let timestampText: String
    let action: AIAssistantMessageAction?
}

struct AIAssistantViewData {
    let titleText: String
    let subtitleText: String
    let placeholderText: String
    let sendButtonImageName: String
    let messages: [AIAssistantMessageItem]
    let draftText: String
    let isSendEnabled: Bool
}
