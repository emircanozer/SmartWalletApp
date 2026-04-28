import Foundation
import UIKit

final class ExpenseAnalysisViewModel {
    var onStateChange: ((ExpenseAnalysisViewState) -> Void)?

    private let walletService: WalletService
    private let chartColors: [UIColor] = [
        UIColor(red: 0.56, green: 0.73, blue: 0.98, alpha: 1),
        UIColor(red: 0.98, green: 0.74, blue: 0.43, alpha: 1),
        UIColor(red: 0.77, green: 0.67, blue: 0.97, alpha: 1),
        UIColor(red: 0.62, green: 0.93, blue: 0.69, alpha: 1),
        UIColor(red: 0.97, green: 0.63, blue: 0.66, alpha: 1)
    ]

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let response = try await walletService.fetchAnalysis()
            let viewData = map(response)
            onStateChange?(.loaded(viewData))

            guard viewData.emptyMessageText == nil else { return }

            onStateChange?(.aiInsightLoading)

            do {
                let adviceResponse = try await walletService.fetchAIAdvice()
                onStateChange?(
                    .aiInsightLoaded(
                        ExpenseAnalysisAIInsightViewData(
                            titleText: "YAPAY ZEKA ANALİZİ",
                            bodyText: adviceResponse.advice
                        )
                    )
                )
            } catch {
                onStateChange?(.aiInsightFailed("Yapay zeka tavsiyesi şu anda alınamıyor."))
            }
        } catch {
            onStateChange?(
                .loaded(
                    ExpenseAnalysisViewData(
                        titleText: "Harcama Analizi",
                        totalExpenseText: "₺0",
                        emptyMessageText: "Henüz bir harcamanız yok.",
                        summaryItems: [],
                        chartSlices: [],
                        categoryItems: []
                    )
                )
            )
        }
    }
}

// ham response u ui modeline çeviriyoruz
 extension ExpenseAnalysisViewModel {
    func map(_ response: WalletAnalysisResponse) -> ExpenseAnalysisViewData {
        let isEmpty = (response.totalMonthlyExpense as NSDecimalNumber).decimalValue == .zero || response.categoryDetails.isEmpty

        let summaryItems = [
            ExpenseAnalysisSummaryItem(
                title: "Aylık Harcama",
                value: AppNumberTextFormatter.currencyTRY(
                    response.totalMonthlyExpense,
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0
                ),
                iconName: "creditcard"
            ),
            ExpenseAnalysisSummaryItem(
                title: "Günlük Ortalama",
                value: AppNumberTextFormatter.currencyTRY(
                    response.dailyAverageExpense,
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0
                ),
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
                amountText: AppNumberTextFormatter.currencyTRY(
                    item.totalAmount,
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0
                ),
                percentageText: "%\(AppNumberTextFormatter.decimal(item.percentage, minimumFractionDigits: 0, maximumFractionDigits: 1))",
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
            totalExpenseText: AppNumberTextFormatter.currencyTRY(
                response.totalMonthlyExpense,
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            ),
            emptyMessageText: isEmpty ? "Henüz bir harcamanız yok." : nil,
            summaryItems: summaryItems,
            chartSlices: chartSlices,
            categoryItems: categoryItems
        )
    }

    func topPercentageText(from details: [WalletAnalysisCategoryResponse]) -> String {
        guard let topPercentage = details.map(\.percentage).max() else { return "%0" }
        return "%\(AppNumberTextFormatter.decimal(topPercentage, minimumFractionDigits: 0, maximumFractionDigits: 1))"
    }
}
