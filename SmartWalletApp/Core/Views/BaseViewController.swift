import UIKit

class BaseViewController: UIViewController {
    private lazy var keyboardDismissTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismissTap))
        return gesture
    }()

    func showAlert(
        title: String = "Bilgi",
        message: String,
        buttonTitle: String = "Tamam"
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
    }

    func installKeyboardDismissTap(cancelsTouchesInView: Bool = false) {
        guard keyboardDismissTapGesture.view == nil else { return }
        keyboardDismissTapGesture.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(keyboardDismissTapGesture)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
     func handleKeyboardDismissTap() {
        dismissKeyboard()
    }

    nonisolated deinit {}
}
