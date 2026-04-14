import Foundation

struct WalletAnalysisResponse: Decodable {
    let totalMonthlyExpense: Decimal
    let dailyAverageExpense: Decimal
    let topSendingCategory: String
    let categoryDetails: [WalletAnalysisCategoryResponse]
    let aiAnalysisAdvice: String
}

struct WalletAnalysisCategoryResponse: Decodable {
    let categoryName: String
    let totalAmount: Decimal
    let percentage: Decimal
}
