import Foundation
import Network

final class NetworkReachabilityService {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.smartwallet.network.reachability")
    private var isChecking = false

    func checkInitialConnection(_ completion: @escaping (Bool) -> Void) {
        guard !isChecking else { return }
        isChecking = true

        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                completion(path.status == .satisfied)
                self?.monitor.cancel()
                self?.isChecking = false
            }
        }

        monitor.start(queue: queue)
    }
}
