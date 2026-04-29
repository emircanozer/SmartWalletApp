import Foundation

struct ChangePasswordRequest: Encodable {
    let currentPassword: String
    let newPassword: String
    let confirmNewPassword: String
}
