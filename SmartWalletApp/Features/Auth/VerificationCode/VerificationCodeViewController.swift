import UIKit

class VerificationCodeViewController: UIViewController {
    var onBackToLogin: (() -> Void)?
    var onVerify: (() -> Void)?

    private let viewModel: VerificationCodeViewModel
    private var timer: Timer?
    private var remainingSeconds: Int
    private var keyboardTapGesture: UITapGestureRecognizer?

    private let contentView = UIView()
    private let logoWrapper = UIView()
    private let logoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let codeInputView: VerificationCodeInputView
    private let verifyButton = UIButton(type: .system)
    private let resendButton = UIButton(type: .system)
    private let timerStack = UIStackView()
    private let timerIconView = UIImageView()
    private let timerLabel = UILabel()
    private let backToLoginButton = UIButton(type: .system)

    init(viewModel: VerificationCodeViewModel) {
        self.viewModel = viewModel
        self.remainingSeconds = viewModel.timerSeconds
        self.codeInputView = VerificationCodeInputView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
        bindActions()
        observeKeyboard()
        startTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeInputView.focus()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoWrapper.layer.cornerRadius = 18
        verifyButton.layer.cornerRadius = verifyButton.bounds.height / 2
    }

    deinit { // bu ViewController hafızadan silinirken çalışır 
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

private extension VerificationCodeViewController {
    func configureView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        contentView.backgroundColor = .white

        logoWrapper.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        logoWrapper.layer.shadowColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
        logoWrapper.layer.shadowOpacity = 0.18
        logoWrapper.layer.shadowRadius = 18
        logoWrapper.layer.shadowOffset = CGSize(width: 0, height: 10)

        logoImageView.image = UIImage(systemName: "wallet.pass.fill")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit

        brandLabel.textAlignment = .center
        brandLabel.font = .systemFont(ofSize: 18, weight: .bold)
        brandLabel.textColor = UIColor(red: 0.2, green: 0.22, blue: 0.28, alpha: 1.0)

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0)

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0)
        subtitleLabel.numberOfLines = 0

        verifyButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        verifyButton.setTitleColor(UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), for: .normal)
        verifyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        verifyButton.layer.shadowColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
        verifyButton.layer.shadowOpacity = 0.18
        verifyButton.layer.shadowRadius = 18
        verifyButton.layer.shadowOffset = CGSize(width: 0, height: 10)

        resendButton.setTitleColor(UIColor(red: 0.47, green: 0.49, blue: 0.56, alpha: 1.0), for: .normal)
        resendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        resendButton.isHidden = true

        timerStack.axis = .horizontal
        timerStack.alignment = .center
        timerStack.spacing = 4

        timerIconView.image = UIImage(systemName: "clock")
        timerIconView.tintColor = UIColor(red: 0.63, green: 0.65, blue: 0.71, alpha: 1.0)
        timerIconView.contentMode = .scaleAspectFit

        timerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = UIColor(red: 0.63, green: 0.65, blue: 0.71, alpha: 1.0)

        backToLoginButton.setTitleColor(UIColor(red: 0.42, green: 0.44, blue: 0.5, alpha: 1.0), for: .normal)
        backToLoginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        keyboardTapGesture = tapGesture
    }

    func buildHierarchy() {
        view.addSubview(contentView)

        contentView.addSubview(logoWrapper)
        logoWrapper.addSubview(logoImageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(codeInputView)
        contentView.addSubview(verifyButton)
        contentView.addSubview(resendButton)
        contentView.addSubview(timerStack)
        contentView.addSubview(backToLoginButton)

        timerStack.addArrangedSubview(timerIconView)
        timerStack.addArrangedSubview(timerLabel)
    }
}

private extension VerificationCodeViewController {
    func setupLayout() {
        [
            contentView,
            logoWrapper,
            logoImageView,
            brandLabel,
            titleLabel,
            subtitleLabel,
            codeInputView,
            verifyButton,
            resendButton,
            timerStack,
            timerIconView,
            backToLoginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            logoWrapper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 84),
            logoWrapper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoWrapper.widthAnchor.constraint(equalToConstant: 56),
            logoWrapper.heightAnchor.constraint(equalToConstant: 56),

            logoImageView.centerXAnchor.constraint(equalTo: logoWrapper.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoWrapper.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 22),
            logoImageView.heightAnchor.constraint(equalToConstant: 22),

            brandLabel.topAnchor.constraint(equalTo: logoWrapper.bottomAnchor, constant: 14),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 56),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),

            codeInputView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 34),
            codeInputView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            codeInputView.heightAnchor.constraint(equalToConstant: 44),

            verifyButton.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 36),
            verifyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            verifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            verifyButton.heightAnchor.constraint(equalToConstant: 46),

            resendButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 22),
            resendButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            timerStack.topAnchor.constraint(equalTo: resendButton.bottomAnchor, constant: 8),
            timerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            timerIconView.widthAnchor.constraint(equalToConstant: 14),
            timerIconView.heightAnchor.constraint(equalToConstant: 14),

            backToLoginButton.topAnchor.constraint(equalTo: timerStack.bottomAnchor, constant: 54),
            backToLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

private extension VerificationCodeViewController {
    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        verifyButton.setTitle(viewModel.buttonTitle, for: .normal)
        resendButton.setTitle(viewModel.resendTitle, for: .normal)
        backToLoginButton.setTitle("←  \(viewModel.backTitle)", for: .normal)
        updateTimerUI()
    }

    func bindActions() {
        backToLoginButton.addTarget(self, action: #selector(handleBackToLoginTap), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(handleResendTap), for: .touchUpInside)
        verifyButton.addTarget(self, action: #selector(handleVerifyTap), for: .touchUpInside)
        codeInputView.onCodeChange = { [weak self] _ in // closure proplar kullanıldıkları yerde closure ve weak self ile kullanılır
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
        remainingSeconds = viewModel.timerSeconds
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
        timerStack.isHidden = isFinished
        resendButton.isHidden = !isFinished
        resendButton.setTitleColor(UIColor(red: 0.87, green: 0.23, blue: 0.23, alpha: 1.0), for: .normal)
        timerLabel.text = "\(remainingSeconds) saniye"
    }

    func updateVerifyButtonState() { // diğer sayfadan gelen code countu 6 ise butonu aktif hale getir
        let isEnabled = codeInputView.code.count == 6
        verifyButton.alpha = isEnabled ? 1 : 0.65
    }

    @objc func handleBackToLoginTap() {
        onBackToLogin?()
    }

    @objc func handleResendTap() {
        codeInputView.clear()
        startTimer()
        codeInputView.focus()
        updateVerifyButtonState()
    }

    @objc func handleVerifyTap() {
        guard codeInputView.code.count == 6 else { return }
        onVerify?()
    }

    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        let translation = min((keyboardHeight * 0.32), 96)

        UIView.animate(withDuration: duration) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -translation)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

        UIView.animate(withDuration: duration) {
            self.contentView.transform = .identity
        }
    }
}
