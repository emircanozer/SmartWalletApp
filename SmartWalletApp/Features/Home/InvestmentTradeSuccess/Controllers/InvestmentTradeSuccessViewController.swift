import UIKit

final class InvestmentTradeSuccessViewController: UIViewController {
    var onClose: (() -> Void)?
    var onReturnHome: (() -> Void)?
    var onShowHistory: (() -> Void)?

    private let viewModel: InvestmentTradeSuccessViewModel
    private let contentView = InvestmentTradeSuccessContentView()

    init(viewModel: InvestmentTradeSuccessViewModel) {
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
        bindActions()
        bindViewModel()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

 extension InvestmentTradeSuccessViewController {
    func bindActions() {
        contentView.closeButton.addTarget(self, action: #selector(handleReturnHomeTap), for: .touchUpInside)
        contentView.secondaryButton.addTarget(self, action: #selector(handleHistoryTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .loaded(let data):
                self.contentView.apply(data)
            }
        }
    }

    @objc func handleCloseTap() {
        onClose?()
    }

    @objc func handleReturnHomeTap() {
        onReturnHome?()
    }

    @objc func handleHistoryTap() {
        if let onShowHistory {
            onShowHistory()
            return
        }

        let alert = UIAlertController(
            title: "Bilgi",
            message: "İşlem geçmişi ekranını bir sonraki adımda bağlayacağız.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
