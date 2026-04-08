import UIKit

final class TransferReceiptViewController: UIViewController {
    private let viewModel: TransferReceiptViewModel
    private let contentView = TransferReceiptContentView()
    private var currentData: TransferReceiptViewData?

    init(viewModel: TransferReceiptViewModel) {
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
        enableInteractivePopGesture()
        bindViewModel()
        bindActions()
        loadReceipt()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

 extension TransferReceiptViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
            case .loading:
                self.contentView.setLoading(true)
                // view model state' in içine koyduğu veriyi bu şeiklde aldık 
            case .loaded(let data):
                self.currentData = data
                self.contentView.setLoading(false)
                self.contentView.applyData(data)
            }
        }
    }

    func bindActions() {
        contentView.downloadButton.addTarget(self, action: #selector(handleDownloadTap), for: .touchUpInside)
        contentView.shareButton.addTarget(self, action: #selector(handleShareTap), for: .touchUpInside)
    }

    func loadReceipt() {
        Task {
            await viewModel.load()
        }
    }

    func ensurePDFURL() throws -> URL {
        guard let currentData else {
            throw NSError(domain: "TransferReceipt", code: 1, userInfo: [NSLocalizedDescriptionKey: "Dekont bilgisi henüz hazır değil."])
        }

        // pdf için
        return try TransferReceiptPDFBuilder.exportURL(for: currentData)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleDownloadTap() {
        do {
            let url = try ensurePDFURL()
            //pdf olarak indir
            let picker = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
            present(picker, animated: true)
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }

    @objc func handleShareTap() {
        do {
            let url = try ensurePDFURL()
            //paylaş 
            let activityViewController =
            UIActivityViewController(activityItems: [url], applicationActivities: nil)
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
