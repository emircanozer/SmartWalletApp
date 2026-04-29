import Foundation

struct PortfolioAssetResponse: Decodable {
    let assetType: Int
    let amount: Decimal
    let currentPrice: Decimal
    let averageCost: Decimal
    let totalValue: Decimal
    let profitLoss: Decimal
    let profitLossPercentage: Decimal
}
