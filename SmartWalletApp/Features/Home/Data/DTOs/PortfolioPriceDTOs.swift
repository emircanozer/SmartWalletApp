import Foundation

// piyasalar dto 
struct PortfolioPriceResponse: Decodable {
    let assetType: Int
    let buyPrice: Decimal
    let sellPrice: Decimal
    let dailyChangePercentage: Decimal
}
