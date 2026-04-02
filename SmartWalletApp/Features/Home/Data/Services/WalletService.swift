import Foundation

final class WalletService {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    // auth daki gibi tanımladığımız fonk generic olduğu için burada da aynı apliclent fonsiyonunu kullanıdık 
    func fetchMyWallet() async throws -> MyWalletResponse {
        try await apiClient.send(WalletEndpoint.myWallet, as: MyWalletResponse.self)
    }

    func fetchTransactions(walletId: String) async throws -> [WalletTransactionResponse] {
        try await apiClient.send(WalletEndpoint.transactions(walletId: walletId), as: [WalletTransactionResponse].self)
    }
}

private enum WalletEndpoint: Endpoint {
    case myWallet
    case transactions(walletId: String)

    var path: String {
        switch self {
        case .myWallet:
            return "/api/Wallets/mywallet"
        case .transactions(let walletId):
            return "/api/Wallets/\(walletId)/transactions"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var requiresAuthorization: Bool {
        true
    }
}
