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
    //ham response'u  UI Model'e çevirme
    func makeViewData(wallet: MyWalletResponse, transactions: [WalletTransactionResponse]) -> DashboardViewData {
        // her birini ui modeline çeviriyor
        let mappedTransactions = transactions.map(mapTransaction)
        let previewTransactions = Array(mappedTransactions.prefix(3)) // ilk 3

        return DashboardViewData(
            greetingText: "Merhaba \(formatDisplayName(wallet.fullName))",
            ibanText: wallet.iban,
            balanceText: formatBalance(wallet.balance),
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
        let amountText = "\(amountPrefix)\(formatAmount(transaction.amount))"
        let date = parseDate(transaction.transactionTime)
        let trimmedDescription = transaction.description.trimmingCharacters(in: .whitespacesAndNewlines)

        return DashboardTransaction(
            id: transaction.id,
            title: category.title,
            subtitle: trimmedDescription.isEmpty ? badgeTitle : trimmedDescription,
            date: date,
            dateText: formatDate(date),
            categoryBadgeText: badgeTitle,
            amount: transaction.amount,
            amountText: amountText,
            isIncome: transaction.isIncoming,
            category: category
        )
    }

    func formatBalance(_ amount: Decimal) -> String {
        AppNumberTextFormatter.decimal(
            amount,
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        )
    }

    func formatAmount(_ amount: Decimal) -> String {
        AppNumberTextFormatter.prefixedLira(amount)
    }

    func parseDate(_ rawValue: String) -> Date {
        AppDateTextFormatter.parseServerDate(rawValue)
    }

    func formatDate(_ date: Date) -> String {
        AppDateTextFormatter.string(from: date, style: .transactionDateTime)
    }

    func formatDisplayName(_ fullName: String) -> String {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmed.first else { return trimmed }
        return firstCharacter.uppercased() + trimmed.dropFirst()
    }
}
