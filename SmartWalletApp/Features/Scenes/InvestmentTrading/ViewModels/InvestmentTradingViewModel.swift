import Foundation

final class InvestmentTradingViewModel {
    var onStateChange: ((InvestmentTradingViewState) -> Void)?

    private let walletService: WalletService
    private let initialAsset: InvestmentTradingAssetType?
    private let initialDirection: InvestmentTradeDirection?

    private var wallet: MyWalletResponse?
    private var prices: [PortfolioPriceResponse] = []
    private var summary: PortfolioSummaryResponse?
    // 4 önemli state hangi varlık seçili al mı sat mı amount ne kadar ve tl ile mi birim ile mi trade olacak input mode !!!
    private var selectedAsset: InvestmentTradingAssetType?
    private var selectedDirection: InvestmentTradeDirection = .buy
    private var selectedInputMode: InvestmentTradingInputMode = .quantity
    private var enteredAmountText = ""

    init(
        walletService: WalletService,
        initialAsset: InvestmentTradingAssetType? = nil,
        initialDirection: InvestmentTradeDirection? = nil
    ) {
        self.walletService = walletService
        self.initialAsset = initialAsset
        self.initialDirection = initialDirection
        self.selectedDirection = initialDirection ?? .buy
    }

    @MainActor
    func load() async {
        onStateChange?(.loading)

        // burada ViewModel önce ekranı kurmak için gerekli tüm kaynak verileri topluyor bakiye fiyatlar gibi
        do {
            async let walletTask = walletService.fetchMyWallet()
            async let pricesTask = walletService.fetchPortfolioPrices()
            async let summaryTask = walletService.fetchPortfolioSummary()

            let (wallet, prices, summary) = try await (walletTask, pricesTask, summaryTask)
            self.wallet = wallet
            self.prices = prices
            self.summary = summary

         
            // özelleştirilmiş asseti selected ilk yükleme
            let availableAssets = makeAvailableAssets(from: prices)
            if selectedAsset == nil || !availableAssets.contains(where: { $0.backendValue == selectedAsset?.backendValue }) {
                if let initialAsset, availableAssets.contains(where: { $0.backendValue == initialAsset.backendValue }) {
                    selectedAsset = initialAsset
                } else {
                    selectedAsset = availableAssets.first
                }
            }
            emitLoadedState()
        } catch {
            onStateChange?(.failure("Yatırım verileri alınamadı. Lütfen tekrar deneyin."))
        }
    }
    
    /*  artık seçili asset değişti
    sonra emitLoadedState() çağrılıyor */
    // varlık  butonu seçiyor kullanıcı
    func selectAsset(_ asset: InvestmentTradingAssetType) {
        selectedAsset = asset
        // emit etmeden önce elimizdeki bu: Şu an elimde ham veriler de var, seçili asset de belli, artık ekrana basılacak hazır veriyi üret ve controller’a gönder.
        emitLoadedState()
    }

    // al sat segmentedi seçecek kullanıcı işleyiş aynı
    func selectDirection(_ direction: InvestmentTradeDirection) {
        selectedDirection = direction
        emitLoadedState()
    }

    func selectInputMode(_ mode: InvestmentTradingInputMode) {
        guard let selectedAsset, selectedAsset.supportsFiatInput else { return }
        guard selectedInputMode != mode else { return }
        selectedInputMode = mode
        enteredAmountText = ""
        emitLoadedState()
    }

    func updateEnteredAmount(_ text: String) {
        enteredAmountText = sanitizeInput(text)
        emitLoadedState()
    }

    func applyQuickAmount(_ value: Decimal) {
        enteredAmountText = AppNumberTextFormatter.inputDecimal(value)
        emitLoadedState()
    }

    func makeTradeContext() -> InvestmentTradeContext? {
        guard let selectedAsset,
              let wallet,
              let summary,
              let price = prices.first(where: { $0.assetType == selectedAsset.backendValue }),
              let request = makeTradeRequest()
        else {
            return nil
        }

        let holding = summary.assets.first(where: { $0.assetType == selectedAsset.backendValue })?.amount ?? .zero
        let unitPrice = selectedDirection == .buy ? price.buyPrice : price.sellPrice
        let assetAmount = request.isFiatAmount ? safeDivision(request.amount, by: unitPrice) : request.amount
        let totalAmount = request.isFiatAmount ? request.amount : request.amount * unitPrice
        let resultingBalance: Decimal

        switch selectedDirection {
        case .buy:
            resultingBalance = wallet.balance - totalAmount
        case .sell:
            resultingBalance = wallet.balance + totalAmount
        }

        guard validateAction(
            enteredAmount: request.amount,
            unitPrice: unitPrice,
            balance: wallet.balance,
            holding: holding
        ) else {
            return nil
        }

        return InvestmentTradeContext(
            request: request,
            assetType: selectedAsset,
            direction: selectedDirection,
            inputMode: selectedInputMode,
            unitPrice: unitPrice,
            enteredAmount: request.amount,
            assetAmount: assetAmount,
            totalAmount: totalAmount,
            currentBalance: wallet.balance,
            resultingBalance: resultingBalance
        )
    }
}


