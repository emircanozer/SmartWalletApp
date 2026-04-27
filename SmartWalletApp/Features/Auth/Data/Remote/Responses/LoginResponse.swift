import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let refreshTokenExpiration: String

    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case refreshTokenExpiration
        case capitalizedAccessToken = "AccessToken"
        case capitalizedRefreshToken = "RefreshToken"
        case capitalizedRefreshTokenExpiration = "RefreshTokenExpiration"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken =
            (try? container.decode(String.self, forKey: .accessToken)) ??
            (try? container.decode(String.self, forKey: .capitalizedAccessToken)) ??
            ""
        refreshToken =
            (try? container.decode(String.self, forKey: .refreshToken)) ??
            (try? container.decode(String.self, forKey: .capitalizedRefreshToken)) ??
            ""
        refreshTokenExpiration =
            (try? container.decode(String.self, forKey: .refreshTokenExpiration)) ??
            (try? container.decode(String.self, forKey: .capitalizedRefreshTokenExpiration)) ??
            ""
    }
}
