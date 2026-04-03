import UIKit

// response body tek başına yetmez bunları çizmek için bunların ui modeli de gerekiyor ikon renk isim ayrımı vs mapping
enum TransactionCategory {
    case other
    case market
    case food
    case bill
    case entertainment
    case education
    case health
    case transfer

    // backende sayı olarak döndüğü için bu enumlar biz de burada böyle eşitliyoruz
    init(backendValue: Int) {
        switch backendValue {
        case 0:
            self = .other
        case 1:
            self = .market
        case 2:
            self = .food
        case 3:
            self = .bill
        case 4:
            self = .entertainment
        case 5:
            self = .education
        case 6:
            self = .health
        case 7:
            self = .transfer
        default:
            self = .other
        }
    }

    var title: String {
        switch self {
        case .other:
            return "Diğer İşlem"
        case .market:
            return "Market Alışverişi"
        case .food:
            return "Yeme İçme"
        case .bill:
            return "Fatura Ödemesi"
        case .entertainment:
            return "Eğlence"
        case .education:
            return "Eğitim"
        case .health:
            return "Sağlık"
        case .transfer:
            return "Para Transferi"
        }
    }

    func badgeTitle(isIncome: Bool) -> String {
        switch self {
        case .other:
            return isIncome ? "Gelir" : "Diğer"
        case .market:
            return "Market"
        case .food:
            return "Yeme-İçme"
        case .bill:
            return "Fatura"
        case .entertainment:
            return "Eğlence"
        case .education:
            return "Eğitim"
        case .health:
            return "Sağlık"
        case .transfer:
            return "Transfer"
        }
    }

    var iconName: String {
        switch self {
        case .other:
            return "creditcard"
        case .market:
            return "basket"
        case .food:
            return "fork.knife"
        case .bill:
            return "doc.text"
        case .entertainment:
            return "sparkles"
        case .education:
            return "book"
        case .health:
            return "cross.case"
        case .transfer:
            return "arrow.left.arrow.right"
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .other:
            return UIColor(red: 0.41, green: 0.44, blue: 0.52, alpha: 1.0)
        case .market:
            return UIColor(red: 0.91, green: 0.33, blue: 0.31, alpha: 1.0)
        case .food:
            return UIColor(red: 0.92, green: 0.53, blue: 0.18, alpha: 1.0)
        case .bill:
            return UIColor(red: 0.32, green: 0.47, blue: 0.91, alpha: 1.0)
        case .entertainment:
            return UIColor(red: 0.72, green: 0.38, blue: 0.9, alpha: 1.0)
        case .education:
            return UIColor(red: 0.24, green: 0.61, blue: 0.89, alpha: 1.0)
        case .health:
            return UIColor(red: 0.25, green: 0.66, blue: 0.53, alpha: 1.0)
        case .transfer:
            return UIColor(red: 0.29, green: 0.49, blue: 0.9, alpha: 1.0)
        }
    }

    var iconBackgroundColor: UIColor {
        switch self {
        case .other:
            return UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)
        case .market:
            return UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 1.0)
        case .food:
            return UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)
        case .bill:
            return UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1.0)
        case .entertainment:
            return UIColor(red: 0.98, green: 0.94, blue: 1.0, alpha: 1.0)
        case .education:
            return UIColor(red: 0.93, green: 0.97, blue: 1.0, alpha: 1.0)
        case .health:
            return UIColor(red: 0.93, green: 0.99, blue: 0.96, alpha: 1.0)
        case .transfer:
            return UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1.0)
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

// backenden dönen response ham model değil ekranın doğrudan kullanacağı ui modeli (for cell)
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

//ui tarafına ekrana koyacağımız model response modellerini bu modele çevirdik. aynı şekilde ham response model değil ui model
struct DashboardViewData {
    let greetingText: String
    let ibanText: String
    let balanceText: String
    let currencyText: String
    let previewTransactions: [DashboardTransaction]
    let allTransactions: [DashboardTransaction]
}
