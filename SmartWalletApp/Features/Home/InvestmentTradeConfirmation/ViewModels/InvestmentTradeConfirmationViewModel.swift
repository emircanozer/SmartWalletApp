import Foundation
import UIKit

final class InvestmentTradeConfirmationViewModel {
    var onStateChange: ((InvestmentTradeConfirmationViewState) -> Void)?

    private let walletService: WalletService
    private let context: InvestmentTradeContext

    init(walletService: WalletService, context: InvestmentTradeContext) {
        self.walletService = walletService
        self.context = context
    }

    func load() {
        onStateChange?(.loaded(makeViewData()))
    }

    @MainActor
    func confirmTrade() async {
        onStateChange?(.loading)

        do {
            let response: PortfolioTradeResponse
            switch context.direction {
            case .buy:
                response = try await walletService.buyPortfolioAsset(request: context.request)
            case .sell:
                response = try await walletService.sellPortfolioAsset(request: context.request)
            }

            guard response.success else {
                onStateChange?(.failure(response.message))
                onStateChange?(.loaded(makeViewData()))
                return
            }

            onStateChange?(.approved(makeSuccessContext()))
        } catch {
            onStateChange?(.failure(error.localizedDescription))
            onStateChange?(.loaded(makeViewData()))
        }
    }
}

 extension InvestmentTradeConfirmationViewModel {
    func makeViewData() -> InvestmentTradeConfirmationViewData {
        InvestmentTradeConfirmationPresentationMapper.makeViewData(from: context)
    }

    func makeSuccessContext() -> InvestmentTradeSuccessContext {
        InvestmentTradeConfirmationPresentationMapper.makeSuccessContext(from: context)
    }
}
