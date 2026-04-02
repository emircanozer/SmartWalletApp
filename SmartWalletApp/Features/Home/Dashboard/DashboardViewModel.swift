import Foundation

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

private extension DashboardViewModel {
    //Backend → UI Model'e çevirme
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

    //BACKENDEKİ FOOD APPTEKİ .food'a dönüştü 
    func mapTransaction(_ transaction: WalletTransactionResponse) -> DashboardTransaction {
        let category = TransactionCategory(backendValue: transaction.category)
        let amountPrefix = transaction.isIncoming ? "+" : "-"
        let amountText = "\(amountPrefix)\(formatAmount(transaction.amount))"
        let date = parseDate(transaction.transactionTime)
        let trimmedDescription = transaction.description.trimmingCharacters(in: .whitespacesAndNewlines)

        return DashboardTransaction(
            id: transaction.id,
            title: category.title,
            subtitle: trimmedDescription.isEmpty ? category.badgeTitle : trimmedDescription,
            date: date,
            dateText: formatDate(date),
            categoryBadgeText: category.badgeTitle,
            amount: transaction.amount,
            amountText: amountText,
            isIncome: transaction.isIncoming,
            category: category
        )
    }

    func formatBalance(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter.string(for: amount) ?? "0"
    }

    func formatAmount(_ amount: Decimal) -> String {
        let formatted = formatBalance(amount)
        return "₺\(formatted)"
    }

    func parseDate(_ rawValue: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]

        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = TimeZone.current
        localFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"

        let shortFractionFormatter = DateFormatter()
        shortFractionFormatter.locale = Locale(identifier: "en_US_POSIX")
        shortFractionFormatter.timeZone = TimeZone.current
        shortFractionFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        let plainFormatter = DateFormatter()
        plainFormatter.locale = Locale(identifier: "en_US_POSIX")
        plainFormatter.timeZone = TimeZone.current
        plainFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return formatter.date(from: rawValue)
            ?? fallbackFormatter.date(from: rawValue)
            ?? localFormatter.date(from: rawValue)
            ?? shortFractionFormatter.date(from: rawValue)
            ?? plainFormatter.date(from: rawValue)
            ?? Date()
    }

    func formatDate(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "tr_TR")
        outputFormatter.dateFormat = "d MMMM yyyy, HH.mm"
        return outputFormatter.string(from: date)
    }

    func formatDisplayName(_ fullName: String) -> String {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmed.first else { return trimmed }
        return firstCharacter.uppercased() + trimmed.dropFirst()
    }
}
