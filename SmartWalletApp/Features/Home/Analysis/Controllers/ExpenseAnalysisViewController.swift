import UIKit

final class ExpenseAnalysisViewController: UIViewController {
    var onBack: (() -> Void)?

    private let viewModel: ExpenseAnalysisViewModel
    private let contentView = ExpenseAnalysisContentView()

    init(viewModel: ExpenseAnalysisViewModel) {
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
        loadData()
    }
}

 extension ExpenseAnalysisViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
            case .loading:
                self.contentView.setLoading(true)
            case .loaded(let data):
                self.contentView.setLoading(false)
                self.contentView.apply(data)
            }
        }
    }

    func loadData() {
        Task {
            await viewModel.load()
        }
    }
    @objc func handleBackTap() {
        onBack?()
    }
}
