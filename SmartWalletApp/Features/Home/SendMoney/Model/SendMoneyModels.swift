import Foundation

enum SendMoneyTransferCategory: CaseIterable, Equatable {
    case other
    case market
    case food
    case bill
    case entertainment
    case education
    case health
    case transfer
    case rentPayment
    
    // backendden döner değerler int bir şey ifade etmediği için bir kez daha burada çevirme yapıyoruz 

    var backendValue: Int {
        switch self {
        case .other:
            return 0
        case .market:
            return 1
        case .food:
            return 2
        case .bill:
            return 3
        case .entertainment:
            return 4
        case .education:
            return 5
        case .health:
            return 6
        case .transfer:
            return 7
        case .rentPayment:
            return 8
        }
    }

    var title: String {
        switch self {
        case .other:
            return "Diğer"
        case .market:
            return "Market"
        case .food:
            return "Yemek"
        case .bill:
            return "Fatura"
        case .entertainment:
            return "Eğlence"
        case .education:
            return "Eğitim"
        case .health:
            return "Sağlık"
        case .transfer:
            return "Bireysel Ödeme"
        case .rentPayment:
            return "Kira Ödemesi"
        }
    }

    var subtitle: String {
        switch self {
        case .other:
            return "Diğer işlemler için"
        case .market:
            return "Market ve alışveriş"
        case .food:
            return "Yeme içme harcamaları"
        case .bill:
            return "Fatura ve ödeme işlemleri"
        case .entertainment:
            return "Eğlence harcamaları"
        case .education:
            return "Eğitim ödemeleri"
        case .health:
            return "Sağlık harcamaları"
        case .transfer:
            return "Bireysel para transferi"
        case .rentPayment:
            return "Kira ödemeleri için"
        }
    }
}

struct SendMoneyRecipient: Equatable {
    let id: String
    let name: String
    let ownerMaskedName: String
    let subtitle: String
    let iban: String
    let isSaved: Bool
}

// alt taraftaki model
struct SendMoneyLookupRecipient: Equatable {
    let ownerMaskedName: String
    let maskedIban: String
    let iban: String
    let isSaved: Bool
}

//ui model
struct SendMoneyViewData {
    let balanceText: String
    let amountText: String
    let selectedAmount: Decimal
    let quickAmounts: [Decimal]
    let recipients: [SendMoneyRecipient]
    let selectedRecipientID: String?
    let enteredIBAN: String
    let lookupRecipient: SendMoneyLookupRecipient?
    let selectedCategoryTitle: String
    let selectedCategory: SendMoneyTransferCategory?
    let noteText: String
    let amountErrorMessage: String?
    let canConfirm: Bool
}
