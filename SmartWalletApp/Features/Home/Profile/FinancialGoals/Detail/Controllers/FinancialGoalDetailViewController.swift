import Foundation
import UIKit

final class FinancialGoalDetailViewController: BaseViewController {
    var onBack: (() -> Void)?
    var onAddMoney: ((FinancialGoalRecord, FinancialGoalDetailViewController) -> Void)?
    var onEdit: ((FinancialGoalRecord, FinancialGoalDetailViewController) -> Void)?

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
        bindViewModel()
        contentView.apply(viewModel.makeViewData())
        Task { [weak self] in
            await self?.viewModel.load()
        }
    }
}

extension FinancialGoalDetailViewController {
    func applyUpdatedGoal(_ goal: FinancialGoalRecord) {
        viewModel.replaceGoal(with: goal)
        contentView.apply(viewModel.makeViewData())
    }

    @MainActor
    func reloadData() async {
        await viewModel.load()
    }

    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.addMoneyButton.addTarget(self, action: #selector(handleAddMoneyTap), for: .touchUpInside)
        contentView.editButton.addTarget(self, action: #selector(handleEditTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] data in
            self?.contentView.apply(data)
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(message: message)
        }
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleAddMoneyTap() {
        onAddMoney?(viewModel.goalRecord, self)
    }

    @objc func handleEditTap() {
        onEdit?(viewModel.goalRecord, self)
    }
}
