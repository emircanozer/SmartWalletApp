import Foundation

final class InvestmentHistoryViewModel {
    var onStateChange: ((InvestmentHistoryViewState) -> Void)?

    private let walletService: WalletService
    private var response: PortfolioInvestmentHistoryResponse?
    private var selectedDateFilter: InvestmentHistoryDateFilter = .all
    private var selectedTypeFilter: InvestmentHistoryTypeFilter = .all

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchInvestmentHistory()
            self.response = response
            let viewData = InvestmentHistoryViewDataFactory.makeViewData(
                from: response,
                dateFilter: selectedDateFilter,
                typeFilter: selectedTypeFilter
            )
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

    func applyDateFilter(_ filter: InvestmentHistoryDateFilter) {
        selectedDateFilter = filter
        guard let response else { return }
        onStateChange?(.loaded(InvestmentHistoryViewDataFactory.makeViewData(
            from: response,
            dateFilter: selectedDateFilter,
            typeFilter: selectedTypeFilter
        )))
    }

    func applyTypeFilter(_ filter: InvestmentHistoryTypeFilter) {
        selectedTypeFilter = filter
        guard let response else { return }
        onStateChange?(.loaded(InvestmentHistoryViewDataFactory.makeViewData(
            from: response,
            dateFilter: selectedDateFilter,
            typeFilter: selectedTypeFilter
        )))
    }
}
