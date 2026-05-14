import Foundation

// ViewModel state case içine veri koyuyor
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
    private var isAmountPrefilled = true
    private var noteText: String = ""
    private var selectedRecipientID: String?
    private var recipients: [SendMoneyRecipient] = []
    private var lookupRecipient: SendMoneyLookupRecipient?
    private var selectedCategory: SendMoneyTransferCategory?
    private var shouldShowRequiredFieldsError = false
    private var ibanLookupTask: Task<Void, Never>?
    private var locallyAddedRecipientsByIBAN: [String: SendMoneyRecipient] = [:]
    private var locallyRemovedRecipientIBANs: Set<String> = []

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
            try await refreshRecipients()
            onStateChange?(.loaded(makeViewData()))
        } catch {
            recipients = []
            onStateChange?(.loaded(makeViewData()))
        }
    }

    func updateAmount(_ rawValue: String) {
        let normalized = sanitizeAmountInput(rawValue)
        amountText = normalized
        selectedAmount = parseAmount(normalized)
        isAmountPrefilled = false
        emitLoadedState()
    }

    func selectQuickAmount(_ amount: Decimal) {
        selectedAmount = amount
        amountText = AppNumberTextFormatter.inputDecimalTRY(amount, maximumFractionDigits: 2)
        isAmountPrefilled = true
        emitLoadedState()
    }

    func updateIBAN(_ iban: String) {
        enteredIBAN = sanitizeIBANInput(iban)
        shouldShowRequiredFieldsError = false
        let matchedRecipient = recipients.first(where: { $0.iban == enteredIBAN })
        selectedRecipientID = matchedRecipient?.id
        lookupRecipient = nil
        ibanLookupTask?.cancel()
        emitLoadedState()

        let normalized = enteredIBAN.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidIBAN(normalized) else { return }

        ibanLookupTask = Task { [weak self] in
            guard let self else { return }
            await self.loadLookupRecipient(
                iban: normalized,
                isSaved: matchedRecipient != nil
            )
        }
    }

    func updateNote(_ note: String) {
        noteText = note
        emitLoadedState()
    }

    func selectCategory(_ category: SendMoneyTransferCategory) {
        selectedCategory = category
        shouldShowRequiredFieldsError = false
        emitLoadedState()
    }

    func currentSelectedCategory() -> SendMoneyTransferCategory? {
        selectedCategory
    }

    func selectRecipient(id: String) {
        guard let recipient = recipients.first(where: { $0.id == id }) else { return }
        selectedRecipientID = id
        shouldShowRequiredFieldsError = false
        enteredIBAN = recipient.iban
        lookupRecipient = nil
        ibanLookupTask?.cancel()
        emitLoadedState()

        ibanLookupTask = Task { [weak self] in
            guard let self else { return }
            await self.loadLookupRecipient(
                iban: recipient.iban,
                isSaved: true
            )
        }
    }

    func canSaveLookupRecipient() -> Bool {
        guard let recipient = lookupRecipient else { return false }
        return !recipient.isSaved
    }

    @MainActor
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

            let savedRecipient = SendMoneyRecipient(
                id: recipient.iban,
                name: trimmedName,
                ownerMaskedName: recipient.ownerMaskedName,
                subtitle: "",
                iban: recipient.iban,
                isSaved: true
            )

            recipients.removeAll { $0.iban == recipient.iban }
            recipients.append(savedRecipient)
            locallyRemovedRecipientIBANs.remove(recipient.iban)
            locallyAddedRecipientsByIBAN[recipient.iban] = savedRecipient
            selectedRecipientID = savedRecipient.id
            lookupRecipient = SendMoneyLookupRecipient(
                ownerMaskedName: recipient.ownerMaskedName,
                maskedIban: recipient.maskedIban,
                iban: recipient.iban,
                isSaved: true
            )
            emitLoadedState()
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }

    @MainActor
    func confirmTransfer() async {
        let iban = enteredIBAN.trimmingCharacters(in: .whitespacesAndNewlines)
        let amount = currentAmount()
        let hasValidRecipient = isValidIBAN(iban) || selectedRecipientID != nil

        guard hasValidRecipient, selectedCategory != nil else {
            shouldShowRequiredFieldsError = true
            emitLoadedState()
            return
        }

        guard let selectedCategory else {
            shouldShowRequiredFieldsError = true
            emitLoadedState()
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

    @MainActor
    func deleteRecipient(id: String) async {
        guard let recipient = recipients.first(where: { $0.id == id }) else { return }

        onStateChange?(.loading)

        do {
            _ = try await walletService.removeContact(iban: recipient.iban)
            recipients.removeAll { $0.id == id }
            locallyAddedRecipientsByIBAN.removeValue(forKey: recipient.iban)
            locallyRemovedRecipientIBANs.insert(recipient.iban)

            if selectedRecipientID == id {
                selectedRecipientID = nil
            }

            if enteredIBAN == recipient.iban {
                if let currentLookupRecipient = lookupRecipient {
                    lookupRecipient = SendMoneyLookupRecipient(
                        ownerMaskedName: currentLookupRecipient.ownerMaskedName,
                        maskedIban: currentLookupRecipient.maskedIban,
                        iban: currentLookupRecipient.iban,
                        isSaved: false
                    )
                }
                emitLoadedState()
            } else {
                emitLoadedState()
            }
        } catch {
            onStateChange?(.failure(error.localizedDescription))
        }
    }
}

 extension SendMoneyViewModel {
    func refreshRecipients() async throws {
        let recipientResponses = try await walletService.fetchRecipients()
        var mergedRecipients = recipientResponses.map { recipient in
            SendMoneyRecipient(
                id: recipient.iban,
                name: recipient.contactName ?? recipient.fullName,
                ownerMaskedName: AppStringTextFormatter.maskedName(recipient.fullName),
                subtitle: "",
                iban: recipient.iban,
                isSaved: true
            )
        }

        mergedRecipients.removeAll { locallyRemovedRecipientIBANs.contains($0.iban) }

        for localRecipient in locallyAddedRecipientsByIBAN.values {
            mergedRecipients.removeAll { $0.iban == localRecipient.iban }
            mergedRecipients.append(localRecipient)
        }

        recipients = mergedRecipients
    }

    func emitLoadedState() {
        // ekrana basılacak veri hazır
        //al bunu UI’da göster
        onStateChange?(.loaded(makeViewData()))
    }

    func makeViewData() -> SendMoneyViewData {
        let amount = currentAmount()
        let amountError = amount > availableBalance && amount > 0
            ? "Bakiyenizden fazla tutar gönderemezsiniz."
            : nil
        let ibanError = ibanValidationMessage()

        return SendMoneyViewData(
            balanceText: AppNumberTextFormatter.prefixedLira(
                availableBalance,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            ),
            amountText: amountText.isEmpty ? "" : amountText,
            shouldClearPrefilledAmountOnFocus: isAmountPrefilled && !amountText.isEmpty,
            selectedAmount: selectedAmount,
            quickAmounts: quickAmounts,
            recipients: recipients,
            selectedRecipientID: selectedRecipientID,
            enteredIBAN: enteredIBAN,
            formattedIBAN: formatIBAN(enteredIBAN),
            ibanErrorMessage: ibanError,
            lookupRecipient: lookupRecipient,
            selectedCategoryTitle: selectedCategory?.title ?? "Kategori Seç",
            selectedCategory: selectedCategory,
            noteText: noteText,
            amountErrorMessage: amountError,
            formErrorMessage: shouldShowRequiredFieldsError ? "Zorunlu alanları doldurunuz." : nil,
            canConfirm: canConfirmTransfer(amount: amount, amountError: amountError, ibanError: ibanError)
        )
    }

    func canConfirmTransfer(amount: Decimal, amountError: String?, ibanError: String?) -> Bool {
        let hasTypedIBAN = isValidIBAN(enteredIBAN)
        let hasSelectedRecipient = selectedRecipientID != nil
        return (hasTypedIBAN || hasSelectedRecipient) && amount > 0 && amountError == nil && ibanError == nil
    }

    func currentAmount() -> Decimal {
        let parsed = parseAmount(amountText)
        return parsed == 0 && amountText.isEmpty ? selectedAmount : parsed
    }

    func parseAmount(_ rawValue: String) -> Decimal {
        let normalized = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return 0 }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.generatesDecimalNumbers = true

        if let number = formatter.number(from: normalized) as? NSDecimalNumber {
            return number.decimalValue
        }

        return Decimal(string: normalized.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    func resetForm() {
        enteredIBAN = ""
        amountText = "100"
        selectedAmount = 100
        isAmountPrefilled = true
        noteText = ""
        selectedRecipientID = nil
        lookupRecipient = nil
        selectedCategory = nil
        shouldShowRequiredFieldsError = false
        ibanLookupTask?.cancel()
    }

    @MainActor
    func loadLookupRecipient(iban: String, isSaved: Bool) async {
        do {
            let response = try await walletService.fetchOwnerName(iban: iban)
            guard !Task.isCancelled else { return }
            lookupRecipient = SendMoneyLookupRecipient(
                ownerMaskedName: response.maskedName,
                maskedIban: response.maskedName,
                iban: iban,
                isSaved: isSaved
            )
            emitLoadedState()
        } catch {
            guard !Task.isCancelled else { return }
            lookupRecipient = nil
            emitLoadedState()
        }
    }

    func sanitizeAmountInput(_ rawValue: String) -> String {
        var result = ""
        var hasSeparator = false
        var fractionDigits = 0

        for character in rawValue {
            if character.isWholeNumber {
                if hasSeparator {
                    guard fractionDigits < 2 else { continue }
                    fractionDigits += 1
                }
                result.append(character)
                continue
            }

            if (character == "," || character == ".") && !hasSeparator {
                hasSeparator = true
                if result.isEmpty {
                    result = "0"
                }
                result.append(",")
            }
        }

        return result
    }

    func sanitizeIBANInput(_ rawValue: String) -> String {
        let sanitized = rawValue
            .uppercased()
            .filter { $0.isLetter || $0.isWholeNumber }
        return String(sanitized.prefix(26))
    }

    func formatIBAN(_ value: String) -> String {
        stride(from: 0, to: value.count, by: 4).map { startIndex in
            let start = value.index(value.startIndex, offsetBy: startIndex)
            let end = value.index(start, offsetBy: min(4, value.count - startIndex), limitedBy: value.endIndex) ?? value.endIndex
            return String(value[start..<end])
        }.joined(separator: " ")
    }

    func isValidIBAN(_ value: String) -> Bool {
        let pattern = #"^TR\d{24}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }

    func ibanValidationMessage() -> String? {
        let trimmedIBAN = enteredIBAN.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedIBAN.isEmpty, !isValidIBAN(trimmedIBAN) else { return nil }
        return "Doğru IBAN numarası giriniz."
    }
}
