import Foundation
import UIKit

final class InvestmentTradeConfirmationViewModel {
    var onStateChange: ((InvestmentTradeConfirmationViewState) -> Void)?

    private let walletService: WalletService
    private let context: InvestmentTradeContext
    private let currencyFormatter: NumberFormatter
    private let quantityFormatter: NumberFormatter

    init(walletService: WalletService, context: InvestmentTradeContext) {
        self.walletService = walletService
        self.context = context

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "TRY"
        currencyFormatter.currencySymbol = "₺"
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.locale = Locale(identifier: "tr_TR")
        self.currencyFormatter = currencyFormatter

        let quantityFormatter = NumberFormatter()
        quantityFormatter.numberStyle = .decimal
        quantityFormatter.maximumFractionDigits = 4
        quantityFormatter.minimumFractionDigits = 0
        quantityFormatter.locale = Locale(identifier: "tr_TR")
        self.quantityFormatter = quantityFormatter
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
                    value: formatUnitPrice(context.unitPrice, asset: context.assetType),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "GİRİLEN TUTAR",
                    value: formatCurrency(context.enteredAmount),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: context.direction == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ SATILACAK",
                    value: "\(formatEstimatedAssetAmount(context.assetAmount, asset: context.assetType)) \(context.assetType.amountUnit)",
                    valueColor: AppColor.accentOlive
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "KULLANILABİLİR BAKİYE",
                    value: formatCurrency(context.currentBalance),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "İŞLEM SONRASI BAKİYE",
                    value: formatCurrency(context.resultingBalance),
                    valueColor: AppColor.accentOlive
                )
            ]
        } else {
            detailItems = [
                InvestmentTradeConfirmationDetailItem(
                    title: "BİRİM FİYAT",
                    value: formatUnitPrice(context.unitPrice, asset: context.assetType),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "GİRİLEN MİKTAR",
                    value: "\(formatQuantity(context.enteredAmount)) \(context.assetType.amountUnit)",
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "TOPLAM TUTAR",
                    value: formatCurrency(context.totalAmount),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "KULLANILABİLİR BAKİYE",
                    value: formatCurrency(context.currentBalance),
                    valueColor: AppColor.primaryText
                ),
                InvestmentTradeConfirmationDetailItem(
                    title: "İŞLEM SONRASI BAKİYE",
                    value: formatCurrency(context.resultingBalance),
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
        let assetAmountText = "\(formatQuantity(context.assetAmount)) \(context.assetType.amountUnit)"
        let subtitleText: String
        if context.inputMode == .fiat {
            subtitleText = "\(formatCurrency(context.enteredAmount)) tutarındaki \(context.assetType.title.lowercased()) \(context.direction == .buy ? "alım" : "satım") işleminiz başarıyla tamamlandı."
        } else {
            subtitleText = "\(assetAmountText) \(context.assetType.title.lowercased()) \(context.direction == .buy ? "alım" : "satım") işleminiz başarıyla tamamlandı."
        }
        return InvestmentTradeSuccessContext(
            assetName: context.assetType.title,
            assetDisplayName: "\(context.assetType.title) (\(context.assetType.marketCode))",
            directionTitle: context.direction.confirmationTitle,
            amountText: assetAmountText,
            totalAmountText: formatCurrency(context.totalAmount),
            resultingBalanceText: formatCurrency(context.resultingBalance),
            subtitleText: subtitleText
        )
    }

    func formatCurrency(_ value: Decimal) -> String {
        currencyFormatter.string(from: value as NSDecimalNumber) ?? "₺0,00"
    }

    func formatQuantity(_ value: Decimal) -> String {
        quantityFormatter.string(from: value as NSDecimalNumber) ?? "0"
    }

    func formatEstimatedAssetAmount(_ value: Decimal, asset: InvestmentTradingAssetType) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")

        switch asset {
        case .gold, .silver:
            formatter.maximumFractionDigits = 4
        default:
            formatter.maximumFractionDigits = 2
        }

        formatter.minimumFractionDigits = 0
        return formatter.string(from: value as NSDecimalNumber) ?? "0"
    }

    func formatUnitPrice(_ value: Decimal, asset: InvestmentTradingAssetType) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        switch asset {
        case .gold, .silver:
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        default:
            formatter.minimumFractionDigits = 4
            formatter.maximumFractionDigits = 4
        }
        let text = formatter.string(from: value as NSDecimalNumber) ?? "0"
        return "₺\(text)"
    }
}
