import Foundation

struct ResetPasswordRequest: Encodable {
    let email: String
    let code: String
    let newPassword: String
}
