import Foundation
import UIKit

final class InvestmentHistoryViewModel {
    var onStateChange: ((InvestmentHistoryViewState) -> Void)?

    private let walletService: WalletService
    private let currencyFormatter: NumberFormatter
    private let quantityFormatter: NumberFormatter
    private let inputDateFormatter = ISO8601DateFormatter()
    private let fallbackInputDateFormatter = ISO8601DateFormatter()
    private let outputDateFormatter = DateFormatter()

    init(walletService: WalletService) {
        self.walletService = walletService

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "TRY"
        currencyFormatter.currencySymbol = "₺"
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.locale = Locale(identifier: "tr_TR")
        self.currencyFormatter = currencyFormatter

        let quantityFormatter = NumberFormatter()
        quantityFormatter.numberStyle = .decimal
        quantityFormatter.maximumFractionDigits = 2
        quantityFormatter.minimumFractionDigits = 0
        quantityFormatter.locale = Locale(identifier: "tr_TR")
        self.quantityFormatter = quantityFormatter

        inputDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        fallbackInputDateFormatter.formatOptions = [.withInternetDateTime]

        outputDateFormatter.locale = Locale(identifier: "tr_TR")
        outputDateFormatter.dateFormat = "dd MMMM yyyy • HH:mm"
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchInvestmentHistory()
            onStateChange?(.loaded(map(response)))
        } catch {
            onStateChange?(.failure("İşlem geçmişi alınamadı. Lütfen tekrar deneyin."))
        }
    }
}

 extension InvestmentHistoryViewModel {
    func map(_ response: PortfolioInvestmentHistoryResponse) -> InvestmentHistoryViewData {
        let items = response.transactions.map { transaction in
            let isBuy = transaction.transactionType.lowercased().contains("al")
            return InvestmentHistoryTransactionItem(
                assetName: transaction.assetName,
                amountText: formattedQuantity(transaction.amount, assetName: transaction.assetName),
                totalPriceText: formatCurrency(transaction.totalPrice),
                dateText: formatDate(transaction.date),
                transactionTypeText: transaction.transactionType,
                transactionTypeColor: isBuy ? AppColor.successStrong : AppColor.dangerStrong
            )
        }

        return InvestmentHistoryViewData(
            titleText: "İşlem Geçmişi",
            items: items,
            monthlySummaryTitleText: "Aylık Özet",
            monthlySummaryBodyText: response.monthlyAiSummary,
            emptyMessageText: items.isEmpty ? "Henüz yatırım işlemi bulunmuyor." : nil
        )
    }

    func formattedQuantity(_ value: Decimal, assetName: String) -> String {
        let amountText = quantityFormatter.string(from: value as NSDecimalNumber) ?? "0"
        let lowercasedAssetName = assetName.lowercased()
        let unit: String

        if lowercasedAssetName.contains("altın") || lowercasedAssetName.contains("gümüş") {
            unit = "gr"
        } else {
            unit = "birim"
        }

        return "\(amountText) \(unit)"
    }

    func formatCurrency(_ value: Decimal) -> String {
        currencyFormatter.string(from: value as NSDecimalNumber) ?? "₺0,00"
    }

    func formatDate(_ rawValue: String) -> String {
        let date = inputDateFormatter.date(from: rawValue)
            ?? fallbackInputDateFormatter.date(from: rawValue)
            ?? Date()
        return outputDateFormatter.string(from: date)
    }
}
