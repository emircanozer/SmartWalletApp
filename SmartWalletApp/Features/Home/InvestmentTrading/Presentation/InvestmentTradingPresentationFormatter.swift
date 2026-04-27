import Foundation

enum InvestmentTradingPresentationFormatter {
    static func makeAvailableAssets(from prices: [PortfolioPriceResponse]) -> [InvestmentTradingAssetType] {
        let availableSet = Set(prices.map(\.assetType))
        return InvestmentTradingAssetType.allCases.filter { availableSet.contains($0.backendValue) }
    }

    static func decimalInputText(_ value: Decimal) -> String {
        AppNumberTextFormatter.inputDecimal(value)
    }

    static func makeSummaryRows(
        selectedAsset: InvestmentTradingAssetType,
        selectedDirection: InvestmentTradeDirection,
        selectedInputMode: InvestmentTradingInputMode,
        unitPrice: Decimal,
        enteredAmount: Decimal,
        estimatedTotal: Decimal,
        estimatedAssetAmount: Decimal
    ) -> [InvestmentTradingSummaryRowItem] {
        if selectedInputMode == .fiat {
            return [
                InvestmentTradingSummaryRowItem(title: "İşlem Tipi", value: tradeTitle(asset: selectedAsset, direction: selectedDirection)),
                InvestmentTradingSummaryRowItem(title: "Birim Fiyat", value: InvestmentTradingValueFormatter.unitPrice(unitPrice, asset: selectedAsset)),
                InvestmentTradingSummaryRowItem(title: "Girilen Tutar", value: AppNumberTextFormatter.currencyTRY(enteredAmount)),
                InvestmentTradingSummaryRowItem(
                    title: selectedDirection == .buy ? "Tahmini Alınacak" : "Tahmini Satılacak",
                    value: "\(InvestmentTradingValueFormatter.estimatedAssetAmount(estimatedAssetAmount, asset: selectedAsset)) \(selectedAsset.amountUnit)"
                )
            ]
        }

        return [
            InvestmentTradingSummaryRowItem(title: "İşlem Tipi", value: tradeTitle(asset: selectedAsset, direction: selectedDirection)),
            InvestmentTradingSummaryRowItem(title: "Birim Fiyat", value: InvestmentTradingValueFormatter.unitPrice(unitPrice, asset: selectedAsset)),
            InvestmentTradingSummaryRowItem(
                title: "Girilen Miktar",
                value: enteredAmount > .zero
                    ? "\(InvestmentTradingValueFormatter.quantity(enteredAmount)) \(selectedAsset.amountUnit)"
                    : "0 \(selectedAsset.amountUnit)"
            ),
            InvestmentTradingSummaryRowItem(title: "Toplam Tutar", value: AppNumberTextFormatter.currencyTRY(estimatedTotal))
        ]
    }

    static func makeQuickAmountItems(
        for asset: InvestmentTradingAssetType,
        selectedInputMode: InvestmentTradingInputMode
    ) -> [InvestmentTradingQuickAmountItem] {
        let values: [Decimal]
        switch (asset, selectedInputMode) {
        case (_, .fiat):
            values = [1000, 5000, 10000, 15000]
        case (.gold, _), (.silver, _):
            values = [0.25, 0.5, 1, 2]
        case (.usd, _), (.eur, _), (.gbp, _), (.chf, _), (.sar, _), (.kwd, _):
            values = [10, 50, 100, 250]
        case (.other, _):
            values = [1, 5, 10, 25]
        }

        return values.map { value in
            InvestmentTradingQuickAmountItem(
                value: value,
                title: selectedInputMode == .fiat
                    ? "\(InvestmentTradingValueFormatter.quantity(value)) TL"
                    : "\(InvestmentTradingValueFormatter.quantity(value)) \(asset.amountUnit)"
            )
        }
    }

    static func estimateTitleText(
        direction: InvestmentTradeDirection,
        inputMode: InvestmentTradingInputMode
    ) -> String {
        if inputMode == .fiat {
            return direction == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ SATILACAK"
        }
        return direction == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ GELECEK"
    }

    static func estimateValueText(
        direction: InvestmentTradeDirection,
        inputMode: InvestmentTradingInputMode,
        estimatedAssetAmount: Decimal,
        estimatedTotal: Decimal,
        asset: InvestmentTradingAssetType
    ) -> String {
        if inputMode == .fiat {
            return "\(InvestmentTradingValueFormatter.estimatedAssetAmount(estimatedAssetAmount, asset: asset)) \(asset.amountUnit)"
        }

        return direction == .buy
            ? "\(InvestmentTradingValueFormatter.quantity(estimatedAssetAmount)) \(asset.amountUnit)"
            : AppNumberTextFormatter.currencyTRY(estimatedTotal)
    }

    private static func tradeTitle(
        asset: InvestmentTradingAssetType,
        direction: InvestmentTradeDirection
    ) -> String {
        direction == .buy ? "\(asset.title) Alımı" : "\(asset.title) Satımı"
    }
}
