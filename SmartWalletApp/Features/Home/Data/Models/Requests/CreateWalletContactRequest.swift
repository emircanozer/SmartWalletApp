import Foundation

struct CreateWalletContactRequest: Encodable {
    let contactName: String
    let iban: String
    let isFavorite: Bool
}
