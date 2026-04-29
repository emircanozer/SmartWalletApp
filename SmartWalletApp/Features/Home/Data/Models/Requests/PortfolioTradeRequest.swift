import Foundation

struct PortfolioTradeRequest: Encodable {
    let assetType: Int
    let amount: Decimal
    let isFiatAmount: Bool
}
