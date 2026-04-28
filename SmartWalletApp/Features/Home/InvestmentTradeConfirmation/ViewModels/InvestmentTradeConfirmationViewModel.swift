import Foundation
import UIKit

final class InvestmentTradeConfirmationViewModel {
    var onStateChange: ((InvestmentTradeConfirmationViewState) -> Void)?

    private let walletService: WalletService
    private let context: InvestmentTradeContext

    init(walletService: WalletService, context: InvestmentTradeContext) {
        self.walletService = walletService
        self.context = context
    }

    func load() {
        onStateChange?(.loaded(makeViewData()))
    }

    @MainActor
    func confirmTrade() async {
        onStateChange?(.loading)

        do {
            let response: PortfolioTradeResponse
            switch context.direction {
            case .buy:
                response = try await walletService.buyPortfolioAsset(request: context.request)
            case .sell:
                response = try await walletService.sellPortfolioAsset(request: context.request)
            }

            guard response.success else {
                onStateChange?(.failure(response.message))
                onStateChange?(.loaded(makeViewData()))
                return
            }

            onStateChange?(.approved(makeSuccessContext()))
        } catch {
            onStateChange?(.failure(error.localizedDescription))
            onStateChange?(.loaded(makeViewData()))
        }
    }
}

 extension InvestmentTradeConfirmationViewModel {
    func makeViewData() -> InvestmentTradeConfirmationViewData {
        let highlightItems = [
            InvestmentTradeConfirmationHighlightItem(
                title: "VARLIK",
                value: context.assetType.title,
                iconName: "star.circle.fill"
            ),
            InvestmentTradeConfirmationHighlightItem(
                title: "İŞLEM TİPİ",
                value: context.direction.confirmationTitle,
                iconName: nil
            )
        ]

        let detailItems: [InvestmentTradeConfirmationDetailItem]
        if context.inputMode == .fiat {
            detailItems = [
                InvestmentTradeConfirmationDetailItem(
                    title: "BİRİM FİYAT",
                    value: InvestmentTradingValueFormatter.unitPrice(context.unitPrice, asset: context.assetType),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "GİRİLEN TUTAR",
                    value: AppNumberTextFormatter.currencyTRY(context.enteredAmount),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: context.direction == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ SATILACAK",
                    value: "\(InvestmentTradingValueFormatter.estimatedAssetAmount(context.assetAmount, asset: context.assetType)) \(context.assetType.amountUnit)",
                    valueColor: AppColor.accentOlive
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "KULLANILABİLİR BAKİYE",
                    value: AppNumberTextFormatter.currencyTRY(context.currentBalance),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "İŞLEM SONRASI BAKİYE",
                    value: AppNumberTextFormatter.currencyTRY(context.resultingBalance),
                    valueColor: AppColor.accentOlive
                )
            ]
        } else {
            detailItems = [
                InvestmentTradeConfirmationDetailItem(
                    title: "BİRİM FİYAT",
                    value: InvestmentTradingValueFormatter.unitPrice(context.unitPrice, asset: context.assetType),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "GİRİLEN MİKTAR",
                    value: "\(InvestmentTradingValueFormatter.quantity(context.enteredAmount)) \(context.assetType.amountUnit)",
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "TOPLAM TUTAR",
                    value: AppNumberTextFormatter.currencyTRY(context.totalAmount),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "KULLANILABİLİR BAKİYE",
                    value: AppNumberTextFormatter.currencyTRY(context.currentBalance),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "İŞLEM SONRASI BAKİYE",
                    value: AppNumberTextFormatter.currencyTRY(context.resultingBalance),
                    valueColor: AppColor.accentOlive
                )
            ]
        }

        return InvestmentTradeConfirmationViewData(
            titleText: "İşlem Onayı",
            subtitleText: "Lütfen yatırım işleminizi kontrol edin.",
            highlightItems: highlightItems,
            detailItems: detailItems,
            noticeText: "Fiyatlar anlık değişebilir, onay sonrası işlem gerçekleştirilecektir.",
            confirmButtonTitle: "Onayla",
            backButtonTitle: "Geri Dön"
        )
    }

    func makeSuccessContext() -> InvestmentTradeSuccessContext {
        let assetAmountText = "\(InvestmentTradingValueFormatter.quantity(context.assetAmount)) \(context.assetType.amountUnit)"
        let subtitleText: String
        if context.inputMode == .fiat {
            subtitleText = "\(AppNumberTextFormatter.currencyTRY(context.enteredAmount)) tutarındaki \(context.assetType.title.lowercased()) \(context.direction == .buy ? "alım" : "satım") işleminiz başarıyla tamamlandı."
        } else {
            subtitleText = "\(assetAmountText) \(context.assetType.title.lowercased()) \(context.direction == .buy ? "alım" : "satım") işleminiz başarıyla tamamlandı."
        }
        return InvestmentTradeSuccessContext(
            assetName: context.assetType.title,
            assetDisplayName: "\(context.assetType.title) (\(context.assetType.marketCode))",
            directionTitle: context.direction.confirmationTitle,
            amountText: assetAmountText,
            totalAmountText: AppNumberTextFormatter.currencyTRY(context.totalAmount),
            resultingBalanceText: AppNumberTextFormatter.currencyTRY(context.resultingBalance),
            subtitleText: subtitleText
        )
    }
}
