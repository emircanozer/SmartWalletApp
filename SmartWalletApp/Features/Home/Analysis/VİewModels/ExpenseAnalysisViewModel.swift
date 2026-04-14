import Foundation
import UIKit

final class ExpenseAnalysisViewModel {
    var onStateChange: ((ExpenseAnalysisViewState) -> Void)?

    private let walletService: WalletService
    private let currencyFormatter: NumberFormatter
    private let percentFormatter: NumberFormatter
    private let chartColors: [UIColor] = [
        UIColor(red: 0.56, green: 0.73, blue: 0.98, alpha: 1),
        UIColor(red: 0.98, green: 0.74, blue: 0.43, alpha: 1),
        UIColor(red: 0.77, green: 0.67, blue: 0.97, alpha: 1),
        UIColor(red: 0.62, green: 0.93, blue: 0.69, alpha: 1),
        UIColor(red: 0.97, green: 0.63, blue: 0.66, alpha: 1)
    ]

    init(walletService: WalletService) {
        self.walletService = walletService

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "TRY"
        currencyFormatter.currencySymbol = "₺"
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.locale = Locale(identifier: "tr_TR")
        self.currencyFormatter = currencyFormatter

        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .decimal
        percentFormatter.maximumFractionDigits = 1
        percentFormatter.minimumFractionDigits = 0
        percentFormatter.locale = Locale(identifier: "tr_TR")
        self.percentFormatter = percentFormatter
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchAnalysis()
            let viewData = map(response)
            onStateChange?(.loaded(viewData))
        } catch {
            onStateChange?(
                .loaded(
                    ExpenseAnalysisViewData(
                        titleText: "Harcama Analizi",
                        totalExpenseText: "₺0",
                        emptyMessageText: "Henüz bir harcamanız yok.",
                        summaryItems: [],
                        chartSlices: [],
                        categoryItems: [],
                        aiInsightTitle: "",
                        aiInsightBody: ""
                    )
                )
            )
        }
    }
}

 extension ExpenseAnalysisViewModel {
     // ham responseu ui modeline çeviriyoruz
    func map(_ response: WalletAnalysisResponse) -> ExpenseAnalysisViewData {
        let isEmpty = (response.totalMonthlyExpense as NSDecimalNumber).decimalValue == .zero || response.categoryDetails.isEmpty

        let summaryItems = [
            ExpenseAnalysisSummaryItem(
                title: "Aylık Harcama",
                value: formatCurrency(response.totalMonthlyExpense),
                iconName: "creditcard"
            ),
            ExpenseAnalysisSummaryItem(
                title: "Günlük Ortalama",
                value: formatCurrency(response.dailyAverageExpense),
                iconName: "calendar"
            ),
            ExpenseAnalysisSummaryItem(
                title: "En Çok Harcama",
                value: response.topSendingCategory,
                iconName: "basket"
            ),
            ExpenseAnalysisSummaryItem(
                title: "Harcama Yüzdesi",
                value: topPercentageText(from: response.categoryDetails),
                iconName: "percent"
            )
        ]

        let categoryItems = response.categoryDetails.enumerated().map { index, item in
            ExpenseAnalysisCategoryItem(
                name: item.categoryName,
                amountText: formatCurrency(item.totalAmount),
                percentageText: "%\(formatPercent(item.percentage))",
                progress: min(CGFloat((item.percentage as NSDecimalNumber).doubleValue / 100.0), 1),
                color: chartColors[index % chartColors.count]
            )
        }

        let chartSlices = response.categoryDetails.enumerated().map { index, item in
            ExpenseAnalysisChartSlice(
                label: item.categoryName,
                value: max((item.totalAmount as NSDecimalNumber).doubleValue, 0.1),
                color: chartColors[index % chartColors.count]
            )
        }

        return ExpenseAnalysisViewData(
            titleText: "Harcama Analizi",
            totalExpenseText: formatCurrency(response.totalMonthlyExpense),
            emptyMessageText: isEmpty ? "Henüz bir harcamanız yok." : nil,
            summaryItems: summaryItems,
            chartSlices: chartSlices,
            categoryItems: categoryItems,
            aiInsightTitle: "YAPAY ZEKA ANALİZİ",
            aiInsightBody: response.aiAnalysisAdvice
        )
    }

    func formatCurrency(_ value: Decimal) -> String {
        currencyFormatter.string(from: value as NSDecimalNumber) ?? "₺0"
    }

    func formatPercent(_ value: Decimal) -> String {
        percentFormatter.string(from: value as NSDecimalNumber) ?? "0"
    }

    func topPercentageText(from details: [WalletAnalysisCategoryResponse]) -> String {
        guard let topPercentage = details.map(\.percentage).max() else { return "%0" }
        return "%\(formatPercent(topPercentage))"
    }
}
