import Foundation

enum UpdateEmailViewState {
    case idle
    case formUpdated(UpdateEmailFormState)
    case loading
    case success(String, UpdateEmailVerificationContext)
    case failure(String)
}

struct UpdateEmailFormState {
    let isSendEnabled: Bool
    let confirmEmailErrorText: String?
}

struct UpdateEmailViewData {
    let titleText: String
    let descriptionText: String
    let currentEmailTitleText: String
    let currentEmailText: String
    let newEmailTitleText: String
    let newEmailPlaceholderText: String
    let confirmEmailTitleText: String
    let confirmEmailPlaceholderText: String
    let sendButtonTitleText: String
    let cancelButtonTitleText: String
}

struct UpdateEmailVerificationContext {
    let newEmail: String
    let confirmEmail: String
}
