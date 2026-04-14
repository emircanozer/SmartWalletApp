import UIKit

enum InvestmentPortfolioViewState {
    case idle
    case loading
    case loaded(InvestmentPortfolioViewData)
    case failure(String)
}

// backendden gelen veri int olduğu için burada bir kez daha custom yapıp ui ya verecez 
enum InvestmentAssetType {
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
            return "briefcase.fill"
        }
    }

    var accentColor: UIColor {
        switch self {
        case .gold:
            return AppColor.accentGold
        case .silver:
            return UIColor(red: 0.62, green: 0.67, blue: 0.76, alpha: 1.0)
        case .usd:
            return UIColor(red: 0.52, green: 0.41, blue: 0.12, alpha: 1.0)
        case .eur:
            return UIColor(red: 0.39, green: 0.58, blue: 0.86, alpha: 1.0)
        case .gbp:
            return UIColor(red: 0.53, green: 0.43, blue: 0.68, alpha: 1.0)
        case .chf:
            return UIColor(red: 0.76, green: 0.31, blue: 0.29, alpha: 1.0)
        case .sar, .kwd:
            return AppColor.accentOlive
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
        case .usd:
            return UIColor(red: 0.98, green: 0.97, blue: 0.93, alpha: 1.0)
        case .eur:
            return UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        case .gbp:
            return UIColor(red: 0.97, green: 0.95, blue: 1.0, alpha: 1.0)
        case .chf:
            return UIColor(red: 1.0, green: 0.95, blue: 0.95, alpha: 1.0)
        case .sar, .kwd:
            return UIColor(red: 0.98, green: 0.97, blue: 0.93, alpha: 1.0)
        case .other:
            return AppColor.surfaceMuted
        }
    }

    var amountUnit: String {
        switch self {
        case .gold, .silver:
            return "gr"
        case .usd, .eur, .gbp, .chf, .sar, .kwd:
            return "birim"
        case .other:
            return "adet"
        }
    }

    var allocationGroup: InvestmentAllocationGroup {
        switch self {
        case .gold:
            return .gold
        case .silver:
            return .silver
        case .usd:
            return .usd
        case .eur:
            return .eur
        case .gbp:
            return .gbp
        case .chf:
            return .chf
        case .sar:
            return .sar
        case .kwd:
            return .kwd
        case .other:
            return .other
        }
    }
}

enum InvestmentAllocationGroup: CaseIterable {
    case gold
    case silver
    case usd
    case eur
    case gbp
    case chf
    case sar
    case kwd
    case other

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
        case .other:
            return "Diğer"
        }
    }

    var color: UIColor {
        switch self {
        case .gold:
            return AppColor.accentGold
        case .silver:
            return UIColor(red: 0.62, green: 0.67, blue: 0.76, alpha: 1.0)
        case .usd:
            return UIColor(red: 0.52, green: 0.41, blue: 0.12, alpha: 1.0)
        case .eur:
            return UIColor(red: 0.39, green: 0.58, blue: 0.86, alpha: 1.0)
        case .gbp:
            return UIColor(red: 0.53, green: 0.43, blue: 0.68, alpha: 1.0)
        case .chf:
            return UIColor(red: 0.76, green: 0.31, blue: 0.29, alpha: 1.0)
        case .sar, .kwd:
            return AppColor.accentOlive
        case .other:
            return UIColor(red: 0.83, green: 0.85, blue: 0.9, alpha: 1.0)
        }
    }
}

struct InvestmentPortfolioAllocationItem {
    let title: String
    let percentageText: String
    let progress: CGFloat
    let color: UIColor
}

struct InvestmentPortfolioAssetItem {
    let title: String
    let subtitle: String
    let totalValueText: String
    let profitLossText: String
    let isProfit: Bool
    let iconName: String
    let accentColor: UIColor
    let iconSurfaceColor: UIColor
}

// ui modeline çevirdik
struct InvestmentPortfolioViewData {
    let titleText: String
    let totalPortfolioValueText: String
    let totalProfitLossText: String
    let totalProfitLossDetailText: String
    let isProfit: Bool
    let dominantShareText: String
    let allocationItems: [InvestmentPortfolioAllocationItem]
    let assetItems: [InvestmentPortfolioAssetItem]
    let emptyMessageText: String?
}
