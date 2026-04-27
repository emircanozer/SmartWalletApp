import Foundation
import UIKit

enum ExpenseAnalysisPresentationMapper {
    static let chartColors: [UIColor] = [
        UIColor(red: 0.56, green: 0.73, blue: 0.98, alpha: 1),
        UIColor(red: 0.98, green: 0.74, blue: 0.43, alpha: 1),
        UIColor(red: 0.77, green: 0.67, blue: 0.97, alpha: 1),
        UIColor(red: 0.62, green: 0.93, blue: 0.69, alpha: 1),
        UIColor(red: 0.97, green: 0.63, blue: 0.66, alpha: 1)
    ]

    static func makeViewData(from response: WalletAnalysisResponse) -> ExpenseAnalysisViewData {
        let isEmpty = (response.totalMonthlyExpense as NSDecimalNumber).decimalValue == .zero || response.categoryDetails.isEmpty

        let summaryItems = [
            ExpenseAnalysisSummaryItem(title: "Aylık Harcama", value: currency(response.totalMonthlyExpense), iconName: "creditcard"),
            ExpenseAnalysisSummaryItem(title: "Günlük Ortalama", value: currency(response.dailyAverageExpense), iconName: "calendar"),
            ExpenseAnalysisSummaryItem(title: "En Çok Harcama", value: response.topSendingCategory, iconName: "basket"),
            ExpenseAnalysisSummaryItem(title: "Harcama Yüzdesi", value: topPercentageText(from: response.categoryDetails), iconName: "percent")
        ]

        let categoryItems = response.categoryDetails.enumerated().map { index, item in
            ExpenseAnalysisCategoryItem(
                name: item.categoryName,
                amountText: currency(item.totalAmount),
                percentageText: "%\(percent(item.percentage))",
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
            totalExpenseText: currency(response.totalMonthlyExpense),
            emptyMessageText: isEmpty ? "Henüz bir harcamanız yok." : nil,
            summaryItems: summaryItems,
            chartSlices: chartSlices,
            categoryItems: categoryItems
        )
    }

    static func makeEmptyViewData() -> ExpenseAnalysisViewData {
        ExpenseAnalysisViewData(
            titleText: "Harcama Analizi",
            totalExpenseText: "₺0",
            emptyMessageText: "Henüz bir harcamanız yok.",
            summaryItems: [],
            chartSlices: [],
            categoryItems: []
        )
    }

    static func makeAIInsightViewData(from response: WalletAIAdviceResponse) -> ExpenseAnalysisAIInsightViewData {
        ExpenseAnalysisAIInsightViewData(titleText: "YAPAY ZEKA ANALİZİ", bodyText: response.advice)
    }

    private static func currency(_ value: Decimal) -> String {
        AppNumberTextFormatter.currencyTRY(value, minimumFractionDigits: 0, maximumFractionDigits: 0)
    }

    private static func percent(_ value: Decimal) -> String {
        AppNumberTextFormatter.decimal(value, minimumFractionDigits: 0, maximumFractionDigits: 1)
    }

    private static func topPercentageText(from details: [WalletAnalysisCategoryResponse]) -> String {
        guard let topPercentage = details.map(\.percentage).max() else { return "%0" }
        return "%\(percent(topPercentage))"
    }
}
