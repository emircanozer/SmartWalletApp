import UIKit

struct ExpenseAnalysisSummaryItem {
    let title: String
    let value: String
    let iconName: String
    let trailingValue: String?

    init(title: String, value: String, iconName: String, trailingValue: String? = nil) {
        self.title = title
        self.value = value
        self.iconName = iconName
        self.trailingValue = trailingValue
    }
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
}

struct ExpenseAnalysisAIInsightViewData {
    let titleText: String
    let bodyText: String
}

enum ExpenseAnalysisViewState {
    case idle
    case loading
    case loaded(ExpenseAnalysisViewData)
    case aiInsightLoading
    case aiInsightLoaded(ExpenseAnalysisAIInsightViewData)
    case aiInsightFailed(String)
}
