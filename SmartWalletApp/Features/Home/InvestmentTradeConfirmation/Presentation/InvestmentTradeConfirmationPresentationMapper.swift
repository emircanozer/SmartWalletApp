import Foundation
import UIKit

enum InvestmentTradeConfirmationPresentationMapper {
    static func makeViewData(from context: InvestmentTradeContext) -> InvestmentTradeConfirmationViewData {
        let highlightItems = [
            InvestmentTradeConfirmationHighlightItem(title: "VARLIK", value: context.assetType.title, iconName: "star.circle.fill"),
            InvestmentTradeConfirmationHighlightItem(title: "İŞLEM TİPİ", value: context.direction.confirmationTitle, iconName: nil)
        ]

        let detailItems = makeDetailItems(from: context)

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

    static func makeSuccessContext(from context: InvestmentTradeContext) -> InvestmentTradeSuccessContext {
        let assetAmountText = "\(InvestmentTradingValueFormatter.quantity(context.assetAmount)) \(context.assetType.amountUnit)"
        let actionText = context.direction == .buy ? "alım" : "satım"
        let subjectText = context.inputMode == .fiat
            ? "\(AppNumberTextFormatter.currencyTRY(context.enteredAmount)) tutarındaki \(context.assetType.title.lowercased())"
            : "\(assetAmountText) \(context.assetType.title.lowercased())"

        return InvestmentTradeSuccessContext(
            assetName: context.assetType.title,
            assetDisplayName: "\(context.assetType.title) (\(context.assetType.marketCode))",
            directionTitle: context.direction.confirmationTitle,
            amountText: assetAmountText,
            totalAmountText: AppNumberTextFormatter.currencyTRY(context.totalAmount),
            resultingBalanceText: AppNumberTextFormatter.currencyTRY(context.resultingBalance),
            subtitleText: "\(subjectText) \(actionText) işleminiz başarıyla tamamlandı."
        )
    }

    private static func makeDetailItems(from context: InvestmentTradeContext) -> [InvestmentTradeConfirmationDetailItem] {
        if context.inputMode == .fiat {
            return [
                InvestmentTradeConfirmationDetailItem(title: "BİRİM FİYAT", value: InvestmentTradingValueFormatter.unitPrice(context.unitPrice, asset: context.assetType), valueColor: AppColor.primaryText),
                InvestmentTradeConfirmationDetailItem(title: "GİRİLEN TUTAR", value: AppNumberTextFormatter.currencyTRY(context.enteredAmount), valueColor: AppColor.primaryText),
                InvestmentTradeConfirmationDetailItem(
                    title: context.direction == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ SATILACAK",
                    value: "\(InvestmentTradingValueFormatter.estimatedAssetAmount(context.assetAmount, asset: context.assetType)) \(context.assetType.amountUnit)",
                    valueColor: AppColor.accentOlive
                ),
                InvestmentTradeConfirmationDetailItem(title: "KULLANILABİLİR BAKİYE", value: AppNumberTextFormatter.currencyTRY(context.currentBalance), valueColor: AppColor.primaryText),
                InvestmentTradeConfirmationDetailItem(title: "İŞLEM SONRASI BAKİYE", value: AppNumberTextFormatter.currencyTRY(context.resultingBalance), valueColor: AppColor.accentOlive)
            ]
        }

        return [
            InvestmentTradeConfirmationDetailItem(title: "BİRİM FİYAT", value: InvestmentTradingValueFormatter.unitPrice(context.unitPrice, asset: context.assetType), valueColor: AppColor.primaryText),
            InvestmentTradeConfirmationDetailItem(title: "GİRİLEN MİKTAR", value: "\(InvestmentTradingValueFormatter.quantity(context.enteredAmount)) \(context.assetType.amountUnit)", valueColor: AppColor.primaryText),
            InvestmentTradeConfirmationDetailItem(title: "TOPLAM TUTAR", value: AppNumberTextFormatter.currencyTRY(context.totalAmount), valueColor: AppColor.primaryText),
            InvestmentTradeConfirmationDetailItem(title: "KULLANILABİLİR BAKİYE", value: AppNumberTextFormatter.currencyTRY(context.currentBalance), valueColor: AppColor.primaryText),
            InvestmentTradeConfirmationDetailItem(title: "İŞLEM SONRASI BAKİYE", value: AppNumberTextFormatter.currencyTRY(context.resultingBalance), valueColor: AppColor.accentOlive)
        ]
    }
}
