import Foundation

enum MarketPricesPresentationMapper {
    static func makeViewData(from response: [PortfolioPriceResponse]) -> MarketPricesViewData {
        let items = response.map { price in
            let assetType = MarketAssetType(backendValue: price.assetType)
            let dailyChange = (price.dailyChangePercentage as NSDecimalNumber).decimalValue

            return MarketPriceItem(
                title: assetType.title,
                subtitle: assetType.subtitle,
                iconName: assetType.iconName,
                accentColor: assetType.accentColor,
                iconSurfaceColor: assetType.surfaceColor,
                buyPriceText: formattedPrice(price.buyPrice),
                sellPriceText: formattedPrice(price.sellPrice),
                dailyChangeText: AppNumberTextFormatter.signedPercent(price.dailyChangePercentage),
                isPositiveChange: dailyChange >= .zero
            )
        }

        return MarketPricesViewData(
            titleText: "Piyasalar",
            items: items,
            emptyMessageText: items.isEmpty ? "Henüz piyasa verisi yok." : nil
        )
    }

    private static func formattedPrice(_ value: Decimal) -> String {
        AppNumberTextFormatter.decimal(value, minimumFractionDigits: 2, maximumFractionDigits: 4)
    }
}
