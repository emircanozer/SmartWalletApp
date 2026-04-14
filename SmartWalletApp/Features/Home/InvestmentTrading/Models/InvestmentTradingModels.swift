import UIKit

enum InvestmentTradingViewState {
    case idle
    case loading
    case loaded(InvestmentTradingViewData)
    case failure(String)
}

enum InvestmentTradeDirection {
    case buy
    case sell

    var title: String {
        switch self {
        case .buy:
            return "Al"
        case .sell:
            return "Sat"
        }
    }

    var confirmationTitle: String {
        switch self {
        case .buy:
            return "Alım"
        case .sell:
            return "Satım"
        }
    }
}

enum InvestmentTradingInputMode {
    case quantity
    case fiat

    var title: String {
        switch self {
        case .quantity:
            return "Birim"
        case .fiat:
            return "TL"
        }
    }

    var isFiatAmount: Bool {
        switch self {
        case .quantity:
            return false
        case .fiat:
            return true
        }
    }
}

//chip butonlar için enum ama butona doğrudan burdan veri vermiyoruz aşağıda
enum InvestmentTradingAssetType: CaseIterable {
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

    static var allCases: [InvestmentTradingAssetType] {
        [.gold, .silver, .usd, .eur, .gbp, .chf, .sar, .kwd]
    }

    var backendValue: Int {
        switch self {
        case .gold:
            return 1
        case .silver:
            return 2
        case .usd:
            return 3
        case .eur:
            return 4
        case .gbp:
            return 5
        case .chf:
            return 6
        case .sar:
            return 7
        case .kwd:
            return 8
        case .other(let value):
            return value
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
            return "Euro"
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

    var displayCode: String {
        switch self {
        case .eur:
            return "EUR"
        default:
            return title.uppercased()
        }
    }

    var amountUnit: String {
        switch self {
        case .gold, .silver:
            return "gr"
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
            return "adet"
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

    var marketCode: String {
        switch self {
        case .gold:
            return "XAU"
        case .silver:
            return "XAG"
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
            return "VARLIK-\(value)"
        }
    }

    var supportsFiatInput: Bool {
        true
    }
}

// chip butonların çektiği ui verisi 
struct InvestmentTradingAssetChipItem {
    let assetType: InvestmentTradingAssetType
    let title: String
    let isSelected: Bool
}

struct InvestmentTradingQuickAmountItem {
    let value: Decimal
    let title: String
}

struct InvestmentTradingSummaryRowItem {
    let title: String
    let value: String
}

struct InvestmentTradingViewData {
    let titleText: String
    let subtitleText: String
    let assetItems: [InvestmentTradingAssetChipItem]
    let selectedDirection: InvestmentTradeDirection
    let selectedInputMode: InvestmentTradingInputMode
    let buyPriceText: String
    let sellPriceText: String
    let balanceText: String
    let holdingText: String
    let amountText: String
    let amountTitleText: String
    let amountPlaceholderText: String
    let amountUnitText: String
    let quantityOptionTitle: String
    let quickAmountItems: [InvestmentTradingQuickAmountItem]
    let summaryRows: [InvestmentTradingSummaryRowItem]
    let estimateTitleText: String
    let estimateValueText: String
    let actionButtonTitle: String
    let isActionEnabled: Bool
    let validationMessageText: String?
    let emptyMessageText: String?
}

struct InvestmentTradeContext {
    let request: PortfolioTradeRequest
    let assetType: InvestmentTradingAssetType
    let direction: InvestmentTradeDirection
    let inputMode: InvestmentTradingInputMode
    let unitPrice: Decimal
    let enteredAmount: Decimal
    let assetAmount: Decimal
    let totalAmount: Decimal
    let currentBalance: Decimal
    let resultingBalance: Decimal
}
