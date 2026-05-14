import Foundation

struct PrivacySectionViewData {
    let titleText: String
    let bodyText: String
}

struct PrivacyViewData {
    let brandText: String
    let titleText: String
    let subtitleText: String
    let sections: [PrivacySectionViewData]
}
