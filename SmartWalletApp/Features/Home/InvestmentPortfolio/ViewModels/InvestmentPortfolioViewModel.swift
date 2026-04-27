import Foundation
import UIKit

final class InvestmentPortfolioViewModel {
    var onStateChange: ((InvestmentPortfolioViewState) -> Void)?

    private let walletService: WalletService

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchPortfolioSummary()
            // case ile veri gönderme
            onStateChange?(.loaded(map(response)))
        } catch {
            onStateChange?(.failure("Yatırım portföyü alınamadı. Lütfen tekrar deneyin."))
        }
    }
}

// ui modele çeviriyor, formatlanıyor
extension InvestmentPortfolioViewModel {
    func map(_ response: PortfolioSummaryResponse) -> InvestmentPortfolioViewData {
        InvestmentPortfolioPresentationMapper.makeViewData(from: response)
    }
}
