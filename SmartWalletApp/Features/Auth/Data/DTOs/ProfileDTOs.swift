import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let email: String
    let initial: String
}

struct LastFailedLoginResponse: Decodable {
    let lastFailedLoginDate: String
    let message: String
}
