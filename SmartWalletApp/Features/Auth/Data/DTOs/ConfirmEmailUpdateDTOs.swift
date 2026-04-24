import Foundation

struct ConfirmEmailUpdateRequest: Encodable {
    let code: String
}

struct ConfirmEmailUpdateResponse: Decodable {
    let message: String
    let success: Bool
}
