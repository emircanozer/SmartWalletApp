import UIKit

class WelcomeViewController: UIViewController {
    var onLoginTap: (() -> Void)?
    var onRegisterTap: (() -> Void)?

    private let contentView = WelcomeContentView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.view.backgroundColor = .white
        bindActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension WelcomeViewController {
    func bindActions() {
        contentView.primaryButton.addTarget(self, action: #selector(handleLoginTap), for: .touchUpInside)
        contentView.secondaryButton.addTarget(self, action: #selector(handleRegisterTap), for: .touchUpInside)
    }

    @objc func handleLoginTap() {
        onLoginTap?()
    }

    @objc func handleRegisterTap() {
        onRegisterTap?()
    }
}
