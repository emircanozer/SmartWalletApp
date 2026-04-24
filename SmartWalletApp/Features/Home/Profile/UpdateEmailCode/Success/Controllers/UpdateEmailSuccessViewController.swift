import UIKit

final class UpdateEmailSuccessViewController: UIViewController {
    var onReturnHome: (() -> Void)?

    private let viewModel: UpdateEmailSuccessViewModel
    private let contentView = UpdateEmailSuccessContentView()

    init(viewModel: UpdateEmailSuccessViewModel) {
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

 extension UpdateEmailSuccessViewController {
    func bindActions() {
        contentView.homeButton.addTarget(self, action: #selector(handleHomeTap), for: .touchUpInside)
    }

    @objc func handleHomeTap() {
        onReturnHome?()
    }
}
