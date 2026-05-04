import UIKit

final class FinancialGoalDetailViewController: BaseViewController {
    var onBack: (() -> Void)?

    private let viewModel: FinancialGoalDetailViewModel
    private let contentView = FinancialGoalDetailContentView()

    init(viewModel: FinancialGoalDetailViewModel) {
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
        enableInteractivePopGesture()
        bindActions()
        contentView.apply(viewModel.makeViewData())
    }
}

 extension FinancialGoalDetailViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }

    @objc func handleBackTap() {
        onBack?()
    }
}
