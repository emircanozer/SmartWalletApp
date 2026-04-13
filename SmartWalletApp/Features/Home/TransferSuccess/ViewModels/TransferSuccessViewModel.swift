import Foundation

enum TransferSuccessViewState {
    case loaded(TransferSuccessViewData)
}

struct TransferSuccessViewData {
    let titleText: String
    let subtitleText: String
    let transactionDateText: String
    let referenceNumberText: String
}

final class TransferSuccessViewModel {
    var onStateChange: ((TransferSuccessViewState) -> Void)?

    private let response: WalletTransferResponse

    init(response: WalletTransferResponse) {
        self.response = response
    }

    func load() {
        onStateChange?(.loaded(makeViewData()))
    }
}

 extension TransferSuccessViewModel {
    func makeViewData() -> TransferSuccessViewData {
        TransferSuccessViewData(
            titleText: "Para Gönderildi",
            subtitleText: "\(response.receiverName) kişisine \(formatAmount(response.amount)) transfer işlemi başarıyla gerçekleştirildi.",
            transactionDateText: formatDate(response.transactionDate),
            referenceNumberText: response.referenceNumber
        )
    }

    func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        let value = formatter.string(for: amount) ?? "0"
        return "₺\(value)"
    }

    func formatDate(_ rawValue: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]

        let date = formatter.date(from: rawValue) ?? fallbackFormatter.date(from: rawValue) ?? Date()

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "tr_TR")
        outputFormatter.dateFormat = "d MMMM yyyy, HH.mm"
        return outputFormatter.string(from: date)
    }
}
