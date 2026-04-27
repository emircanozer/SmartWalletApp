import Foundation

final class ExpenseAnalysisViewModel {
    var onStateChange: ((ExpenseAnalysisViewState) -> Void)?

    private let walletService: WalletService

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchAnalysis()
            let viewData = ExpenseAnalysisPresentationMapper.makeViewData(from: response)
            onStateChange?(.loaded(viewData))

            guard viewData.emptyMessageText == nil else { return }

            onStateChange?(.aiInsightLoading)

            do {
                let adviceResponse = try await walletService.fetchAIAdvice()
                onStateChange?(.aiInsightLoaded(ExpenseAnalysisPresentationMapper.makeAIInsightViewData(from: adviceResponse)))
            } catch {
                onStateChange?(.aiInsightFailed("Yapay zeka tavsiyesi şu anda alınamıyor."))
            }
        } catch {
            onStateChange?(.loaded(ExpenseAnalysisPresentationMapper.makeEmptyViewData()))
        }
    }
}
