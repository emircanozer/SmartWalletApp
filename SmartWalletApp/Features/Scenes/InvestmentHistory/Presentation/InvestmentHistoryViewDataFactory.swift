import Foundation
import UIKit

enum InvestmentHistoryViewDataFactory {
    static func makeViewData(
        from response: PortfolioInvestmentHistoryResponse,
        dateFilter: InvestmentHistoryDateFilter,
        typeFilter: InvestmentHistoryTypeFilter
    ) -> InvestmentHistoryViewData {
        let items = response.transactions.compactMap { transaction -> InvestmentHistoryTransactionItem? in
            let isBuy = transaction.transactionType.lowercased().contains("al")
            let transactionDate = AppDateTextFormatter.parseServerDate(transaction.date)

            switch typeFilter {
            case .all:
                break
            case .buy where !isBuy:
                return nil
            case .sell where isBuy:
                return nil
            default:
                break
            }

            guard matchesDateFilter(transactionDate, filter: dateFilter) else {
                return nil
            }

            return InvestmentHistoryTransactionItem(
                assetName: transaction.assetName,
                amountText: quantity(transaction.amount, assetName: transaction.assetName),
                totalPriceText: AppNumberTextFormatter.currencyTRY(transaction.totalPrice),
                dateText: AppDateTextFormatter.string(from: transactionDate, style: .investmentHistoryDateTime),
                transactionTypeText: transaction.transactionType,
                transactionTypeColor: isBuy ? AppColor.successStrong : AppColor.dangerStrong,
                isBuy: isBuy
            )
        }

        return InvestmentHistoryViewData(
            titleText: "İşlem Geçmişi",
            selectedDateFilterTitleText: dateFilter.title,
            selectedTypeFilterTitleText: typeFilter.title,
            items: items,
            emptyMessageText: items.isEmpty ? "Henüz yatırım işlemi bulunmuyor." : nil
        )
    }

    static func makeSummaryViewData(from response: PortfolioAISummaryResponse) -> InvestmentHistorySummaryViewData {
        InvestmentHistorySummaryViewData(
            titleText: "Aylık Özet",
            bodyText: response.summary
        )
    }

    private static func quantity(_ value: Decimal, assetName: String) -> String {
        let amountText = AppNumberTextFormatter.decimal(value, minimumFractionDigits: 0, maximumFractionDigits: 2)
        let lowercasedAssetName = assetName.lowercased()
        let unit = (lowercasedAssetName.contains("altın") || lowercasedAssetName.contains("gümüş")) ? "gr" : "birim"
        return "\(amountText) \(unit)"
    }

    private static func matchesDateFilter(_ date: Date, filter: InvestmentHistoryDateFilter) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        switch filter {
        case .all:
            return true
        case .last7Days:
            guard let start = calendar.date(byAdding: .day, value: -7, to: now) else { return true }
            return date >= start
        case .last15Days:
            guard let start = calendar.date(byAdding: .day, value: -15, to: now) else { return true }
            return date >= start
        case .last30Days:
            guard let start = calendar.date(byAdding: .day, value: -30, to: now) else { return true }
            return date >= start
        case .last3Months:
            guard let start = calendar.date(byAdding: .month, value: -3, to: now) else { return true }
            return date >= start
        case .last6Months:
            guard let start = calendar.date(byAdding: .month, value: -6, to: now) else { return true }
            return date >= start
        }
    }
}
