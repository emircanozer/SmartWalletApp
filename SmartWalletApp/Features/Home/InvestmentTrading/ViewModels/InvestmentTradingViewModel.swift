import Foundation

final class InvestmentTradingViewModel {
    var onStateChange: ((InvestmentTradingViewState) -> Void)?

    private let walletService: WalletService
    private let currencyFormatter: NumberFormatter
    private let quantityFormatter: NumberFormatter
    private let inputFormatter: NumberFormatter

    private var wallet: MyWalletResponse?
    private var prices: [PortfolioPriceResponse] = []
    private var summary: PortfolioSummaryResponse?
    // 3 önemli state 
    private var selectedAsset: InvestmentTradingAssetType?
    private var selectedDirection: InvestmentTradeDirection = .buy
    private var enteredAmountText = ""

    init(walletService: WalletService) {
        self.walletService = walletService

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "TRY"
        currencyFormatter.currencySymbol = "₺"
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.locale = Locale(identifier: "tr_TR")
        self.currencyFormatter = currencyFormatter

        let quantityFormatter = NumberFormatter()
        quantityFormatter.numberStyle = .decimal
        quantityFormatter.maximumFractionDigits = 4
        quantityFormatter.minimumFractionDigits = 0
        quantityFormatter.locale = Locale(identifier: "tr_TR")
        self.quantityFormatter = quantityFormatter

        let inputFormatter = NumberFormatter()
        inputFormatter.numberStyle = .decimal
        inputFormatter.maximumFractionDigits = 4
        inputFormatter.minimumFractionDigits = 0
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.inputFormatter = inputFormatter
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        do {
            async let walletTask = walletService.fetchMyWallet()
            async let pricesTask = walletService.fetchPortfolioPrices()
            async let summaryTask = walletService.fetchPortfolioSummary()

            let (wallet, prices, summary) = try await (walletTask, pricesTask, summaryTask)
            self.wallet = wallet
            self.prices = prices
            self.summary = summary

         
            let availableAssets = makeAvailableAssets(from: prices)
            if selectedAsset == nil || !availableAssets.contains(where: { $0.backendValue == selectedAsset?.backendValue }) {
                selectedAsset = availableAssets.first
            }

            emitLoadedState()
        } catch {
            onStateChange?(.failure("Yatırım verileri alınamadı. Lütfen tekrar deneyin."))
        }
    }
    // Kullanıcının seçimlerini state olarak tutuyor

    /*  artık seçili asset değişti
    sonra emitLoadedState() çağrılıyor */
    @MainActor
    func selectAsset(_ asset: InvestmentTradingAssetType) {
        selectedAsset = asset
        emitLoadedState()
    }

    @MainActor
    func selectDirection(_ direction: InvestmentTradeDirection) {
        selectedDirection = direction
        emitLoadedState()
    }

    @MainActor
    func updateEnteredAmount(_ text: String) {
        enteredAmountText = sanitizeInput(text)
        emitLoadedState()
    }

    @MainActor
    func applyQuickAmount(_ value: Decimal) {
        enteredAmountText = decimalInputText(value)
        emitLoadedState()
    }

    @MainActor
    func submit() async {
        guard let request = makeTradeRequest() else { return }

        onStateChange?(.loading)

        do {
            let response: PortfolioTradeResponse
            switch selectedDirection {
            case .buy:
                response = try await walletService.buyPortfolioAsset(request: request)
            case .sell:
                response = try await walletService.sellPortfolioAsset(request: request)
            }

            if response.success {
                enteredAmountText = ""
                onStateChange?(.success(response.message))
            } else {
                onStateChange?(.failure(response.message))
                emitLoadedState()
            }
        } catch {
            onStateChange?(.failure(error.localizedDescription))
            emitLoadedState()
        }
    }
}


/* mevcut state’ten yeni ekran modeli oluştur
 sonra .loaded(data) olarak controller’a yolla controller da case ile dinler ekrana yansıtır
 
 Yani ekranda değişen her şey burada yeniden çiziliyor.
 */
extension InvestmentTradingViewModel {
    func emitLoadedState() {
        guard let data = makeViewData() else {
            onStateChange?(.loaded(.empty))
            return
        }
        onStateChange?(.loaded(data))
    }

