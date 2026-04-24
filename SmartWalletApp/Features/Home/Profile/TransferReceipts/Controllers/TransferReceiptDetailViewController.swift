import UIKit

final class TransferReceiptDetailViewController: UIViewController {
    var onBack: (() -> Void)?
    var onReturnHome: (() -> Void)?

    private let viewModel: TransferReceiptDetailViewModel
    private let contentView = TransferReceiptContentView()
    private var currentData: TransferReceiptViewData?

    init(viewModel: TransferReceiptDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "DEKONT"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindActions()
        configureNavigationBar()
        loadReceipt()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

 extension TransferReceiptDetailViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
            case .loading:
                self.contentView.setLoading(true)
                self.setCenteredLoading(true)
            case .loaded(let data):
                self.currentData = data
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.contentView.applyData(data)
            case .failure(let message):
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func bindActions() {
        contentView.downloadButton.addTarget(self, action: #selector(handleDownloadTap), for: .touchUpInside)
        contentView.shareButton.addTarget(self, action: #selector(handleShareTap), for: .touchUpInside)
    }

    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackTap)
        )
        navigationItem.leftBarButtonItem?.tintColor = AppColor.accentOlive

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "house.fill"),
            style: .plain,
            target: self,
            action: #selector(handleReturnHomeTap)
        )
        navigationItem.rightBarButtonItem?.tintColor = AppColor.accentGold
    }

    func loadReceipt() {
        Task {
            await viewModel.load()
        }
    }

    func ensurePDFURL() throws -> URL {
        guard let currentData else {
            throw NSError(
                domain: "TransferReceiptDetail",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Dekont bilgisi henüz hazır değil."]
            )
        }

        return try TransferReceiptPDFBuilder.exportURL(for: currentData)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleReturnHomeTap() {
        onReturnHome?()
    }

    @objc func handleDownloadTap() {
        do {
            let url = try ensurePDFURL()
            let picker = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
            present(picker, animated: true)
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }

    @objc func handleShareTap() {
        do {
            let url = try ensurePDFURL()
            let activityViewController = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil
            )
            if let popover = activityViewController.popoverPresentationController {
                popover.sourceView = contentView.shareButton
                popover.sourceRect = contentView.shareButton.bounds
            }
            present(activityViewController, animated: true)
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
}
