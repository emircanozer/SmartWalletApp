import Foundation

struct LastFailedLoginResponse: Decodable {
    let lastFailedLoginDate: String
    let message: String
}
