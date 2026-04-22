import Foundation

enum ContactUsViewState {
    case idle
    case formUpdated(isSendEnabled: Bool)
    case mailDraft(ContactUsMailDraft)
    case failure(String)
}

struct ContactUsViewData {
    let titleText: String
    let subtitleText: String
    let nameTitleText: String
    let namePlaceholderText: String
    let emailTitleText: String
    let emailPlaceholderText: String
    let messageTitleText: String
    let messagePlaceholderText: String
    let sendButtonTitleText: String
}

struct ContactUsMailDraft {
    let recipient: String
    let subject: String
    let body: String
}
