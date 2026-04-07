import Foundation
//şifre sıfırlama akışında sonraki adıma geçmek için gereken geçici veri paketi
struct PendingPasswordResetContext {
    let email: String
    let code: String
}
