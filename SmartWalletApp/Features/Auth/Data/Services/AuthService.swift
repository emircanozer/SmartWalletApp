import Foundation

final class AuthService {
    private let apiClient: APIClient
    private let encoder = JSONEncoder()

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        // AppCoordinator’dan injection alıyor
    }

    func register(request: RegisterRequest) async throws -> RegisterResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.register(body: body), as: RegisterResponse.self)
    }

    // backende gitmesi gerekiyor post istek encode edilecek(body) sonrasında response dönecek decode edilcek
    func login(request: LoginRequest) async throws -> LoginResponse {
        let body = try encode(request)
        /*networkmanagerde tanımladığımız generic olan send fonksiyonu burada ve aşağıda
         kullanım şekillerini görüyorsun her fonksiyon response istediği modele göre as'a
         yazıp kullanmış endpointini de belirtmiş çok kullanışlı */
        return try await apiClient.send(AuthEndpoint.login(body: body), as: LoginResponse.self)
    }

    func verifyEmail(request: VerifyEmailRequest) async throws -> VerifyEmailResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.verifyEmail(body: body), as: VerifyEmailResponse.self)
    }

    func resendVerificationCode(request: ResendVerificationCodeRequest) async throws -> ResendVerificationCodeResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.resendVerificationCode(body: body), as: ResendVerificationCodeResponse.self)
    }

    func forgotPassword(request: ForgotPasswordRequest) async throws {
        let body = try encode(request)
        try await apiClient.send(AuthEndpoint.forgotPassword(body: body))
    }
}

private enum AuthEndpoint: Endpoint {
    case register(body: Data)
    case login(body: Data)
    case verifyEmail(body: Data)
    case resendVerificationCode(body: Data)
    case forgotPassword(body: Data)

    var path: String {
        switch self {
        case .register:
            return "/api/Auth/register"
        case .login:
            return "/api/Auth/login"
        case .verifyEmail:
            return "/api/Auth/verify-email"
        case .resendVerificationCode:
            return "/api/Auth/resend-verification-code"
        case .forgotPassword:
            return "/api/Auth/forgot-password"
        }
    }

    var method: HTTPMethod {
        .post
    }

    var body: Data? {
        switch self {
        case .register(let body), .login(let body), .verifyEmail(let body), .resendVerificationCode(let body), .forgotPassword(let body):
            return body
        }
    }
}

 extension AuthService {
    func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
