import Foundation

enum InvestmentTradingViewDataFactory {
    static func makeViewData(
        wallet: MyWalletResponse?,
        prices: [PortfolioPriceResponse],
        summary: PortfolioSummaryResponse?,
        selectedAsset: InvestmentTradingAssetType?,
        selectedDirection: InvestmentTradeDirection,
        selectedInputMode: InvestmentTradingInputMode,
        enteredAmountText: String,
        enteredAmount: Decimal,
        validationMessage: String?,
        isActionEnabled: Bool
    ) -> InvestmentTradingViewData? {
        guard let wallet, let summary else { return nil }

        let availableAssets = InvestmentTradingPresentationFormatter.makeAvailableAssets(from: prices)
        guard let selectedAsset else {
            return InvestmentTradingViewData(
                titleText: "Yatırım İşlemi",
                subtitleText: "İşlem yapabileceğiniz yatırım aracı bulunamadı.",
                assetItems: [],
                selectedDirection: selectedDirection,
                selectedInputMode: .quantity,
                buyPriceText: "₺0,00",
                sellPriceText: "₺0,00",
                balanceText: "₺0,00",
                holdingText: "0",
                amountText: enteredAmountText,
                amountTitleText: "MİKTAR GİRİNİZ",
                amountPlaceholderText: "0.00",
                amountUnitText: "-",
                quantityOptionTitle: "-",
                quickAmountItems: [],
                summaryRows: [],
                estimateTitleText: "TAHMİNİ TUTAR",
                estimateValueText: "₺0,00",
                actionButtonTitle: "İŞLEM YAP",
                isActionEnabled: false,
                validationMessageText: nil,
                emptyMessageText: "Henüz işlem yapılabilecek yatırım verisi yok."
            )
        }

        let price = prices.first { $0.assetType == selectedAsset.backendValue }
        let ownedAmount = summary.assets.first(where: { $0.assetType == selectedAsset.backendValue })?.amount ?? .zero
        let unitPrice = selectedDirection == .buy ? (price?.buyPrice ?? .zero) : (price?.sellPrice ?? .zero)
        let estimatedTotal = selectedInputMode == .fiat ? enteredAmount : enteredAmount * unitPrice
        let estimatedAssetAmount = selectedInputMode == .fiat ? safeDivision(enteredAmount, by: unitPrice) : enteredAmount

        let summaryRows = InvestmentTradingPresentationFormatter.makeSummaryRows(
            selectedAsset: selectedAsset,
            selectedDirection: selectedDirection,
            selectedInputMode: selectedInputMode,
            unitPrice: unitPrice,
            enteredAmount: enteredAmount,
            estimatedTotal: estimatedTotal,
            estimatedAssetAmount: estimatedAssetAmount
        )

        return InvestmentTradingViewData(
            titleText: "Yatırım İşlemi",
            subtitleText: "Altın, döviz ve diğer yatırım araçlarında alım-satım yap.",
            assetItems: availableAssets.map {
                InvestmentTradingAssetChipItem(assetType: $0, title: $0.title, isSelected: $0.backendValue == selectedAsset.backendValue)
            },
            selectedDirection: selectedDirection,
            selectedInputMode: selectedInputMode,
            buyPriceText: InvestmentTradingValueFormatter.unitPrice(price?.buyPrice ?? .zero, asset: selectedAsset),
            sellPriceText: InvestmentTradingValueFormatter.unitPrice(price?.sellPrice ?? .zero, asset: selectedAsset),
            balanceText: AppNumberTextFormatter.currencyTRY(wallet.balance),
            holdingText: "\(InvestmentTradingValueFormatter.quantity(ownedAmount)) \(selectedAsset.amountUnit)",
            amountText: enteredAmountText,
            amountTitleText: selectedInputMode == .fiat ? "TUTAR GİRİNİZ" : "MİKTAR GİRİNİZ",
            amountPlaceholderText: "0.00",
            amountUnitText: selectedInputMode == .fiat ? "TL" : selectedAsset.amountUnit.uppercased(),
            quantityOptionTitle: selectedAsset.amountUnit.uppercased(),
            quickAmountItems: InvestmentTradingPresentationFormatter.makeQuickAmountItems(
                for: selectedAsset,
                selectedInputMode: selectedInputMode
            ),
            summaryRows: summaryRows,
            estimateTitleText: InvestmentTradingPresentationFormatter.estimateTitleText(
                direction: selectedDirection,
                inputMode: selectedInputMode
            ),
            estimateValueText: InvestmentTradingPresentationFormatter.estimateValueText(
                direction: selectedDirection,
                inputMode: selectedInputMode,
                estimatedAssetAmount: estimatedAssetAmount,
                estimatedTotal: estimatedTotal,
                asset: selectedAsset
            ),
            actionButtonTitle: selectedDirection == .buy ? "\(selectedAsset.displayCode) SATIN AL" : "\(selectedAsset.displayCode) SAT",
            isActionEnabled: isActionEnabled,
            validationMessageText: validationMessage,
            emptyMessageText: nil
        )
    }

    private static func safeDivision(_ lhs: Decimal, by rhs: Decimal) -> Decimal {
        guard rhs > .zero else { return .zero }
        return lhs / rhs
    }
}
