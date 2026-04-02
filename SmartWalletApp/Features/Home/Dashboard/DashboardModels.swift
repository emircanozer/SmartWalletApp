import UIKit

// response body tek başına yetmez bunları çizmek için bunların ui modeli de gerekiyor ikon renk isim ayrımı vs mapping
enum TransactionCategory {
    case market
    case restaurant
    case salary
    case transfer
    case other

    // backende sayı olarak döndüğü için bu enumlar biz de burada böyle eşitliyoruz
    init(backendValue: Int) {
        switch backendValue {
        case 1:
            self = .market
        case 2:
            self = .restaurant
        case 3:
            self = .salary
        case 7:
            self = .transfer
        default:
            self = .other
        }
    }

    var title: String {
        switch self {
        case .market:
            return "Market Alışverişi"
        case .restaurant:
            return "Restoran"
        case .salary:
            return "Maaş Ödemesi"
        case .transfer:
            return "Para Transferi"
        case .other:
            return "Diğer İşlem"
        }
    }

    var badgeTitle: String {
        switch self {
        case .market:
            return "Market"
        case .restaurant:
            return "Yeme-İçme"
        case .salary:
            return "Gelir"
        case .transfer:
            return "Transfer"
        case .other:
            return "Diğer"
        }
    }

    var iconName: String {
        switch self {
        case .market:
            return "basket"
        case .restaurant:
            return "fork.knife"
        case .salary:
            return "banknote"
        case .transfer:
            return "arrow.left.arrow.right"
        case .other:
            return "creditcard"
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .market:
            return UIColor(red: 0.91, green: 0.33, blue: 0.31, alpha: 1.0)
        case .restaurant:
            return UIColor(red: 0.92, green: 0.53, blue: 0.18, alpha: 1.0)
        case .salary:
            return UIColor(red: 0.28, green: 0.73, blue: 0.39, alpha: 1.0)
        case .transfer:
            return UIColor(red: 0.29, green: 0.49, blue: 0.9, alpha: 1.0)
        case .other:
            return UIColor(red: 0.41, green: 0.44, blue: 0.52, alpha: 1.0)
        }
    }

    var iconBackgroundColor: UIColor {
        switch self {
        case .market:
            return UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 1.0)
        case .restaurant:
            return UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)
        case .salary:
            return UIColor(red: 0.93, green: 0.99, blue: 0.94, alpha: 1.0)
        case .transfer:
            return UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1.0)
        case .other:
            return UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)
        }
    }
}

enum DashboardQuickActionType {
    case sendMoney
    case requestMoney
    case aiAssistant
    case analysis
}

struct DashboardQuickAction {
    let type: DashboardQuickActionType
    let title: String
    let iconName: String
    let isHighlighted: Bool
}

// for cell 
struct DashboardTransaction {
    let id: String
    let title: String
    let subtitle: String
    let date: Date
    let dateText: String
    let categoryBadgeText: String
    let amount: Decimal
    let amountText: String
    let isIncome: Bool
    let category: TransactionCategory
}

//ui tarafına ekrana koyacağımız model response modellerini bu modele çevirdik 
struct DashboardViewData {
    let greetingText: String
    let ibanText: String
    let balanceText: String
    let currencyText: String
    let previewTransactions: [DashboardTransaction]
    let allTransactions: [DashboardTransaction]
}
