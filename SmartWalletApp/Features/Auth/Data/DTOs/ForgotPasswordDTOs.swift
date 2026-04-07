import Foundation

struct ForgotPasswordRequest: Encodable {
    let email: String
}

struct ForgotPasswordResponse: Decodable {
    let message: String
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case message
        case success
        case capitalizedMessage = "Message"
        case capitalizedSuccess = "Success"
        case typoSuccess = "succes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message =
            (try? container.decode(String.self, forKey: .message)) ??
            (try? container.decode(String.self, forKey: .capitalizedMessage)) ??
            ""
        success =
            (try? container.decode(Bool.self, forKey: .success)) ??
            (try? container.decode(Bool.self, forKey: .capitalizedSuccess)) ??
            (try? container.decode(Bool.self, forKey: .typoSuccess)) ??
            false
    }
}
