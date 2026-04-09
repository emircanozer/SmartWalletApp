import Foundation
import UIKit

final class InvestmentPortfolioViewModel {
    var onStateChange: ((InvestmentPortfolioViewState) -> Void)?

    private let walletService: WalletService
    private let currencyFormatter: NumberFormatter
    private let detailCurrencyFormatter: NumberFormatter
    private let percentFormatter: NumberFormatter
    private let amountFormatter: NumberFormatter

    init(walletService: WalletService) {
        self.walletService = walletService

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "TRY"
        currencyFormatter.currencySymbol = "₺"
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.locale = Locale(identifier: "tr_TR")
        self.currencyFormatter = currencyFormatter

        let detailCurrencyFormatter = NumberFormatter()
        detailCurrencyFormatter.numberStyle = .currency
        detailCurrencyFormatter.currencyCode = "TRY"
        detailCurrencyFormatter.currencySymbol = "₺"
        detailCurrencyFormatter.maximumFractionDigits = 2
        detailCurrencyFormatter.minimumFractionDigits = 0
        detailCurrencyFormatter.locale = Locale(identifier: "tr_TR")
        self.detailCurrencyFormatter = detailCurrencyFormatter

        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .decimal
        percentFormatter.maximumFractionDigits = 2
        percentFormatter.minimumFractionDigits = 0
        percentFormatter.locale = Locale(identifier: "tr_TR")
        self.percentFormatter = percentFormatter

        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal
        amountFormatter.maximumFractionDigits = 2
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.locale = Locale(identifier: "tr_TR")
        self.amountFormatter = amountFormatter
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchPortfolioSummary()
            // case ile veri gönderme
            onStateChange?(.loaded(map(response)))
        } catch {
            onStateChange?(.failure("Yatırım portföyü alınamadı. Lütfen tekrar deneyin."))
        }
    }
}

// ui modele çeviriyor, formatlanıyor
extension InvestmentPortfolioViewModel {
    func map(_ response: PortfolioSummaryResponse) -> InvestmentPortfolioViewData {
        let isEmpty = (response.totalPortfolioValue as NSDecimalNumber).decimalValue == .zero || response.assets.isEmpty

        let allocationItems = makeAllocationItems(response)
        let dominantShare = allocationItems.max { lhs, rhs in
            lhs.progress < rhs.progress
        }?.title ?? "Yok"

        let assetItems = response.assets.map { asset in
            let assetType = InvestmentAssetType(backendValue: asset.assetType)
            let amountText = amountFormatter.string(from: asset.amount as NSDecimalNumber) ?? "0"
            let averageCostText = detailCurrencyFormatter.string(from: asset.averageCost as NSDecimalNumber) ?? "₺0"
            let totalValueText = currencyFormatter.string(from: asset.totalValue as NSDecimalNumber) ?? "₺0"
            let profitPercent = signedPercentText(asset.profitLossPercentage)

            return InvestmentPortfolioAssetItem(
                title: assetType.title,
                subtitle: "\(amountText) \(assetType.amountUnit) • Ort. \(averageCostText)",
                totalValueText: totalValueText,
                profitLossText: profitPercent,
                isProfit: (asset.profitLoss as NSDecimalNumber).decimalValue >= .zero,
                iconName: assetType.iconName,
                accentColor: assetType.accentColor,
                iconSurfaceColor: assetType.surfaceColor
            )
        }

        return InvestmentPortfolioViewData(
            titleText: "Ana Sayfaya Dön",
            totalPortfolioValueText: currencyFormatter.string(from: response.totalPortfolioValue as NSDecimalNumber) ?? "₺0",
            totalProfitLossText: signedCurrencyText(response.totalProfitLoss),
            totalProfitLossDetailText: "\(signedPercentText(response.profitLossPercentage)) bugün",
            isProfit: (response.totalProfitLoss as NSDecimalNumber).decimalValue >= .zero,
            dominantShareText: "En Büyük Pay: \(dominantShare)",
            allocationItems: allocationItems,
            assetItems: assetItems,
            emptyMessageText: isEmpty ? "Henüz bir yatırım varlığınız yok." : nil
        )
    }

    //her asset InvestmentAssetType’a dönüyor
    //sonra allocationGroup’a ayrılıyor
    private func makeAllocationItems(_ response: PortfolioSummaryResponse) -> [InvestmentPortfolioAllocationItem] {
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
            let textValue = percentFormatter.string(from: percentage as NSNumber) ?? "0"

            return InvestmentPortfolioAllocationItem(
                title: group.title,
                percentageText: "%\(textValue)",
                progress: CGFloat(percentage / 100.0),
                color: group.color
            )
        }
    }

    private func signedCurrencyText(_ value: Decimal) -> String {
        let number = value as NSDecimalNumber
        let formatted = detailCurrencyFormatter.string(from: abs(number.doubleValue) as NSNumber) ?? "₺0"
        return number.decimalValue < .zero ? "-\(formatted)" : "+\(formatted)"
    }

    private func signedPercentText(_ value: Decimal) -> String {
        let number = value as NSDecimalNumber
        let formatted = percentFormatter.string(from: abs(number.doubleValue) as NSNumber) ?? "0"
        return number.decimalValue < .zero ? "-%\(formatted)" : "+%\(formatted)"
    }
}
