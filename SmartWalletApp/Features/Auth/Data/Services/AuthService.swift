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

    func forgotPassword(request: ForgotPasswordRequest) async throws -> ForgotPasswordResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.forgotPassword(body: body), as: ForgotPasswordResponse.self)
    }

    func verifyPasswordResetCode(request: VerifyPasswordResetCodeRequest) async throws -> VerifyPasswordResetCodeResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.verifyPasswordResetCode(body: body), as: VerifyPasswordResetCodeResponse.self)
    }

    func resetPassword(request: ResetPasswordRequest) async throws -> ResetPasswordResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.resetPassword(body: body), as: ResetPasswordResponse.self)
    }

    func fetchProfile() async throws -> ProfileResponse {
        try await apiClient.send(AuthEndpoint.profile, as: ProfileResponse.self)
    }

    func fetchLastFailedLogin() async throws -> LastFailedLoginResponse {
        try await apiClient.send(AuthEndpoint.lastFailedLogin, as: LastFailedLoginResponse.self)
    }

    func logout() async throws -> LogoutResponse {
        try await apiClient.send(AuthEndpoint.logout, as: LogoutResponse.self)
    }

    func deleteAccount(request: DeleteAccountRequest) async throws -> DeleteAccountResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.deleteAccount(body: body), as: DeleteAccountResponse.self)
    }

    func changePassword(request: ChangePasswordRequest) async throws -> ChangePasswordResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.changePassword(body: body), as: ChangePasswordResponse.self)
    }

    func updateEmail(request: UpdateEmailRequest) async throws -> UpdateEmailResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.updateEmail(body: body), as: UpdateEmailResponse.self)
    }

    func confirmEmailUpdate(request: ConfirmEmailUpdateRequest) async throws -> ConfirmEmailUpdateResponse {
        let body = try encode(request)
        return try await apiClient.send(AuthEndpoint.confirmEmailUpdate(body: body), as: ConfirmEmailUpdateResponse.self)
    }
}

 enum AuthEndpoint: Endpoint {
    // hepsi post parametrelerden anlayabilirsin
    case register(body: Data)
    case login(body: Data)
    case verifyEmail(body: Data)
    case resendVerificationCode(body: Data)
    case forgotPassword(body: Data)
    case verifyPasswordResetCode(body: Data)
    case resetPassword(body: Data)
    case profile
    case lastFailedLogin
    case logout
    case deleteAccount(body: Data)
    case changePassword(body: Data)
    case updateEmail(body: Data)
    case confirmEmailUpdate(body: Data)

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
        case .verifyPasswordResetCode:
            return "/api/Auth/verify-code"
        case .resetPassword:
            return "/api/Auth/reset-password"
        case .profile:
            return "/api/Auth/profile"
        case .lastFailedLogin:
            return "/api/Auth/last-failed-login"
        case .logout:
            return "/api/Auth/logout"
        case .deleteAccount:
            return "/api/Auth/delete-account"
        case .changePassword:
            return "/api/Auth/change-password-profile"
        case .updateEmail:
            return "/api/Auth/update-email"
        case .confirmEmailUpdate:
            return "/api/Auth/confirm-email-update"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile, .lastFailedLogin:
            return .get
        case .logout:
            return .post
        case .deleteAccount, .changePassword, .updateEmail, .confirmEmailUpdate:
            return .post
        default:
            return .post
        }
    }

    var body: Data? {
        switch self {
        case .register(let body), .login(let body), .verifyEmail(let body), .resendVerificationCode(let body), .forgotPassword(let body), .verifyPasswordResetCode(let body), .resetPassword(let body), .deleteAccount(let body), .changePassword(let body), .updateEmail(let body), .confirmEmailUpdate(let body):
            return body
        case .profile, .lastFailedLogin, .logout:
            return nil
        }
    }

    var requiresAuthorization: Bool {
        switch self {
        case .profile, .lastFailedLogin, .logout, .deleteAccount, .changePassword, .updateEmail, .confirmEmailUpdate:
            return true
        default:
            return false
        }
    }
}

// encode yapar post için requestleri burada encode yani Json Data'ya çeviriyoruz generic endodable olan her model ile çalışılır !!
 extension AuthService {
    func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
