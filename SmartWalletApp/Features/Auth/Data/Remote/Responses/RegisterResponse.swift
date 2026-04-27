import Foundation

struct RegisterResponse: Decodable {
    let userId: String
    let walletId: String
    let iban: String
}
