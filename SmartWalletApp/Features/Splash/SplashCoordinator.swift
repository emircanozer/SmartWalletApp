import UIKit

final class SplashCoordinator: Coordinator {
    var children: [Coordinator] = []
    var onFinished: (() -> Void)?

    let rootViewController: UIViewController

    private let viewModel = SplashViewModel()

    init() {
        rootViewController = SplashViewController(viewModel: viewModel)
    }
}

extension SplashCoordinator {
    func start() {
        viewModel.onFlowCompleted = { [weak self] in
            self?.onFinished?()
        }
    }
}
