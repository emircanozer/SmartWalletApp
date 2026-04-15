import Foundation
import UIKit

final class InvestmentHistoryViewModel {
    var onStateChange: ((InvestmentHistoryViewState) -> Void)?

    private let walletService: WalletService

    init(walletService: WalletService) {
        self.walletService = walletService
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
        let amountText = AppNumberTextFormatter.decimal(
            value,
            minimumFractionDigits: 0,
            maximumFractionDigits: 2
        )
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
        AppNumberTextFormatter.currencyTRY(value)
    }

    func formatDate(_ rawValue: String) -> String {
        AppDateTextFormatter.string(from: rawValue, style: .investmentHistoryDateTime)
    }
}
