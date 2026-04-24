import Foundation

struct DeleteAccountRequest: Encodable {
    let password: String
}

struct DeleteAccountResponse: Decodable {
    let message: String
    let success: Bool
}
