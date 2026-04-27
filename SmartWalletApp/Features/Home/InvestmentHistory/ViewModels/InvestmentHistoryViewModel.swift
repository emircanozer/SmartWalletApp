import Foundation

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
            let viewData = InvestmentHistoryViewDataFactory.makeViewData(from: response, filter: selectedFilter)
            onStateChange?(.loaded(viewData))

            onStateChange?(.aiSummaryLoading)

            do {
                let summaryResponse = try await walletService.fetchPortfolioAISummary()
                onStateChange?(.aiSummaryLoaded(InvestmentHistoryViewDataFactory.makeSummaryViewData(from: summaryResponse)))
            } catch {
                onStateChange?(.aiSummaryFailed("Yapay zeka özeti şu anda alınamıyor."))
            }
        } catch {
            onStateChange?(.failure("İşlem geçmişi alınamadı. Lütfen tekrar deneyin."))
        }
    }

    func applyFilter(_ filter: InvestmentHistoryFilter) {
        selectedFilter = filter
        guard let response else { return }
        onStateChange?(.loaded(InvestmentHistoryViewDataFactory.makeViewData(from: response, filter: selectedFilter)))
    }
}
