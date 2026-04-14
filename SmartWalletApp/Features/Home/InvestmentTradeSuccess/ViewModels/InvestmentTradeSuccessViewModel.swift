import Foundation

enum InvestmentTradeSuccessViewState {
    case loaded(InvestmentTradeSuccessViewData)
}

struct InvestmentTradeSuccessViewData {
    let titleText: String
    let subtitleText: String
    let assetTitleText: String
    let directionText: String
    let amountText: String
    let totalAmountText: String
    let resultingBalanceText: String
    let statusPillText: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
}

final class InvestmentTradeSuccessViewModel {
    var onStateChange: ((InvestmentTradeSuccessViewState) -> Void)?

    private let context: InvestmentTradeSuccessContext

    init(context: InvestmentTradeSuccessContext) {
        self.context = context
    }

    func load() {
        onStateChange?(.loaded(makeViewData()))
    }
}

 extension InvestmentTradeSuccessViewModel {
    func makeViewData() -> InvestmentTradeSuccessViewData {
        InvestmentTradeSuccessViewData(
            titleText: "İşleminiz Başarıyla Gerçekleştirildi",
            subtitleText: context.subtitleText,
            assetTitleText: context.assetDisplayName,
            directionText: context.directionTitle,
            amountText: context.amountText,
            totalAmountText: context.totalAmountText,
            resultingBalanceText: context.resultingBalanceText,
            statusPillText: "MARKET VERİSİ CANLI",
            primaryButtonTitle: "Ana Sayfaya Dön",
            secondaryButtonTitle: "İşlem Geçmişi"
        )
    }
}
