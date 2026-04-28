import Foundation

final class MarketPricesViewModel {
    // state olarak controller’a veriyor.
    var onStateChange: ((MarketPricesViewState) -> Void)?

    private let walletService: WalletService

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchPortfolioPrices()
            onStateChange?(.loaded(map(response)))
        } catch {
            onStateChange?(.failure("Piyasa verileri alınamadı. Lütfen tekrar deneyin."))
        }
    }
}

extension MarketPricesViewModel {
    func map(_ response: [PortfolioPriceResponse]) -> MarketPricesViewData {
        let items = response.map { price in
            let assetType = MarketAssetType(backendValue: price.assetType)
            let dailyChange = (price.dailyChangePercentage as NSDecimalNumber).decimalValue

            return MarketPriceItem(
                title: assetType.title,
                subtitle: assetType.subtitle,
                iconName: assetType.iconName,
                accentColor: assetType.accentColor,
                iconSurfaceColor: assetType.surfaceColor,
                buyPriceText: AppNumberTextFormatter.decimal(
                    price.buyPrice,
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 4
                ),
                sellPriceText: AppNumberTextFormatter.decimal(
                    price.sellPrice,
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 4
                ),
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
}
