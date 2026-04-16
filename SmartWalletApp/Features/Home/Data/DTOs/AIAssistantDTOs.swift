import Foundation

struct AssistantChatResponse: Decodable {
    let reply: String
    let isActionExecuted: Bool
    let actionType: String?
}
