import Foundation

struct PortfolioSummaryResponse: Decodable {
    let totalPortfolioValue: Decimal
    let totalProfitLoss: Decimal
    let profitLossPercentage: Decimal
    let preciousMetalsPercentage: Decimal
    let fiatCurrencyPercentage: Decimal
    let assets: [PortfolioAssetResponse]
}
