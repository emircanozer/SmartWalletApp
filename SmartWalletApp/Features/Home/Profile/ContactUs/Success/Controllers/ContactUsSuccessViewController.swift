import UIKit

final class ContactUsSuccessViewController: UIViewController {
    var onBack: (() -> Void)?
    var onReturnHome: (() -> Void)?
    var onCreateNewMessage: (() -> Void)?

    private let viewModel: ContactUsSuccessViewModel
    private let contentView = ContactUsSuccessContentView()

    init(viewModel: ContactUsSuccessViewModel) {
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
        contentView.apply(viewModel.makeViewData())
    }
}

private extension ContactUsSuccessViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.homeButton.addTarget(self, action: #selector(handleReturnHomeTap), for: .touchUpInside)
        contentView.newMessageButton.addTarget(self, action: #selector(handleCreateNewMessageTap), for: .touchUpInside)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleReturnHomeTap() {
        onReturnHome?()
    }

    @objc func handleCreateNewMessageTap() {
        onCreateNewMessage?()
    }
}
