import UIKit

final class ChangePasswordSuccessViewController: UIViewController {
    var onReturnHome: (() -> Void)?

    private let viewModel: ChangePasswordSuccessViewModel
    private let contentView = ChangePasswordSuccessContentView()

    init(viewModel: ChangePasswordSuccessViewModel) {
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
        contentView.apply(viewModel.makeViewData())
    }
}

 extension ChangePasswordSuccessViewController {
    func bindActions() {
        contentView.homeButton.addTarget(self, action: #selector(handleHomeTap), for: .touchUpInside)
    }

    @objc func handleHomeTap() {
        onReturnHome?()
    }
}
