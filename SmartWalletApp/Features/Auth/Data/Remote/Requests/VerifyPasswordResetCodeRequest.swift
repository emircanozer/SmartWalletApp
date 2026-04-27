import Foundation

struct VerifyPasswordResetCodeRequest: Encodable {
    let email: String
    let code: String
}
