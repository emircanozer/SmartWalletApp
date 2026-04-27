import Foundation

enum TransferReceiptPresentationMapper {
    static func makeViewData(wallet: MyWalletResponse?, response: WalletTransferResponse) -> TransferReceiptViewData {
        TransferReceiptViewData(
            senderNameText: wallet?.fullName ?? "-",
            receiverNameText: response.receiverName,
            ibanText: AppStringTextFormatter.spacedIBAN(
                response.receiverIban.isEmpty ? wallet?.iban ?? "" : response.receiverIban
            ),
            amountText: AppNumberTextFormatter.prefixedLira(response.amount),
            transactionDateText: AppDateTextFormatter.string(from: response.transactionDate, style: .transactionDateTime),
            referenceNumberText: response.referenceNumber,
            categoryTitleText: categoryTitle(for: response.category),
            noteText: AppStringTextFormatter.normalizedOptionalText(response.description)
        )
    }

    private static func categoryTitle(for backendValue: Int) -> String {
        switch backendValue {
        case 1: return "Market"
        case 2: return "Yemek"
        case 3: return "Fatura"
        case 4: return "Eğlence"
        case 5: return "Eğitim"
        case 6: return "Sağlık"
        case 7: return "Para Transferi"
        case 8: return "Kira Ödemesi"
        default: return "Diğer"
        }
    }

}
