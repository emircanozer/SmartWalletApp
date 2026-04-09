import Foundation

// backend response'unu decode etmek için gereken model ui modeli değil 

struct PortfolioSummaryResponse: Decodable {
    let totalPortfolioValue: Decimal
    let totalProfitLoss: Decimal
    let profitLossPercentage: Decimal
    let preciousMetalsPercentage: Decimal
    let fiatCurrencyPercentage: Decimal
    let assets: [PortfolioAssetResponse]
}

// varlıklarım için
struct PortfolioAssetResponse: Decodable {
    let assetType: Int
    let amount: Decimal
    let currentPrice: Decimal
    let averageCost: Decimal
    let totalValue: Decimal
    let profitLoss: Decimal
    let profitLossPercentage: Decimal
}
