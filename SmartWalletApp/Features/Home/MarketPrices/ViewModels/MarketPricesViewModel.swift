import Foundation

final class MarketPricesViewModel {
    // state olarak controller’a veriyor.
    var onStateChange: ((MarketPricesViewState) -> Void)?

    private let walletService: WalletService
    private let priceFormatter: NumberFormatter
    private let percentFormatter: NumberFormatter

    init(walletService: WalletService) {
        self.walletService = walletService

        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .decimal
        priceFormatter.maximumFractionDigits = 4
        priceFormatter.minimumFractionDigits = 2
        priceFormatter.locale = Locale(identifier: "tr_TR")
        self.priceFormatter = priceFormatter

        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .decimal
        percentFormatter.maximumFractionDigits = 2
        percentFormatter.minimumFractionDigits = 0
        percentFormatter.locale = Locale(identifier: "tr_TR")
        self.percentFormatter = percentFormatter
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
                buyPriceText: formattedPrice(price.buyPrice),
                sellPriceText: formattedPrice(price.sellPrice),
                dailyChangeText: signedPercentText(price.dailyChangePercentage),
                isPositiveChange: dailyChange >= .zero
            )
        }

        return MarketPricesViewData(
            titleText: "Piyasalar",
            items: items,
            emptyMessageText: items.isEmpty ? "Henüz piyasa verisi yok." : nil
        )
    }

    func formattedPrice(_ value: Decimal) -> String {
        priceFormatter.string(from: value as NSDecimalNumber) ?? "0"
    }

    func signedPercentText(_ value: Decimal) -> String {
        let number = value as NSDecimalNumber
        let formatted = percentFormatter.string(from: abs(number.doubleValue) as NSNumber) ?? "0"
        return number.decimalValue < .zero ? "-%\(formatted)" : "+%\(formatted)"
    }
}
