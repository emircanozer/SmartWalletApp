import Foundation

enum UpdateEmailCodeViewState {
    case idle
    case loading
    case success(String)
    case resendSuccess(String)
    case failure(String)
}

struct UpdateEmailCodeViewData {
    let brandText: String
    let titleText: String
    let subtitleText: String
    let verifyButtonTitleText: String
    let footerText: String
    let resendButtonTitleText: String
}
