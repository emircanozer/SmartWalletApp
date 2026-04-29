import Foundation

struct WalletAnalysisCategoryResponse: Decodable {
    let categoryName: String
    let totalAmount: Decimal
    let percentage: Decimal
}
