import Foundation

final class WalletService {
    private let apiClient: APIClient
    private let encoder = JSONEncoder()
    private let isoEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    // auth daki gibi tanımladığımız fonk generic olduğu için burada da aynı apliclent fonsiyonunu kullanıdık
    // seçilen endpointe göre url ve return ettiği yani döndürmek istediği response göre ayrı oluyor
    func fetchMyWallet() async throws -> MyWalletResponse {
        try await apiClient.send(WalletEndpoint.myWallet, as: MyWalletResponse.self)
    }

    func fetchTransactions(walletId: String) async throws -> [WalletTransactionResponse] {
        try await apiClient.send(WalletEndpoint.transactions(walletId: walletId), as: [WalletTransactionResponse].self)
    }

    func fetchReceiptDetail(transactionId: String) async throws -> WalletTransactionReceiptResponse {
        try await apiClient.send(WalletEndpoint.receipt(transactionId: transactionId), as: WalletTransactionReceiptResponse.self)
    }

    // 2 endpointin birleşimi ile geldi
    func fetchRecipients() async throws -> [WalletRecipientResponse] {
        let contacts = try? await apiClient.send(WalletEndpoint.contactsList, as: [WalletRecipientResponse].self)
        let favorites = try? await apiClient.send(WalletEndpoint.favorite, as: [WalletRecipientResponse].self)

        guard contacts != nil || favorites != nil else {
            throw NetworkError.invalidResponse
        }

        let merged = (contacts ?? []) + (favorites ?? [])
        var uniqueRecipientsByIBAN: [String: WalletRecipientResponse] = [:]

        for recipient in merged {
            uniqueRecipientsByIBAN[recipient.iban] = recipient
        }

        return Array(uniqueRecipientsByIBAN.values)
    }

    func fetchOwnerName(iban: String) async throws -> WalletOwnerNameResponse {
        try await apiClient.send(WalletEndpoint.ownerName(iban: iban), as: WalletOwnerNameResponse.self)
    }

    func fetchAnalysis() async throws -> WalletAnalysisResponse {
        try await apiClient.send(WalletEndpoint.analysis, as: WalletAnalysisResponse.self)
    }

    func fetchAIAdvice() async throws -> WalletAIAdviceResponse {
        try await apiClient.send(WalletEndpoint.aiAdvice, as: WalletAIAdviceResponse.self)
    }

    func fetchFinancialGoals() async throws -> [FinancialGoalResponse] {
        try await apiClient.send(WalletEndpoint.financialGoals, as: [FinancialGoalResponse].self)
    }

    func fetchFinancialGoalsSummary() async throws -> FinancialGoalSummaryResponse {
        try await apiClient.send(WalletEndpoint.financialGoalsSummary, as: FinancialGoalSummaryResponse.self)
    }

    func createFinancialGoal(request: CreateFinancialGoalRequest) async throws -> CreateFinancialGoalResponse {
        let body = try isoEncoder.encode(request)
        return try await apiClient.send(WalletEndpoint.createFinancialGoal(body: body), as: CreateFinancialGoalResponse.self)
    }

    func addFinancialGoalFunds(goalID: UUID, request: AddFinancialGoalFundsRequest) async throws -> AddFinancialGoalFundsResponse {
        let body = try encoder.encode(request)
        return try await apiClient.send(WalletEndpoint.addFinancialGoalFunds(goalID: goalID, body: body), as: AddFinancialGoalFundsResponse.self)
    }

    func updateFinancialGoal(goalID: UUID, request: UpdateFinancialGoalRequest) async throws -> Bool {
        let body = try isoEncoder.encode(request)
        return try await apiClient.send(WalletEndpoint.updateFinancialGoal(goalID: goalID, body: body), as: Bool.self)
    }

    func closeFinancialGoal(goalID: UUID) async throws -> CloseFinancialGoalResponse {
        try await apiClient.send(WalletEndpoint.closeFinancialGoal(goalID: goalID), as: CloseFinancialGoalResponse.self)
    }

    func fetchFinancialGoalContributions(goalID: UUID) async throws -> [FinancialGoalContributionResponse] {
        try await apiClient.send(WalletEndpoint.financialGoalContributions(goalID: goalID), as: [FinancialGoalContributionResponse].self)
    }

    func fetchPortfolioSummary() async throws -> PortfolioSummaryResponse {
        try await apiClient.send(WalletEndpoint.portfolioSummary, as: PortfolioSummaryResponse.self)
    }

    func fetchPortfolioPrices() async throws -> [PortfolioPriceResponse] {
        try await apiClient.send(WalletEndpoint.portfolioPrices, as: [PortfolioPriceResponse].self)
    }

    func fetchInvestmentHistory() async throws -> PortfolioInvestmentHistoryResponse {
        try await apiClient.send(WalletEndpoint.investmentHistory, as: PortfolioInvestmentHistoryResponse.self)
    }

    func fetchPortfolioAISummary() async throws -> PortfolioAISummaryResponse {
        try await apiClient.send(WalletEndpoint.portfolioAISummary, as: PortfolioAISummaryResponse.self)
    }

