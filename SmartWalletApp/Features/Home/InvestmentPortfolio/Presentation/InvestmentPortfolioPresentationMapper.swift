import Foundation
import UIKit

enum InvestmentPortfolioPresentationMapper {
    static func makeViewData(from response: PortfolioSummaryResponse) -> InvestmentPortfolioViewData {
        let isEmpty = (response.totalPortfolioValue as NSDecimalNumber).decimalValue == .zero || response.assets.isEmpty
        let allocationItems = makeAllocationItems(from: response)
        let dominantShare = allocationItems.max { lhs, rhs in lhs.progress < rhs.progress }?.title ?? "Yok"

        let assetItems = response.assets.map { asset in
            let assetType = InvestmentAssetType(backendValue: asset.assetType)
            let amountText = AppNumberTextFormatter.decimal(asset.amount, minimumFractionDigits: 0, maximumFractionDigits: 2)
            let averageCostText = AppNumberTextFormatter.currencyTRY(asset.averageCost, minimumFractionDigits: 0, maximumFractionDigits: 2)
            let totalValueText = AppNumberTextFormatter.currencyTRY(asset.totalValue, minimumFractionDigits: 0, maximumFractionDigits: 0)

            return InvestmentPortfolioAssetItem(
                title: assetType.title,
                subtitle: "\(amountText) \(assetType.amountUnit) • Ort. \(averageCostText)",
                totalValueText: totalValueText,
                profitLossText: AppNumberTextFormatter.signedPercent(asset.profitLossPercentage, minimumFractionDigits: 0, maximumFractionDigits: 2),
                isProfit: (asset.profitLoss as NSDecimalNumber).decimalValue >= .zero,
                iconName: assetType.iconName,
                accentColor: assetType.accentColor,
                iconSurfaceColor: assetType.surfaceColor
            )
        }

        return InvestmentPortfolioViewData(
            titleText: "Ana Sayfaya Dön",
            totalPortfolioValueText: AppNumberTextFormatter.currencyTRY(response.totalPortfolioValue, minimumFractionDigits: 0, maximumFractionDigits: 0),
            totalProfitLossText: AppNumberTextFormatter.signedCurrencyTRY(response.totalProfitLoss, minimumFractionDigits: 0, maximumFractionDigits: 2),
            totalProfitLossDetailText: "\(AppNumberTextFormatter.signedPercent(response.profitLossPercentage, minimumFractionDigits: 0, maximumFractionDigits: 2)) bugün",
            isProfit: (response.totalProfitLoss as NSDecimalNumber).decimalValue >= .zero,
            dominantShareText: "En Büyük Pay: \(dominantShare)",
            allocationItems: allocationItems,
            assetItems: assetItems,
            emptyMessageText: isEmpty ? "Henüz bir yatırım varlığınız yok." : nil
        )
    }

    private static func makeAllocationItems(from response: PortfolioSummaryResponse) -> [InvestmentPortfolioAllocationItem] {
        let totalValue = (response.totalPortfolioValue as NSDecimalNumber).decimalValue
        guard totalValue > .zero else { return [] }

        var groupedTotals: [InvestmentAllocationGroup: Decimal] = [:]
        response.assets.forEach { asset in
            let assetType = InvestmentAssetType(backendValue: asset.assetType)
            groupedTotals[assetType.allocationGroup, default: .zero] += asset.totalValue
        }

        return InvestmentAllocationGroup.allCases.compactMap { group in
            guard let value = groupedTotals[group], value > .zero else { return nil }
            let percentage = ((value as NSDecimalNumber).doubleValue / (totalValue as NSDecimalNumber).doubleValue) * 100
            let textValue = AppNumberTextFormatter.decimal(Decimal(percentage), minimumFractionDigits: 0, maximumFractionDigits: 2)

            return InvestmentPortfolioAllocationItem(
                title: group.title,
                percentageText: "%\(textValue)",
                progress: CGFloat(percentage / 100.0),
                color: group.color
            )
        }
    }
}
