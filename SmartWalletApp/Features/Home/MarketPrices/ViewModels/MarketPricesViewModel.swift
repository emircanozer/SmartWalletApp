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
        MarketPricesPresentationMapper.makeViewData(from: response)
    }
}
