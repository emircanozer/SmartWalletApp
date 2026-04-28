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

  //ham response'u  UI Model'e çevirme

extension DashboardViewModel {
    func makeViewData(wallet: MyWalletResponse, transactions: [WalletTransactionResponse]) -> DashboardViewData {
        let mappedTransactions = transactions.map(mapTransaction)
        let previewTransactions = Array(mappedTransactions.prefix(3))

        return DashboardViewData(
            greetingText: "Merhaba \(AppStringTextFormatter.displayName(wallet.fullName))",
            ibanText: wallet.iban,
            balanceText: AppNumberTextFormatter.decimal(
                wallet.balance,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            ),
            currencyText: currencyText,
            previewTransactions: previewTransactions,
            allTransactions: mappedTransactions
        )
    }
    //BACKENDEKİ ham modeli ui modele çevirdi çünkü ekranın veya cellin ham responsedan daha fazla bilgiye ihtiyacı var  ** önemli

    func mapTransaction(_ transaction: WalletTransactionResponse) -> DashboardTransaction {
        let category = TransactionCategory(backendValue: transaction.category)
        let badgeTitle = category.badgeTitle(isIncome: transaction.isIncoming)
        let amountPrefix = transaction.isIncoming ? "+" : "-"
        let amountText = "\(amountPrefix)\(AppNumberTextFormatter.prefixedLira(transaction.amount))"
        let date = AppDateTextFormatter.parseServerDate(transaction.transactionTime)

        return DashboardTransaction(
            id: transaction.id,
            title: category.title,
            subtitle: AppStringTextFormatter.transactionSubtitle(
                transaction.description,
                fallback: badgeTitle
            ),
            date: date,
            dateText: AppDateTextFormatter.string(from: date, style: .transactionDateTime),
            categoryBadgeText: badgeTitle,
            amount: transaction.amount,
            amountText: amountText,
            isIncome: transaction.isIncoming,
            category: category
        )
    }
}
