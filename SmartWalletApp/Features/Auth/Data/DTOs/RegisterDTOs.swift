import Foundation

struct RegisterRequest: Encodable {
    let name: String
    let email: String
    let password: String
}

struct RegisterResponse: Decodable {
    let userId: String
    let walletId: String
    let iban: String
}
