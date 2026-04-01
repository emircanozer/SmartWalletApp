import Foundation

struct VerifyEmailRequest: Encodable {
    let email: String
    let code: String
}

struct VerifyEmailResponse: Decodable {
    let message: String
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case message
        case success
        case capitalizedMessage = "Message"
        case capitalizedSuccess = "Success"
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
            false
    }
    /* DTO'daki initleri yazma sebebimiz :
     backend bazen message
     bazen Message
     dönebiliyor.
     Standart decode ile tek bir key beklersek patlar. O yüzden özel init(from:) ile
     önce küçük harfli key’e bak
     yoksa büyük harfliye bak
     diyoruz.
*/
}
