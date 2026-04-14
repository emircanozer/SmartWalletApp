import UIKit

enum InvestmentTradeConfirmationViewState {
    case idle
    case loading
    case loaded(InvestmentTradeConfirmationViewData)
    case failure(String)
    case approved(InvestmentTradeSuccessContext)
}

struct InvestmentTradeConfirmationHighlightItem {
    let title: String
    let value: String
    let iconName: String?
}

struct InvestmentTradeConfirmationDetailItem {
    let title: String
    let value: String
    let valueColor: UIColor
}

// ui modeli 
struct InvestmentTradeConfirmationViewData {
    let titleText: String
    let subtitleText: String
    let highlightItems: [InvestmentTradeConfirmationHighlightItem]
    let detailItems: [InvestmentTradeConfirmationDetailItem]
    let noticeText: String
    let confirmButtonTitle: String
    let backButtonTitle: String
}

// context verisi bir sayfadan diğer sayfaya taşınacak veri closure ile taşınıp kordinatör ile gönderiliyor o da açılacak ekranın view modeline teslim ediyor 
struct InvestmentTradeSuccessContext {
    let assetName: String
    let assetDisplayName: String
    let directionTitle: String
    let amountText: String
    let totalAmountText: String
    let resultingBalanceText: String
    let subtitleText: String
}

/* bu ekranı açmak için gerekli tüm veri paketi diye düşün*/
