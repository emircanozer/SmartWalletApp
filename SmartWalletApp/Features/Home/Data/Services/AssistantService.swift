import Foundation

final class AssistantService {
    private let apiClient: APIClient
    private let encoder = JSONEncoder()

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func sendMessage(_ message: String) async throws -> AssistantChatResponse {
        let body = try encoder.encode(message)
        return try await apiClient.send(AssistantEndpoint.chat(body: body), as: AssistantChatResponse.self)
    }
}

private enum AssistantEndpoint: Endpoint {
    case chat(body: Data)

    var path: String {
        switch self {
        case .chat:
            return "/api/Assistant/chat"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .chat:
            return .post
        }
    }

    var body: Data? {
        switch self {
        case .chat(let body):
            return body
        }
    }

    var requiresAuthorization: Bool {
        true
    }
}
