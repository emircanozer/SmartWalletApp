import Foundation

struct VerifyEmailRequest: Encodable {
    let email: String
    let code: String
}
