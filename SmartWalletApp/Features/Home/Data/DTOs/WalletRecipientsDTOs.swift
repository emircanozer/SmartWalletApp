import Foundation

struct WalletRecipientResponse: Decodable {
    let fullName: String
    let contactName: String?
    let iban: String
    let badge: String
    let initials: String
}

struct CreateWalletContactRequest: Encodable {
    let contactName: String
    let iban: String
    let isFavorite: Bool
}
