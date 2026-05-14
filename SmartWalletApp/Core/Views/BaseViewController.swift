import UIKit

class BaseViewController: UIViewController {
    enum KeyboardObservationMode {
        case willShowHide
        case willChangeFrame
    }

    private lazy var keyboardDismissTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismissTap))
        return gesture
    }()
    private var keyboardObservationMode: KeyboardObservationMode?

    func showAlert(
        title: String = "Bilgi",
        message: String,
        buttonTitle: String = "Tamam",
        onDismiss: (() -> Void)? = nil
    ) {
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            onDismiss?()
        })
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

    func startObservingKeyboard(_ mode: KeyboardObservationMode = .willShowHide) {
        stopObservingKeyboard()
        keyboardObservationMode = mode

        switch mode {
        case .willShowHide:
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleKeyboardWillShowNotification),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        case .willChangeFrame:
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleKeyboardWillChangeFrameNotification),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil
            )
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHideNotification),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func stopObservingKeyboard() {
        guard keyboardObservationMode != nil else { return }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        keyboardObservationMode = nil
    }

    @objc
    dynamic func keyboardDidUpdate(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {}

    @objc
    // dynamic burada şart değil ama bu metod override edilebilir bir hook diyoruz @objc/dynamic birlikte UIKit runtime'da daha uyumlu yapıyor.
    dynamic func keyboardDidHide(duration: TimeInterval, options: UIView.AnimationOptions) {}

    @objc
    private func handleKeyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let height = max(0, keyboardFrame.height - view.safeAreaInsets.bottom)
        keyboardDidUpdate(
            height: height,
            duration: keyboardAnimationDuration(from: notification),
            options: keyboardAnimationOptions(from: notification)
        )
    }

    @objc
    private func handleKeyboardWillChangeFrameNotification(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let height = max(view.bounds.maxY - keyboardFrameInView.minY, 0)
        keyboardDidUpdate(
            height: height,
            duration: keyboardAnimationDuration(from: notification),
            options: keyboardAnimationOptions(from: notification)
        )
    }

    @objc
    private func handleKeyboardWillHideNotification(_ notification: Notification) {
        keyboardDidHide(
            duration: keyboardAnimationDuration(from: notification),
            options: keyboardAnimationOptions(from: notification)
        )
    }

    private func keyboardAnimationDuration(from notification: Notification) -> TimeInterval {
        notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
    }

    private func keyboardAnimationOptions(from notification: Notification) -> UIView.AnimationOptions {
        let curveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        return UIView.AnimationOptions(rawValue: curveRawValue << 16)
    }

    // Ben yok olurken üzerimde kalan tüm notification aboneliklerini kaldır
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
