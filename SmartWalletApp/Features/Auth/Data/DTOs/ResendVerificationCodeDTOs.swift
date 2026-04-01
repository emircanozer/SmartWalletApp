import Foundation

struct ResendVerificationCodeRequest: Encodable {
    let email: String
}

struct ResendVerificationCodeResponse: Decodable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
        case messageUppercased = "Message"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message =
            try container.decodeIfPresent(String.self, forKey: .message)
            ?? container.decode(String.self, forKey: .messageUppercased)
    }
}
