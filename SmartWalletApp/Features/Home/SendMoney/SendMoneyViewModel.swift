import Foundation

enum SendMoneyViewState {
    case idle
    case loading
    case loaded(SendMoneyViewData) // veri de taşıyor state ile birlikte 
    case transferSucceeded(WalletTransferResponse)
    case failure(String)
}

final class SendMoneyViewModel {
    var onStateChange: ((SendMoneyViewState) -> Void)?

    private let walletService: WalletService
    private let quickAmounts: [Decimal] = [50, 100, 200, 500, 2000]
    private var availableBalance: Decimal = 0
    private var enteredIBAN: String = ""
    private var amountText: String = "100"
    private var selectedAmount: Decimal = 100
    private var noteText: String = ""
    private var selectedRecipientID: String?
    private var recipients: [SendMoneyRecipient] = []
    private var lookupRecipient: SendMoneyLookupRecipient?
    private var selectedCategory: SendMoneyTransferCategory?
    private var ibanLookupTask: Task<Void, Never>?

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            let wallet = try await walletService.fetchMyWallet()
            availableBalance = wallet.balance
        } catch {
            availableBalance = 0
        }

        do {
            let recipientResponses = try await walletService.fetchRecipients()
            recipients = recipientResponses.enumerated().map { index, recipient in
                SendMoneyRecipient(
                    id: "\(index)-\(recipient.iban)",
                    name: recipient.fullName,
                    subtitle: "",
                    iban: recipient.iban,
                    isSaved: true
                )
            }
            onStateChange?(.loaded(makeViewData()))
        } catch {
            recipients = []
            onStateChange?(.loaded(makeViewData()))
        }
    }

    func updateAmount(_ rawValue: String) {
        let filtered = rawValue.filter { $0.isNumber || $0 == "," || $0 == "." }
        amountText = filtered.isEmpty ? "" : filtered
        selectedAmount = parseAmount(filtered)
        emitLoadedState()
    }

    func selectQuickAmount(_ amount: Decimal) {
        selectedAmount = amount
        amountText = formatPlainAmount(amount)
        emitLoadedState()
    }

    func updateIBAN(_ iban: String) {
        enteredIBAN = iban.uppercased()
        let matchedRecipient = recipients.first(where: { $0.iban == enteredIBAN })
        selectedRecipientID = matchedRecipient?.id
        lookupRecipient = nil
        ibanLookupTask?.cancel()
        emitLoadedState()

        let normalized = enteredIBAN.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalized.count == 26 else { return }

        ibanLookupTask = Task { [weak self] in
            guard let self else { return }
            await self.loadLookupRecipient(
                iban: normalized,
                isSaved: matchedRecipient != nil,
                fallbackName: matchedRecipient?.name
            )
        }
    }

    func updateNote(_ note: String) {
        noteText = note
        emitLoadedState()
    }

    func selectCategory(_ category: SendMoneyTransferCategory) {
        selectedCategory = category
        emitLoadedState()
    }

    func currentSelectedCategory() -> SendMoneyTransferCategory? {
        selectedCategory
    }

    func selectRecipient(id: String) {
        guard let recipient = recipients.first(where: { $0.id == id }) else { return }
        selectedRecipientID = id
        enteredIBAN = recipient.iban
        lookupRecipient = nil
        ibanLookupTask?.cancel()
        emitLoadedState()

        ibanLookupTask = Task { [weak self] in
            guard let self else { return }
            await self.loadLookupRecipient(
                iban: recipient.iban,
                isSaved: true,
                fallbackName: recipient.name
            )
        }
    }

    func canSaveLookupRecipient() -> Bool {
        guard let recipient = lookupRecipient else { return false }
        return !recipient.isSaved
    }

    func saveLookupRecipient(contactName: String) async {
        guard let recipient = lookupRecipient, !recipient.isSaved else { return }
        let trimmedName = contactName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            onStateChange?(.failure("Lutfen alici icin bir isim girin."))
            return
        }

        onStateChange?(.loading)

        do {
            try await walletService.createContact(
                request: CreateWalletContactRequest(
                    contactName: trimmedName,
                    iban: recipient.iban,
                    isFavorite: false
                )
            )

            let recipientResponses = try await walletService.fetchRecipients()
            recipients = recipientResponses.enumerated().map { index, recipient in
                SendMoneyRecipient(
                    id: "\(index)-\(recipient.iban)",
                    name: recipient.fullName,
                    subtitle: "",
                    iban: recipient.iban,
                    isSaved: true
                )
            }
            selectedRecipientID = recipients.first(where: { $0.iban == recipient.iban })?.id
            if let savedRecipient = recipients.first(where: { $0.iban == recipient.iban }) {
                await loadLookupRecipient(
                    iban: savedRecipient.iban,
                    isSaved: true,
                    fallbackName: savedRecipient.name
                )
            } else {
                lookupRecipient = nil
            }
            emitLoadedState()
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }

    @MainActor
    func confirmTransfer() async {
        let iban = enteredIBAN.trimmingCharacters(in: .whitespacesAndNewlines)
        let amount = currentAmount()

        guard !iban.isEmpty else {
            onStateChange?(.failure("Lutfen gecerli bir alici IBAN'i girin."))
            return
        }

        guard let selectedCategory else {
            onStateChange?(.failure("Lutfen bir kategori secin."))
            return
        }

        guard amount > 0 else {
            onStateChange?(.failure("Lutfen gecerli bir tutar girin."))
            return
        }

        guard amount <= availableBalance else {
            onStateChange?(.failure("Bakiyenizden fazla tutar gönderemezsiniz."))
            return
        }

        onStateChange?(.loading)

        do {
            let response = try await walletService.transfer(
                request: WalletTransferRequest(
                    receiverIban: iban,
                    amount: amount,
                    description: noteText.trimmingCharacters(in: .whitespacesAndNewlines),
                    category: selectedCategory.backendValue
                )
            )

            if response.success {
                resetForm()
                do {
                    let wallet = try await walletService.fetchMyWallet()
                    availableBalance = wallet.balance
                } catch {
                    availableBalance -= amount
                }
                onStateChange?(.transferSucceeded(response))
                emitLoadedState()
            } else {
                onStateChange?(.failure(response.message))
            }
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}

 extension SendMoneyViewModel {
    func emitLoadedState() {
        onStateChange?(.loaded(makeViewData()))
    }

    func makeViewData() -> SendMoneyViewData {
        let amount = currentAmount()
        let amountError = amount > availableBalance && amount > 0
            ? "Bakiyenizden fazla tutar gönderemezsiniz."
            : nil

        return SendMoneyViewData(
            balanceText: formatCurrency(availableBalance),
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
            canConfirm: canConfirmTransfer(amount: amount, amountError: amountError)
        )
    }

    func canConfirmTransfer(amount: Decimal, amountError: String?) -> Bool {
        let hasTypedIBAN = !enteredIBAN.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasSelectedRecipient = selectedRecipientID != nil
        return (hasTypedIBAN || hasSelectedRecipient) && amount > 0 && amountError == nil && selectedCategory != nil
    }

    func currentAmount() -> Decimal {
        let parsed = parseAmount(amountText)
        return parsed == 0 && amountText.isEmpty ? selectedAmount : parsed
    }

    func parseAmount(_ rawValue: String) -> Decimal {
        Decimal(string: rawValue.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 0
        let value = formatter.string(for: amount) ?? "0"
        return "₺\(value)"
    }

    func formatPlainAmount(_ amount: Decimal) -> String {
        NSDecimalNumber(decimal: amount).stringValue
    }

    func maskName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        return parts.map { part in
            guard let first = part.first else { return "" }
            return "\(first)***"
        }.joined(separator: " ")
    }

    func resetForm() {
        enteredIBAN = ""
        amountText = "100"
        selectedAmount = 100
        noteText = ""
        selectedRecipientID = nil
        lookupRecipient = nil
        selectedCategory = nil
        ibanLookupTask?.cancel()
    }

    @MainActor
    func loadLookupRecipient(iban: String, isSaved: Bool, fallbackName: String?) async {
        do {
            let response = try await walletService.fetchOwnerName(iban: iban)
            guard !Task.isCancelled else { return }
            lookupRecipient = SendMoneyLookupRecipient(
                name: response.maskedName,
                maskedIban: response.maskedName,
                iban: iban,
                isSaved: isSaved
            )
            emitLoadedState()
        } catch {
            guard !Task.isCancelled else { return }
            if let fallbackName {
                lookupRecipient = SendMoneyLookupRecipient(
                    name: maskName(fallbackName),
                    maskedIban: maskName(fallbackName),
                    iban: iban,
                    isSaved: isSaved
                )
            } else {
                lookupRecipient = nil
            }
            emitLoadedState()
        }
    }
}
