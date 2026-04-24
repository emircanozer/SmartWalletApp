import Foundation

enum DeleteAccountViewState {
    case idle
    case loading
    case deleted(String)
    case failure(String)
}

struct DeleteAccountDeletedItem {
    let title: String
    let iconName: String
}

struct DeleteAccountViewData {
    let titleText: String
    let warningTitleText: String
    let warningBodyText: String
    let deletedItemsTitleText: String
    let deletedItems: [DeleteAccountDeletedItem]
    let securityTitleText: String
    let confirmationText: String
    let deleteButtonTitleText: String
    let cancelButtonTitleText: String
}