/* mevcut state’ten yeni ekran modeli oluştur
 sonra .loaded(data) olarak controller’a yolla controller da case ile dinler ekrana yansıtır
 
 Yani ekranda değişen her şey burada yeniden çiziliyor.
 */
extension InvestmentTradingViewModel {
    func emitLoadedState() {
        // state göre olacak yeni ekran datasını üret
        guard let data = makeViewData() else {
            onStateChange?(.loaded(.empty))
            return
        }
        // oluşturulmuş bu veriyi closure a koyup controllera gönderiyor !!
        onStateChange?(.loaded(data))
    }

    // burada üretiliyor seçili assete göre yeni veri önemli fonksiyon !!!
    func makeViewData() -> InvestmentTradingViewData? {
        guard let wallet, let summary else { return nil }

        let availableAssets = makeAvailableAssets(from: prices)
        guard let selectedAsset else {
            return InvestmentTradingViewData(
                titleText: "Yatırım İşlemi",
                subtitleText: "İşlem yapabileceğiniz yatırım aracı bulunamadı.",
                assetItems: [],
                selectedDirection: selectedDirection,
                selectedInputMode: .quantity,
                buyPriceText: "₺0,00",
                sellPriceText: "₺0,00",
                balanceText: "₺0,00",
                holdingText: "0",
                amountText: enteredAmountText,
                amountTitleText: "MİKTAR GİRİNİZ",
                amountPlaceholderText: "0.00",
                amountUnitText: "-",
                quantityOptionTitle: "-",
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
        let estimatedTotal = selectedInputMode == .fiat ? enteredAmount : enteredAmount * unitPrice
        let estimatedAssetAmount = selectedInputMode == .fiat ? safeDivision(enteredAmount, by: unitPrice) : enteredAmount
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

        let summaryRows: [InvestmentTradingSummaryRowItem]
        if selectedInputMode == .fiat {
            summaryRows = [
                InvestmentTradingSummaryRowItem(
                    title: "İşlem Tipi",
                    value: selectedDirection == .buy ? "\(selectedAsset.title) Alımı" : "\(selectedAsset.title) Satımı"
                ),
                InvestmentTradingSummaryRowItem(
                    title: "Birim Fiyat",
                    value: InvestmentTradingValueFormatter.unitPrice(unitPrice, asset: selectedAsset)
                ),
                InvestmentTradingSummaryRowItem(
                    title: "Girilen Tutar",
                    value: AppNumberTextFormatter.currencyTRY(enteredAmount)
                ),
                InvestmentTradingSummaryRowItem(
                    title: selectedDirection == .buy ? "Tahmini Alınacak" : "Tahmini Satılacak",
                    value: "\(InvestmentTradingValueFormatter.estimatedAssetAmount(estimatedAssetAmount, asset: selectedAsset)) \(selectedAsset.amountUnit)"
                )
            ]
        } else {
            summaryRows = [
                InvestmentTradingSummaryRowItem(
                    title: "İşlem Tipi",
                    value: selectedDirection == .buy ? "\(selectedAsset.title) Alımı" : "\(selectedAsset.title) Satımı"
                ),
                InvestmentTradingSummaryRowItem(
                    title: "Birim Fiyat",
                    value: InvestmentTradingValueFormatter.unitPrice(unitPrice, asset: selectedAsset)
                ),
                InvestmentTradingSummaryRowItem(
                    title: "Girilen Miktar",
                    value: enteredAmount > .zero ? "\(InvestmentTradingValueFormatter.quantity(enteredAmount)) \(selectedAsset.amountUnit)" : "0 \(selectedAsset.amountUnit)"
                ),
                InvestmentTradingSummaryRowItem(
                    title: "Toplam Tutar",
                    value: AppNumberTextFormatter.currencyTRY(estimatedTotal)
                )
            ]
        }

        
        return InvestmentTradingViewData(
            titleText: "Yatırım İşlemi",
            subtitleText: "Altın, döviz ve diğer yatırım araçlarında alım-satım yap.",
            // enumdan chip iteme dönüştürüyor
            /*
             $0 = enum case
             $0.title = enum içindeki isim
             isSelected = state’e göre belirleniyor
             */
            assetItems: availableAssets.map {
                InvestmentTradingAssetChipItem(assetType: $0, title: $0.title, isSelected: $0.backendValue == selectedAsset.backendValue)
            },
            selectedDirection: selectedDirection,
            selectedInputMode: selectedInputMode,
            buyPriceText: InvestmentTradingValueFormatter.unitPrice(price?.buyPrice ?? .zero, asset: selectedAsset),
            sellPriceText: InvestmentTradingValueFormatter.unitPrice(price?.sellPrice ?? .zero, asset: selectedAsset),
            balanceText: AppNumberTextFormatter.currencyTRY(wallet.balance),
            holdingText: "\(InvestmentTradingValueFormatter.quantity(ownedAmount)) \(selectedAsset.amountUnit)",
            amountText: enteredAmountText,
            amountTitleText: selectedInputMode == .fiat ? "TUTAR GİRİNİZ" : "MİKTAR GİRİNİZ",
            amountPlaceholderText: "0.00",
            amountUnitText: selectedInputMode == .fiat ? "TL" : selectedAsset.amountUnit.uppercased(),
            quantityOptionTitle: selectedAsset.amountUnit.uppercased(),
            quickAmountItems: makeQuickAmountItems(for: selectedAsset),
            summaryRows: summaryRows,
            estimateTitleText: selectedInputMode == .fiat
                ? (selectedDirection == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ SATILACAK")
                : (selectedDirection == .buy ? "TAHMİNİ ALINACAK" : "TAHMİNİ GELECEK"),
            estimateValueText: selectedInputMode == .fiat
                    ? "\(InvestmentTradingValueFormatter.estimatedAssetAmount(estimatedAssetAmount, asset: selectedAsset)) \(selectedAsset.amountUnit)"
                    : (selectedDirection == .buy
                    ? "\(InvestmentTradingValueFormatter.quantity(estimatedAssetAmount)) \(selectedAsset.amountUnit)"
                    : AppNumberTextFormatter.currencyTRY(estimatedTotal)),
            actionButtonTitle: selectedDirection == .buy
                ? "\(selectedAsset.displayCode) SATIN AL"
                : "\(selectedAsset.displayCode) SAT",
            isActionEnabled: isActionEnabled,
            validationMessageText: validationMessage,
            emptyMessageText: nil
        )
    }

    // enumdan gelen bilgilere göre map ediyoruz burada altın mı usd mi olacak chip buton da onu veriyor
    func makeAvailableAssets(from prices: [PortfolioPriceResponse]) -> [InvestmentTradingAssetType] {
        let availableSet = Set(prices.map(\.assetType))
        return InvestmentTradingAssetType.allCases.filter { availableSet.contains($0.backendValue) }
    }

    func makeQuickAmountItems(for asset: InvestmentTradingAssetType) -> [InvestmentTradingQuickAmountItem] {
        let values: [Decimal]
        switch (asset, selectedInputMode) {
        case (_, .fiat):
            values = [1000, 5000, 10000, 15000]
        case (.gold, _), (.silver, _):
            values = [0.25, 0.5, 1, 2]
        case (.usd, _), (.eur, _), (.gbp, _), (.chf, _), (.sar, _), (.kwd, _):
            values = [10, 50, 100, 250]
        case (.other, _):
            values = [1, 5, 10, 25]
        }

        return values.map { value in
            InvestmentTradingQuickAmountItem(
                value: value,
                title: selectedInputMode == .fiat
                    ? "\(InvestmentTradingValueFormatter.quantity(value)) TL"
                    : "\(InvestmentTradingValueFormatter.quantity(value)) \(asset.amountUnit)"
            )
        }
    }

    func validateAction(enteredAmount: Decimal, unitPrice: Decimal, balance: Decimal, holding: Decimal) -> Bool {
        guard enteredAmount > .zero, unitPrice > .zero else { return false }

        switch selectedDirection {
        case .buy:
            let requiredTotal = selectedInputMode == .fiat ? enteredAmount : (enteredAmount * unitPrice)
            return requiredTotal <= balance
        case .sell:
            let requiredHolding = selectedInputMode == .fiat ? safeDivision(enteredAmount, by: unitPrice) : enteredAmount
            return requiredHolding <= holding
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

        return PortfolioTradeRequest(assetType: selectedAsset.backendValue, amount: amount, isFiatAmount: selectedInputMode.isFiatAmount)
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
            let requiredHolding = selectedInputMode == .fiat ? safeDivision(requiredTotal, by: currentUnitPrice()) : enteredAmount
            if requiredHolding > holding {
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

    func currentUnitPrice() -> Decimal {
        guard let selectedAsset else { return .zero }
        let price = prices.first(where: { $0.assetType == selectedAsset.backendValue })
        return selectedDirection == .buy ? (price?.buyPrice ?? .zero) : (price?.sellPrice ?? .zero)
    }

    func safeDivision(_ lhs: Decimal, by rhs: Decimal) -> Decimal {
        guard rhs > .zero else { return .zero }
        return lhs / rhs
    }
}

 extension InvestmentTradingViewData {
    static let empty = InvestmentTradingViewData(
        titleText: "Yatırım İşlemi",
        subtitleText: "Veriler yükleniyor.",
        assetItems: [],
        selectedDirection: .buy,
        selectedInputMode: .quantity,
        buyPriceText: "₺0,00",
        sellPriceText: "₺0,00",
        balanceText: "₺0,00",
        holdingText: "0",
        amountText: "",
        amountTitleText: "MİKTAR GİRİNİZ",
        amountPlaceholderText: "0.00",
        amountUnitText: "-",
        quantityOptionTitle: "-",
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
