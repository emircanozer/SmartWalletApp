import UIKit

enum MarketPricesViewState {
    case idle
    case loading
    case loaded(MarketPricesViewData)
    case failure(String)
}

enum MarketAssetType {
    case gold
    case silver
    case usd
    case eur
    case gbp
    case chf
    case sar
    case kwd
    case other(Int)

    init(backendValue: Int) {
        switch backendValue {
        case 1:
            self = .gold
        case 2:
            self = .silver
        case 3:
            self = .usd
        case 4:
            self = .eur
        case 5:
            self = .gbp
        case 6:
            self = .chf
        case 7:
            self = .sar
        case 8:
            self = .kwd
        default:
            self = .other(backendValue)
        }
    }

    var title: String {
        switch self {
        case .gold:
            return "Altın"
        case .silver:
            return "Gümüş"
        case .usd:
            return "USD"
        case .eur:
            return "EUR"
        case .gbp:
            return "GBP"
        case .chf:
            return "CHF"
        case .sar:
            return "SAR"
        case .kwd:
            return "KWD"
        case .other(let value):
            return "Varlık \(value)"
        }
    }

    var subtitle: String {
        switch self {
        case .gold, .silver:
            return "Maden"
        case .usd, .eur, .gbp, .chf, .sar, .kwd:
            return "Döviz"
        case .other:
            return "Yatırım Aracı"
        }
    }

    var iconName: String {
        switch self {
        case .gold:
            return "medal.fill"
        case .silver:
            return "seal.fill"
        case .usd:
            return "dollarsign.circle.fill"
        case .eur:
            return "eurosign.circle.fill"
        case .gbp:
            return "sterlingsign.circle.fill"
        case .chf:
            return "francsign.circle.fill"
        case .sar:
            return "banknote.fill"
        case .kwd:
            return "creditcard.fill"
        case .other:
            return "chart.line.uptrend.xyaxis"
        }
    }

    var accentColor: UIColor {
        switch self {
        case .gold:
            return AppColor.accentGold
        case .silver:
            return UIColor(red: 0.62, green: 0.67, blue: 0.76, alpha: 1.0)
        case .usd, .sar, .kwd:
            return AppColor.accentOlive
        case .eur:
            return UIColor(red: 0.39, green: 0.58, blue: 0.86, alpha: 1.0)
        case .gbp:
            return UIColor(red: 0.53, green: 0.43, blue: 0.68, alpha: 1.0)
        case .chf:
            return UIColor(red: 0.76, green: 0.31, blue: 0.29, alpha: 1.0)
        case .other:
            return AppColor.iconMuted
        }
    }

    var surfaceColor: UIColor {
        switch self {
        case .gold:
            return AppColor.surfaceWarmSoft
        case .silver:
            return UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
        case .usd, .sar, .kwd:
            return UIColor(red: 0.98, green: 0.97, blue: 0.93, alpha: 1.0)
        case .eur:
            return UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        case .gbp:
            return UIColor(red: 0.97, green: 0.95, blue: 1.0, alpha: 1.0)
        case .chf:
            return UIColor(red: 1.0, green: 0.95, blue: 0.95, alpha: 1.0)
        case .other:
            return AppColor.surfaceMuted
        }
    }
}

// row data 
struct MarketPriceItem {
    let title: String
    let subtitle: String
    let iconName: String
    let accentColor: UIColor
    let iconSurfaceColor: UIColor
    let buyPriceText: String
    let sellPriceText: String
    let dailyChangeText: String
    let isPositiveChange: Bool
}

// ui modeli 
struct MarketPricesViewData {
    let titleText: String
    let items: [MarketPriceItem]
    let emptyMessageText: String?
}
