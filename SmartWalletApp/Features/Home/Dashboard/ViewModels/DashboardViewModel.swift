import Foundation

/* service’ten gelen ham response’u alıyor
 UI’ın kullanacağı DashboardViewData ve DashboardTransaction modeline çeviriyor*/

enum DashboardViewState {
    case idle
    case loading
    case loaded(DashboardViewData)
    case failure(String)
}

final class DashboardViewModel {
    var onStateChange: ((DashboardViewState) -> Void)?

    private let walletService: WalletService
    private let currencyText = "TL"

    init(walletService: WalletService) {
        self.walletService = walletService
    }
    
    /* bu closure sonunda UI güncellemesine gidiyor her ne kadar burada label boyamamıyor ama state yayınlıyor o state controller’da UI güncellemesine dönüşüyor o yüzden controller da da olmasa bile mainactoru burada da kullanmak güvenli */
    @MainActor
    func loadDashboard() async {
        onStateChange?(.loading)

        do {
            
            let wallet = try await walletService.fetchMyWallet()
            let transactions = try await walletService.fetchTransactions(walletId: wallet.id)
            let data = makeViewData(wallet: wallet, transactions: transactions)
            onStateChange?(.loaded(data))
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}

 extension DashboardViewModel {
    func makeViewData(wallet: MyWalletResponse, transactions: [WalletTransactionResponse]) -> DashboardViewData {
        DashboardPresentationMapper.makeViewData(
            wallet: wallet,
            transactions: transactions,
            currencyText: currencyText
        )
    }
}
