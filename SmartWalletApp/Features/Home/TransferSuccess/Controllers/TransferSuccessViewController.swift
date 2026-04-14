import UIKit

final class TransferSuccessViewController: UIViewController {
    var onReturnHome: (() -> Void)?
    var onViewReceipt: (() -> Void)?

    private let viewModel: TransferSuccessViewModel
    private let contentView = TransferSuccessContentView()

    init(viewModel: TransferSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "TRANSFER"
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
        bindViewModel()
        bindActions()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension TransferSuccessViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .loaded(let data):
                self.contentView.applyData(data)
            }
        }
    }

    func bindActions() {
        contentView.returnHomeButton.addTarget(self, action: #selector(handleReturnHomeTap), for: .touchUpInside)
        contentView.receiptButton.addTarget(self, action: #selector(handleReceiptTap), for: .touchUpInside)
    }

    @objc func handleReturnHomeTap() {
        onReturnHome?()
    }

    @objc func handleReceiptTap() {
        if let onViewReceipt {
            onViewReceipt()
            return
        }

        let alert = UIAlertController(
            title: "Bilgi",
            message: "Dekont ekranını bir sonraki adımda bağlayacağız.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
