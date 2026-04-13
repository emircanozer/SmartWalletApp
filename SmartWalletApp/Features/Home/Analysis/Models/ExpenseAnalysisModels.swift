import UIKit

struct ExpenseAnalysisSummaryItem {
    let title: String
    let value: String
    let iconName: String
}

struct ExpenseAnalysisCategoryItem {
    let name: String
    let amountText: String
    let percentageText: String
    let progress: CGFloat
    let color: UIColor
}

struct ExpenseAnalysisChartSlice {
    let label: String
    let value: Double
    let color: UIColor
}

struct ExpenseAnalysisViewData {
    let titleText: String
    let totalExpenseText: String
    let emptyMessageText: String?
    let summaryItems: [ExpenseAnalysisSummaryItem]
    let chartSlices: [ExpenseAnalysisChartSlice]
    let categoryItems: [ExpenseAnalysisCategoryItem]
    let aiInsightTitle: String
    let aiInsightBody: String
}

enum ExpenseAnalysisViewState {
    case idle
    case loading
    case loaded(ExpenseAnalysisViewData)
}
