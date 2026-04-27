import Foundation
import UIKit

enum InvestmentHistoryPresentationMapper {
    static func makeViewData(from response: PortfolioInvestmentHistoryResponse, filter: InvestmentHistoryFilter) -> InvestmentHistoryViewData {
        let items = response.transactions.compactMap { transaction -> InvestmentHistoryTransactionItem? in
            let isBuy = transaction.transactionType.lowercased().contains("al")

            switch filter {
            case .all:
                break
            case .buy where !isBuy:
                return nil
            case .sell where isBuy:
                return nil
            default:
                break
            }

            return InvestmentHistoryTransactionItem(
                assetName: transaction.assetName,
                amountText: quantity(transaction.amount, assetName: transaction.assetName),
                totalPriceText: AppNumberTextFormatter.currencyTRY(transaction.totalPrice),
                dateText: AppDateTextFormatter.string(from: transaction.date, style: .investmentHistoryDateTime),
                transactionTypeText: transaction.transactionType,
                transactionTypeColor: isBuy ? AppColor.successStrong : AppColor.dangerStrong,
                isBuy: isBuy
            )
        }

        return InvestmentHistoryViewData(
            titleText: "İşlem Geçmişi",
            selectedFilter: filter,
            items: items,
            monthlySummaryTitleText: "Aylık Özet",
            monthlySummaryBodyText: response.monthlyAiSummary,
            emptyMessageText: items.isEmpty ? "Henüz yatırım işlemi bulunmuyor." : nil
        )
    }

    private static func quantity(_ value: Decimal, assetName: String) -> String {
        let amountText = AppNumberTextFormatter.decimal(value, minimumFractionDigits: 0, maximumFractionDigits: 2)
        let lowercasedAssetName = assetName.lowercased()
        let unit = (lowercasedAssetName.contains("altın") || lowercasedAssetName.contains("gümüş")) ? "gr" : "birim"
        return "\(amountText) \(unit)"
    }
}
