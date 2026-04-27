import Foundation
import UIKit

final class InvestmentHistoryViewModel {
    var onStateChange: ((InvestmentHistoryViewState) -> Void)?

    private let walletService: WalletService
    private var response: PortfolioInvestmentHistoryResponse?
    private var selectedFilter: InvestmentHistoryFilter = .all

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchInvestmentHistory()
            self.response = response
            onStateChange?(.loaded(map(response)))
        } catch {
            onStateChange?(.failure("İşlem geçmişi alınamadı. Lütfen tekrar deneyin."))
        }
    }

    func applyFilter(_ filter: InvestmentHistoryFilter) {
        selectedFilter = filter
        guard let response else { return }
        onStateChange?(.loaded(map(response)))
    }
}

 extension InvestmentHistoryViewModel {
    func map(_ response: PortfolioInvestmentHistoryResponse) -> InvestmentHistoryViewData {
        InvestmentHistoryPresentationMapper.makeViewData(from: response, filter: selectedFilter)
    }
}