    func makeViewData() -> InvestmentTradingViewData? {
        guard let wallet, let summary else { return nil }

        let availableAssets = makeAvailableAssets(from: prices)
        guard let selectedAsset else {
            return InvestmentTradingViewData(
                titleText: "Yatırım İşlemi",
                subtitleText: "İşlem yapabileceğiniz yatırım aracı bulunamadı.",
                assetItems: [],
                selectedDirection: selectedDirection,
                buyPriceText: "₺0,00",
                sellPriceText: "₺0,00",
                balanceText: "₺0,00",
                holdingText: "0",
                amountText: enteredAmountText,
                amountPlaceholderText: "0.00",
                amountUnitText: "-",
                quickAmountItems: [],
                summaryRows: [],
                estimateTitleText: "TAHMİNİ TUTAR",
                estimateValueText: "₺0,00",
                actionButtonTitle: "İŞLEM YAP",
                isActionEnabled: false,
                validationMessageText: nil,
                emptyMessageText: "Henüz işlem yapılabilecek yatırım verisi yok."
            )
        }

        let price = prices.first { $0.assetType == selectedAsset.backendValue }
        let ownedAmount = summary.assets.first(where: { $0.assetType == selectedAsset.backendValue })?.amount ?? .zero
        let enteredAmount = parsedEnteredAmount()
        let unitPrice = selectedDirection == .buy ? (price?.buyPrice ?? .zero) : (price?.sellPrice ?? .zero)
        let estimatedTotal = enteredAmount * unitPrice
        let validationMessage = makeValidationMessage(
            enteredAmount: enteredAmount,
            requiredTotal: estimatedTotal,
            balance: wallet.balance,
            holding: ownedAmount,
            assetTitle: selectedAsset.title
        )
        let isActionEnabled = validateAction(
            enteredAmount: enteredAmount,
            unitPrice: unitPrice,
            balance: wallet.balance,
            holding: ownedAmount
        )

        let summaryRows = [
            InvestmentTradingSummaryRowItem(
                title: "İşlem Tipi",
                value: selectedDirection == .buy ? "\(selectedAsset.title) Alımı" : "\(selectedAsset.title) Satımı"
            ),
            InvestmentTradingSummaryRowItem(
                title: "Birim Fiyat",
                value: formatCurrency(unitPrice)
            ),
            InvestmentTradingSummaryRowItem(
                title: "Miktar",
                value: enteredAmount > .zero ? "\(formatQuantity(enteredAmount)) \(selectedAsset.amountUnit)" : "0 \(selectedAsset.amountUnit)"
            ),
            InvestmentTradingSummaryRowItem(
                title: "Toplam Tutar",
                value: formatCurrency(estimatedTotal)
            )
        ]

        
        return InvestmentTradingViewData(
            titleText: "Yatırım İşlemi",
            subtitleText: "Altın, döviz ve diğer yatırım araçlarında alım-satım yap.",
            // enumdan chip iteme dönüştürüyor 
            assetItems: availableAssets.map {
                InvestmentTradingAssetChipItem(assetType: $0, title: $0.title, isSelected: $0.backendValue == selectedAsset.backendValue)
            },
            selectedDirection: selectedDirection,
            buyPriceText: formatCurrency(price?.buyPrice ?? .zero),
            sellPriceText: formatCurrency(price?.sellPrice ?? .zero),
            balanceText: formatCurrency(wallet.balance),
            holdingText: "\(formatQuantity(ownedAmount)) \(selectedAsset.amountUnit)",
            amountText: enteredAmountText,
            amountPlaceholderText: "0.00",
            amountUnitText: selectedAsset.amountUnit.uppercased(),
            quickAmountItems: makeQuickAmountItems(for: selectedAsset),
            summaryRows: summaryRows,
            estimateTitleText: selectedDirection == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ GELECEK",
            estimateValueText: selectedDirection == .buy
                ? "\(formatQuantity(enteredAmount)) \(selectedAsset.amountUnit)"
                : formatCurrency(estimatedTotal),
            actionButtonTitle: selectedDirection == .buy
                ? "\(selectedAsset.displayCode) SATIN AL"
                : "\(selectedAsset.displayCode) SAT",
            isActionEnabled: isActionEnabled,
            validationMessageText: validationMessage,
            emptyMessageText: nil
        )
    }

    // // ViewModel chip item’larını üretir, custom view da onları butona çevirir
    func makeAvailableAssets(from prices: [PortfolioPriceResponse]) -> [InvestmentTradingAssetType] {
        let availableSet = Set(prices.map(\.assetType))
        return InvestmentTradingAssetType.allCases.filter { availableSet.contains($0.backendValue) }
    }

