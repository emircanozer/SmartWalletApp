import UIKit

class RegisterViewController: UIViewController {
    var onLogin: (() -> Void)?
    var onVerify: (() -> Void)?

    private let contentView = RegisterContentView()
    private var isTermsAccepted = false

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        updateCheckboxAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension RegisterViewController {
    func bindActions() {
        contentView.checkboxButton.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
        contentView.loginButton.addTarget(self, action: #selector(handleLoginTap), for: .touchUpInside)
        contentView.registerButton.addTarget(self, action: #selector(handleRegisterTap), for: .touchUpInside)
        contentView.passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
    }

    func updateCheckboxAppearance() {
        let imageName = isTermsAccepted ? "checkmark" : nil
        contentView.checkboxButton.setImage(imageName == nil ? nil : UIImage(systemName: imageName!), for: .normal)
    }

    @objc func handleCheckboxTap() {
        isTermsAccepted.toggle()
        updateCheckboxAppearance()
    }

    @objc func handleLoginTap() {
        onLogin?()
    }

    @objc func handleRegisterTap() {
        onVerify?()
    }

    @objc func handlePasswordVisibilityTap() {
        contentView.passwordField.toggleSecureEntry()
    }
}
