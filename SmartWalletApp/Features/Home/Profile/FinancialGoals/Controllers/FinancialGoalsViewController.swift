import Foundation
import UIKit

final class FinancialGoalsViewController: BaseViewController {
    var onBack: (() -> Void)?
    var onCreateGoalRequested: (() -> Void)?
    var onGoalSelected: ((FinancialGoalRecord) -> Void)?

    private let viewModel: FinancialGoalsViewModel
    private let contentView = FinancialGoalsContentView()

    init(viewModel: FinancialGoalsViewModel) {
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
        Task { [weak self] in
            await self?.viewModel.load()
        }
    }
}

extension FinancialGoalsViewController {
    func addGoal(_ draft: FinancialGoalDraft) {
        viewModel.addGoal(draft)
    }

    func addContribution(to goalID: UUID, amount: Decimal) {
        viewModel.addContribution(to: goalID, amount: amount)
    }

    func updateGoal(_ goal: FinancialGoalRecord) {
        viewModel.updateGoal(goal)
    }

    func deleteGoal(id: UUID) {
        viewModel.deleteGoal(id: id)
    }

    private func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.onCreateGoalTap = { [weak self] in
            self?.onCreateGoalRequested?()
        }
        contentView.onGoalSelected = { [weak self] id in
            guard let self, let goal = self.viewModel.goalRecord(for: id) else { return }
            self.onGoalSelected?(goal)
        }
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] data in
            self?.contentView.apply(data)
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(message: message)
        }
    }

    @objc private func handleBackTap() {
        onBack?()
    }
}