    func makeQuickAmountItems(for asset: InvestmentTradingAssetType) -> [InvestmentTradingQuickAmountItem] {
        let values: [Decimal]
        switch asset {
        case .gold, .silver:
            values = [0.25, 0.5, 1, 2]
        case .usd, .eur, .gbp, .chf, .sar, .kwd:
            values = [10, 50, 100, 250]
        case .other:
            values = [1, 5, 10, 25]
        }

        return values.map { value in
            InvestmentTradingQuickAmountItem(
                value: value,
                title: "\(formatQuantity(value)) \(asset.amountUnit)"
            )
        }
    }

    func validateAction(enteredAmount: Decimal, unitPrice: Decimal, balance: Decimal, holding: Decimal) -> Bool {
        guard enteredAmount > .zero, unitPrice > .zero else { return false }

        switch selectedDirection {
        case .buy:
            return (enteredAmount * unitPrice) <= balance
        case .sell:
            return enteredAmount <= holding
        }
    }

    func makeTradeRequest() -> PortfolioTradeRequest? {
        guard let selectedAsset else { return nil }
        let amount = parsedEnteredAmount()
        guard amount > .zero else { return nil }

        guard let wallet, let summary, let price = prices.first(where: { $0.assetType == selectedAsset.backendValue }) else {
            return nil
        }

        let holding = summary.assets.first(where: { $0.assetType == selectedAsset.backendValue })?.amount ?? .zero
        guard validateAction(
            enteredAmount: amount,
            unitPrice: selectedDirection == .buy ? price.buyPrice : price.sellPrice,
            balance: wallet.balance,
            holding: holding
        ) else {
            return nil
        }

        return PortfolioTradeRequest(assetType: selectedAsset.backendValue, amount: amount)
    }

    func makeValidationMessage(
        enteredAmount: Decimal,
        requiredTotal: Decimal,
        balance: Decimal,
        holding: Decimal,
        assetTitle: String
    ) -> String? {
        guard enteredAmount > .zero else { return nil }

        switch selectedDirection {
        case .buy:
            if requiredTotal > balance {
                return "Bakiyeniz bu alım işlemi için yetersiz."
            }
        case .sell:
            if holding <= .zero {
                return "Satış yapabilmek için \(assetTitle.lowercased()) varlığınız bulunmuyor."
            }
            if enteredAmount > holding {
                return "Elinizde yeterli \(assetTitle.lowercased()) bulunmuyor."
            }
        }

        return nil
    }

    func sanitizeInput(_ text: String) -> String {
        var result = ""
        var hasSeparator = false

        text.forEach { character in
            if character.isWholeNumber {
                result.append(character)
            } else if (character == "." || character == ",") && !hasSeparator {
                result.append(".")
                hasSeparator = true
            }
        }

        return result
    }

    func parsedEnteredAmount() -> Decimal {
        guard !enteredAmountText.isEmpty else { return .zero }
        return Decimal(string: enteredAmountText, locale: Locale(identifier: "en_US_POSIX")) ?? .zero
    }

    func formatCurrency(_ value: Decimal) -> String {
        currencyFormatter.string(from: value as NSDecimalNumber) ?? "₺0,00"
    }

    func formatQuantity(_ value: Decimal) -> String {
        quantityFormatter.string(from: value as NSDecimalNumber) ?? "0"
    }

    func decimalInputText(_ value: Decimal) -> String {
        inputFormatter.string(from: value as NSDecimalNumber) ?? ""
    }
}

private extension InvestmentTradingViewData {
    static let empty = InvestmentTradingViewData(
        titleText: "Yatırım İşlemi",
        subtitleText: "Veriler yükleniyor.",
        assetItems: [],
        selectedDirection: .buy,
        buyPriceText: "₺0,00",
        sellPriceText: "₺0,00",
        balanceText: "₺0,00",
        holdingText: "0",
        amountText: "",
        amountPlaceholderText: "0.00",
        amountUnitText: "-",
        quickAmountItems: [],
        summaryRows: [],
        estimateTitleText: "TAHMİNİ TUTAR",
        estimateValueText: "₺0,00",
        actionButtonTitle: "İŞLEM YAP",
        isActionEnabled: false,
        validationMessageText: nil,
        emptyMessageText: "Henüz işlem yapılabilecek yatırım verisi yok."
    )
}
