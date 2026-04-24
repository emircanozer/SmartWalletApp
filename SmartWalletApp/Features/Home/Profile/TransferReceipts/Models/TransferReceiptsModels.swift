import UIKit

enum TransferReceiptsViewState {
    case idle
    case loading
    case loaded(TransferReceiptsViewData)
    case failure(String)
}

enum TransferReceiptsDateFilter: CaseIterable {
    case all
    case last7Days
    case last15Days
    case last30Days
    case last3Months
    case last6Months

    var title: String {
        switch self {
        case .all:
            return "Tarih Aralığı"
        case .last7Days:
            return "Son 7 Gün"
        case .last15Days:
            return "Son 15 Gün"
        case .last30Days:
            return "Son 30 Gün"
        case .last3Months:
            return "Son 3 Ay"
        case .last6Months:
            return "Son 6 Ay"
        }
    }
}

enum TransferReceiptsTypeFilter: CaseIterable {
    case all
    case incoming
    case outgoing

    var title: String {
        switch self {
        case .all:
            return "İşlem Tipi"
        case .incoming:
            return "Gelen Transfer"
        case .outgoing:
            return "Giden Transfer"
        }
    }
}

struct TransferReceiptsItemViewData {
    let id: String
    let iconName: String
    let iconTintColor: UIColor
    let iconBackgroundColor: UIColor
    let typeText: String
    let titleText: String
    let amountText: String
    let amountColor: UIColor
    let dateText: String
    let detailButtonTitleText: String
}

struct TransferReceiptsViewData {
    let titleText: String
    let descriptionText: String
    let searchPlaceholderText: String
    let selectedDateFilterTitleText: String
    let selectedTypeFilterTitleText: String
    let sectionTitleText: String
    let items: [TransferReceiptsItemViewData]
    let emptyMessageText: String?
}
