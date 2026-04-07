import UIKit

final class ResetPasswordSuccessViewController: UIViewController {
    var onLoginTap: (() -> Void)?
    var onHomeTap: (() -> Void)?

    private let viewModel: ResetPasswordSuccessViewModel
    private let contentView = ResetPasswordSuccessContentView()

    init(viewModel: ResetPasswordSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindActions()
        bindViewModel()
        viewModel.load()
    }
}

extension ResetPasswordSuccessViewController {
    func bindActions() {
        contentView.loginButton.addTarget(self, action: #selector(handleLoginTap), for: .touchUpInside)
        contentView.homeButton.addTarget(self, action: #selector(handleHomeTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .loaded(let data):
                self.contentView.apply(data: data)
            case .countdown(let seconds):
                self.contentView.updateCountdown(seconds: seconds)
            case .routeToLogin:
                self.onLoginTap?()
            }
        }
    }

    @objc func handleLoginTap() {
        viewModel.cancelCountdown()
        onLoginTap?()
    }

    @objc func handleHomeTap() {
        viewModel.cancelCountdown()
        onHomeTap?()
    }
}
