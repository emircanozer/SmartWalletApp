import Foundation

enum ChangePasswordViewState {
    case idle
    case formUpdated(ChangePasswordFormState)
    case loading
    case success(String)
    case failure(String)
}

struct ChangePasswordFormState {
    let isUpdateEnabled: Bool
    let confirmPasswordErrorText: String?
}

struct ChangePasswordViewData {
    let titleText: String
    let headlineText: String
    let descriptionText: String
    let currentPasswordTitleText: String
    let currentPasswordPlaceholderText: String
    let newPasswordTitleText: String
    let newPasswordPlaceholderText: String
    let newPasswordHelperText: String
    let confirmPasswordTitleText: String
    let confirmPasswordPlaceholderText: String
    let updateButtonTitleText: String
    let forgotPasswordTitleText: String
}
