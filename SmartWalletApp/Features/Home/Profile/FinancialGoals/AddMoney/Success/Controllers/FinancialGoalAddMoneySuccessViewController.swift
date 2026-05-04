import UIKit

final class FinancialGoalAddMoneySuccessViewController: BaseViewController {
    var onReturnToGoal: (() -> Void)?

    private let viewModel: FinancialGoalAddMoneySuccessViewModel
    private let contentView = FinancialGoalAddMoneySuccessContentView()

    init(viewModel: FinancialGoalAddMoneySuccessViewModel) {
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
        contentView.apply(viewModel.makeViewData())
        bindActions()
    }
}

 extension FinancialGoalAddMoneySuccessViewController {
    func bindActions() {
        contentView.returnButton.addTarget(self, action: #selector(handleReturnTap), for: .touchUpInside)
    }

    @objc func handleReturnTap() {
        onReturnToGoal?()
    }
}
