import UIKit

class VerificationCodeViewController: UIViewController {
    var onBackToLogin: (() -> Void)?
    var onVerify: (() -> Void)?

    private var timer: Timer?
    private let timerSeconds = 30
    private var remainingSeconds: Int
    private let contentView = VerificationCodeContentView()

    init() {
        self.remainingSeconds = timerSeconds
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindActions()
        observeKeyboard()
        startTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.codeInputView.focus()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }

    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

extension VerificationCodeViewController {
    func bindActions() {
        contentView.backToLoginButton.addTarget(self, action: #selector(handleBackToLoginTap), for: .touchUpInside)
        contentView.resendButton.addTarget(self, action: #selector(handleResendTap), for: .touchUpInside)
        contentView.verifyButton.addTarget(self, action: #selector(handleVerifyTap), for: .touchUpInside)
        contentView.codeInputView.onCodeChange = { [weak self] _ in
            self?.updateVerifyButtonState()
        }
        updateVerifyButtonState()
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func startTimer() {
        timer?.invalidate()
        remainingSeconds = timerSeconds
        updateTimerUI()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
                self.updateTimerUI()
            } else {
                timer.invalidate()
            }
        }
    }

    func updateTimerUI() {
        let isFinished = remainingSeconds == 0
        contentView.timerStack.isHidden = isFinished
        contentView.resendButton.isHidden = !isFinished
        contentView.resendButton.setTitleColor(UIColor(red: 0.87, green: 0.23, blue: 0.23, alpha: 1.0), for: .normal)
        contentView.timerLabel.text = "\(remainingSeconds) saniye"
    }

    func updateVerifyButtonState() {
        let isEnabled = contentView.codeInputView.code.count == 6
        contentView.verifyButton.alpha = isEnabled ? 1 : 0.65
    }

    @objc func handleBackToLoginTap() {
        onBackToLogin?()
    }

    @objc func handleResendTap() {
        contentView.codeInputView.clear()
        startTimer()
        contentView.codeInputView.focus()
        updateVerifyButtonState()
    }

    @objc func handleVerifyTap() {
        guard contentView.codeInputView.code.count == 6 else { return }
        onVerify?()
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        let translation = min((keyboardHeight * 0.32), 96)

        UIView.animate(withDuration: duration) {
            self.contentView.moveForKeyboard(y: -translation)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

        UIView.animate(withDuration: duration) {
            self.contentView.moveForKeyboard(y: 0)
        }
    }
}
