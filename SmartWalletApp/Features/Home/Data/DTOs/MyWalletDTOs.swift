import Foundation

struct MyWalletResponse: Decodable {
    let id: String
    let iban: String
    let balance: Decimal
    let fullName: String
}
