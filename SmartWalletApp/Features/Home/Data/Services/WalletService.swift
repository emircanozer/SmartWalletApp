import Foundation

final class WalletService {
    private let apiClient: APIClient
    private let encoder = JSONEncoder()

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

    func fetchRecipients() async throws -> [WalletRecipientResponse] {
        try await apiClient.send(WalletEndpoint.recipients, as: [WalletRecipientResponse].self)
    }

    func fetchOwnerName(iban: String) async throws -> WalletOwnerNameResponse {
        try await apiClient.send(WalletEndpoint.ownerName(iban: iban), as: WalletOwnerNameResponse.self)
    }

    func fetchAnalysis() async throws -> WalletAnalysisResponse {
        try await apiClient.send(WalletEndpoint.analysis, as: WalletAnalysisResponse.self)
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
    case recipients
    case ownerName(iban: String)
    case analysis
    case portfolioSummary
    case portfolioPrices
    case investmentHistory
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
        case .recipients:
            return "/api/Wallets/recipients"
        case .ownerName(let iban):
            return "/api/Wallets/iban/\(iban)/owner-name"
        case .analysis:
            return "/api/Wallets/analysis"
        case .portfolioSummary:
            return "/api/Portfolios/summary"
        case .portfolioPrices:
            return "/api/Portfolios/prices"
        case .investmentHistory:
            return "/api/Portfolios/investment-history"
        case .portfolioBuy:
            return "/api/Portfolios/buy"
        case .portfolioSell:
            return "/api/Portfolios/sell"
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
        case .portfolioBuy, .portfolioSell, .contacts, .transfer:
            return .post
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
        case .removeContact:
            return nil
        case .transfer(let body):
            return body
        default:
            return nil
        }
    }
}
