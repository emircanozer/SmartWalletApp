import UIKit

final class InvestmentTradeConfirmationViewController: BaseViewController {
    var onBack: (() -> Void)?
    var onApproved: ((InvestmentTradeSuccessContext) -> Void)?

    private let viewModel: InvestmentTradeConfirmationViewModel
    private let contentView = InvestmentTradeConfirmationContentView()

    init(viewModel: InvestmentTradeConfirmationViewModel) {
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
        enableInteractivePopGesture()
        bindActions()
        bindViewModel()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

 extension InvestmentTradeConfirmationViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(handleConfirmTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setCenteredLoading(false)
            case .loading:
                self.setCenteredLoading(true)
            case .loaded(let data):
                self.setCenteredLoading(false)
                self.contentView.apply(data)
            case .failure(let message):
                self.setCenteredLoading(false)
                self.showAlert(message: message)
            case .approved(let context):
                self.setCenteredLoading(false)
                self.onApproved?(context)
            }
        }
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleConfirmTap() {
        Task {
            await viewModel.confirmTrade()
        }
    }
}
