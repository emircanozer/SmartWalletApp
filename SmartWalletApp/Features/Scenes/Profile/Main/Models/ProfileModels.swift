import Foundation

enum ProfileViewState {
    case idle
    case loading
    case loaded(ProfileViewData)
    case logoutSucceeded
    case failure(String)
}

enum ProfileRowAccessory {
    case chevron
    case toggle(Bool)
    case none
}

enum ProfileRowAction {
    case financialGoals
    case security
    case privacy
    case transferReceipts
    case tradeHistory
    case changePassword
    case contactUs
    case deleteAccount
    case logout
}

struct ProfileHeaderViewData {
    let initialText: String
    let nameText: String
}

struct ProfileEmailViewData {
    let titleText: String
    let valueText: String
}

struct ProfileInfoCardViewData {
    let titleText: String
    let valueText: String
    let accentText: String?
}

struct ProfileRowItem {
    let titleText: String
    let iconName: String
    let accessory: ProfileRowAccessory
    let action: ProfileRowAction?
    let isDestructive: Bool
}

struct ProfileSectionViewData {
    let items: [ProfileRowItem]
}

struct ProfileViewData {
    let titleText: String
    let isDarkModeEnabled: Bool
    let header: ProfileHeaderViewData
    let email: ProfileEmailViewData
    let accountSection: ProfileSectionViewData
    let historySection: ProfileSectionViewData
    let supportSection: ProfileSectionViewData
    let lastFailedLoginCard: ProfileInfoCardViewData
    let logoutTitleText: String
}
