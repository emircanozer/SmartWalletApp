import Foundation

struct WalletRecipientResponse: Decodable {
    let fullName: String
    let contactName: String?
    let iban: String
    let badge: String
    let initials: String
}
