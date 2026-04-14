import Foundation

// backend dtosu olduğu için hepsi bu folder'da tanımlanıyor ama ui modeli feature dosyasının içinde yazıldı 
struct PortfolioTradeRequest: Encodable {
    let assetType: Int
    let amount: Decimal
    let isFiatAmount: Bool
}

struct PortfolioTradeResponse: Decodable {
    let success: Bool
    let message: String
}
