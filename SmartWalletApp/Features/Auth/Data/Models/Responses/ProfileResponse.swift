import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let email: String
    let initial: String
}
