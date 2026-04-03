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
            return "Para Transferi"
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
        }
    }
}

struct SendMoneyRecipient: Equatable {
    let id: String
    let name: String
    let subtitle: String
    let iban: String
    let isSaved: Bool
}

struct SendMoneyLookupRecipient: Equatable {
    let name: String
    let maskedIban: String
    let iban: String
    let isSaved: Bool
}

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
