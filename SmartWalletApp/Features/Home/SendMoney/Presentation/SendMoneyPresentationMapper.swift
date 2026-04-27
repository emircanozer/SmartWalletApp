import Foundation

enum SendMoneyPresentationMapper {
    static func makeViewData(
        availableBalance: Decimal,
        amountText: String,
        selectedAmount: Decimal,
        quickAmounts: [Decimal],
        recipients: [SendMoneyRecipient],
        selectedRecipientID: String?,
        enteredIBAN: String,
        lookupRecipient: SendMoneyLookupRecipient?,
        selectedCategory: SendMoneyTransferCategory?,
        noteText: String,
        amountError: String?,
        canConfirm: Bool
    ) -> SendMoneyViewData {
        SendMoneyViewData(
            balanceText: AppNumberTextFormatter.prefixedLira(
                availableBalance,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            ),
            amountText: amountText.isEmpty ? "" : amountText,
            selectedAmount: selectedAmount,
            quickAmounts: quickAmounts,
            recipients: recipients,
            selectedRecipientID: selectedRecipientID,
            enteredIBAN: enteredIBAN,
            lookupRecipient: lookupRecipient,
            selectedCategoryTitle: selectedCategory?.title ?? "Kategori Seç",
            selectedCategory: selectedCategory,
            noteText: noteText,
            amountErrorMessage: amountError,
            canConfirm: canConfirm
        )
    }

    static func plainAmount(_ amount: Decimal) -> String {
        AppNumberTextFormatter.inputDecimalTRY(amount, maximumFractionDigits: 2)
    }

    static func maskName(_ fullName: String) -> String {
        AppStringTextFormatter.maskedName(fullName)
    }
}
