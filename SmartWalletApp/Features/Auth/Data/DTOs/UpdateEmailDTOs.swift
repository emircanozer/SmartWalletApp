import Foundation

struct UpdateEmailRequest: Encodable {
    let newEmail: String
    let confirmEmail: String
}

struct UpdateEmailResponse: Decodable {
    let message: String
}
