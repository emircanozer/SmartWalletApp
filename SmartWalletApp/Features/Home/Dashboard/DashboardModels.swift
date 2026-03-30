import UIKit


// şimdilik mock veriler
enum TransactionCategory {
    case market
    case salary
    case restaurant

    var title: String {
        switch self {
        case .market:
            return "Market Alışverişi"
        case .salary:
            return "Maaş Ödemesi"
        case .restaurant:
            return "Restoran"
        }
    }

    var iconName: String {
        switch self {
        case .market:
            return "basket"
        case .salary:
            return "banknote"
        case .restaurant:
            return "fork.knife"
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .market, .restaurant:
            return UIColor(red: 0.85, green: 0.28, blue: 0.24, alpha: 1.0)
        case .salary:
            return UIColor(red: 0.55, green: 0.46, blue: 0.15, alpha: 1.0)
        }
    }

    var iconBackgroundColor: UIColor {
        switch self {
        case .market, .restaurant:
            return UIColor(red: 1.0, green: 0.97, blue: 0.97, alpha: 1.0)
        case .salary:
            return UIColor(red: 1.0, green: 0.98, blue: 0.91, alpha: 1.0)
        }
    }
}


//tableview için
struct DashboardTransaction {
    let category: TransactionCategory
    let dateText: String
    let amountText: String
    let isIncome: Bool
}

struct DashboardQuickAction {
    let title: String
    let iconName: String
    let isHighlighted: Bool
}