    func buyPortfolioAsset(request: PortfolioTradeRequest) async throws -> PortfolioTradeResponse {
        let body = try encoder.encode(request)
        return try await apiClient.send(WalletEndpoint.portfolioBuy(body: body), as: PortfolioTradeResponse.self)
    }

    func sellPortfolioAsset(request: PortfolioTradeRequest) async throws -> PortfolioTradeResponse {
        let body = try encoder.encode(request)
        return try await apiClient.send(WalletEndpoint.portfolioSell(body: body), as: PortfolioTradeResponse.self)
    }

    func createContact(request: CreateWalletContactRequest) async throws {
        let body = try encoder.encode(request)
        try await apiClient.send(WalletEndpoint.contacts(body: body))
    }

    func removeContact(iban: String) async throws -> Bool {
        try await apiClient.send(WalletEndpoint.removeContact(iban: iban), as: Bool.self)
    }

    // request modeli gönderiyoruz
    func transfer(request: WalletTransferRequest) async throws -> WalletTransferResponse {
        let body = try encoder.encode(request) //ilk encode
        return try await apiClient.send(WalletEndpoint.transfer(body: body), as: WalletTransferResponse.self)
    }
}

// gerekli url buradan alınıyor 
 enum WalletEndpoint: Endpoint {
    case myWallet
    case transactions(walletId: String)
    case receipt(transactionId: String)
    case contactsList
    case favorite
    case ownerName(iban: String)
    case analysis
    case aiAdvice
    case financialGoals
    case financialGoalsSummary
    case createFinancialGoal(body: Data)
    case addFinancialGoalFunds(goalID: UUID, body: Data)
    case updateFinancialGoal(goalID: UUID, body: Data)
    case closeFinancialGoal(goalID: UUID)
    case financialGoalContributions(goalID: UUID)
    case portfolioSummary
    case portfolioPrices
    case investmentHistory
    case portfolioAISummary
    case portfolioBuy(body: Data)
    case portfolioSell(body: Data)
    case contacts(body: Data)
    case removeContact(iban: String)
    case transfer(body: Data)

    var path: String {
        switch self {
        case .myWallet:
            return "/api/Wallets/mywallet"
        case .transactions(let walletId):
            return "/api/Wallets/\(walletId)/transactions"
        case .receipt(let transactionId):
            return "/api/Wallets/\(transactionId)/receipt"
        case .contactsList:
            return "/api/Wallets/contacts"
        case .favorite:
            return "/api/Wallets/favorite"
        case .ownerName(let iban):
            return "/api/Wallets/iban/\(iban)/owner-name"
        case .analysis:
            return "/api/Wallets/analysis"
        case .aiAdvice:
            return "/api/Wallets/ai-advice"
        case .financialGoals:
            return "/api/FinancialGoals"
        case .financialGoalsSummary:
            return "/api/FinancialGoals/summary"
        case .createFinancialGoal:
            return "/api/FinancialGoals"
        case .addFinancialGoalFunds(let goalID, _):
            return "/api/FinancialGoals/\(goalID.uuidString)/contributions"
        case .updateFinancialGoal(let goalID, _):
            return "/api/FinancialGoals/\(goalID.uuidString)"
        case .closeFinancialGoal(let goalID):
            return "/api/FinancialGoals/\(goalID.uuidString)/status"
        case .financialGoalContributions(let goalID):
            return "/api/FinancialGoals/\(goalID.uuidString)/contributions"
        case .portfolioSummary:
            return "/api/Portfolios/summary"
        case .portfolioPrices:
            return "/api/Portfolios/prices"
        case .investmentHistory:
            return "/api/Portfolios/transactions"
        case .portfolioAISummary:
            return "/api/Portfolios/ai-summary"
        case .portfolioBuy:
            return "/api/Portfolios/purchases"
        case .portfolioSell:
            return "/api/Portfolios/sales"
        case .contacts:
            return "/api/Wallets/contacts"
        case .removeContact(let iban):
            return "/api/Wallets/remove-contact/\(iban)"
        case .transfer:
            return "/api/Wallets/transfer"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .portfolioBuy, .portfolioSell, .contacts, .transfer, .createFinancialGoal, .addFinancialGoalFunds:
            return .post
        case .updateFinancialGoal:
            return .put
        case .closeFinancialGoal:
            return .patch
        case .removeContact:
            return .delete
        default:
            return .get
        }
    }

    var requiresAuthorization: Bool {
        true
    }

    var body: Data? {
        switch self {
        case .portfolioBuy(let body):
            return body
        case .portfolioSell(let body):
            return body
        case .contacts(let body):
            return body
        case .createFinancialGoal(let body):
            return body
        case .addFinancialGoalFunds(_, let body):
            return body
        case .updateFinancialGoal(_, let body):
            return body
        case .closeFinancialGoal:
            return nil
        case .removeContact:
            return nil
        case .transfer(let body):
            return body
        default:
            return nil
        }
    }
}
