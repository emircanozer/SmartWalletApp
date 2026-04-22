import MessageUI
import UIKit

final class ContactUsViewController: UIViewController {
    var onBack: (() -> Void)?
    var onMailSent: (() -> Void)?

    private let viewModel: ContactUsViewModel
    private let contentView = ContactUsContentView()

    init(viewModel: ContactUsViewModel) {
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
        configureKeyboardHandling()
        contentView.apply(viewModel.makeViewData())
        viewModel.updateForm(name: "", email: "", message: "")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ContactUsViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.sendButton.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)
        contentView.nameField.setEditingChangedTarget(self, action: #selector(handleFormChanged))
        contentView.emailField.setEditingChangedTarget(self, action: #selector(handleFormChanged))
        contentView.nameField.setEditingDidBeginTarget(self, action: #selector(handleNameFocus))
        contentView.emailField.setEditingDidBeginTarget(self, action: #selector(handleEmailFocus))
        contentView.messageTextView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                break
            case .formUpdated(let isSendEnabled):
                self.contentView.setSendEnabled(isSendEnabled)
            case .mailDraft(let draft):
                self.presentMailComposer(with: draft)
            case .failure(let message):
                self.showAlert(message: message)
            }
        }
    }

    func configureKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func presentMailComposer(with draft: ContactUsMailDraft) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([draft.recipient])
            mailController.setSubject(draft.subject)
            mailController.setMessageBody(draft.body, isHTML: false)
            present(mailController, animated: true)
            return
        }

        openMailApp(with: draft)
    }

    func openMailApp(with draft: ContactUsMailDraft) {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = draft.recipient
        components.queryItems = [
            URLQueryItem(name: "subject", value: draft.subject),
            URLQueryItem(name: "body", value: draft.body)
        ]

        guard let url = components.url, UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Mail uygulaması açılamadı. Lütfen cihazınızda bir mail hesabı tanımlayın.")
            return
        }

        UIApplication.shared.open(url)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func updateForm() {
        viewModel.updateForm(
            name: contentView.nameField.trimmedText,
            email: contentView.emailField.trimmedText,
            message: contentView.messageText
        )
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleSendTap() {
        view.endEditing(true)
        viewModel.sendMessage(
            name: contentView.nameField.trimmedText,
            email: contentView.emailField.trimmedText,
            message: contentView.messageText
        )
    }

    @objc func handleFormChanged() {
        updateForm()
    }

    @objc func handleNameFocus() {
        contentView.scrollToVisible(contentView.nameField)
    }

    @objc func handleEmailFocus() {
        contentView.scrollToVisible(contentView.emailField)
    }

    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }

    @objc func handleKeyboardWillChangeFrame(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let overlap = max(view.bounds.maxY - keyboardFrameInView.minY, 0)
        contentView.setKeyboardBottomInset(overlap + 20)
    }

    @objc func handleKeyboardWillHide() {
        contentView.setKeyboardBottomInset(0)
    }
}

extension ContactUsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentView.scrollToVisible(textView)
    }

    func textViewDidChange(_ textView: UITextView) {
        contentView.updateMessagePlaceholderVisibility()
        updateForm()
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) { [weak self] in
            if result == .sent {
                self?.onMailSent?()
            }
        }
    }
}
