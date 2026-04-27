import Foundation

enum DashboardPresentationMapper {
    static func makeViewData(wallet: MyWalletResponse, transactions: [WalletTransactionResponse], currencyText: String) -> DashboardViewData {
        let mappedTransactions = AppTransactionPresentationMapper.mapDashboardTransactions(transactions)
        return DashboardViewData(
            greetingText: "Merhaba \(AppStringTextFormatter.displayName(wallet.fullName))",
            ibanText: wallet.iban,
            balanceText: balance(wallet.balance),
            currencyText: currencyText,
            previewTransactions: Array(mappedTransactions.prefix(3)),
            allTransactions: mappedTransactions
        )
    }

    private static func balance(_ amount: Decimal) -> String {
        AppNumberTextFormatter.decimal(amount, minimumFractionDigits: 2, maximumFractionDigits: 2)
    }
}
