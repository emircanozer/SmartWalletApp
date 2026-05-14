import Foundation

enum SplashViewState {
    case loaded(SplashViewData)
}

struct SplashViewData {
    let titleText: String
    let subtitleText: String
    let footerText: String
    let logoImageName: String
}
