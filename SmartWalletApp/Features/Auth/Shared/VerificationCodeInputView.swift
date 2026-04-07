import UIKit

class VerificationCodeInputView: UIView {
    var onCodeChange: ((String) -> Void)? // her zaman parametresiz verirdik bu sefer sadece dışarıya haber verimiyor event değil veri de taşıyor

    private let stackView = UIStackView()
    private let textField = UITextField()
    private let digitCount: Int
    private var digitViews: [VerificationDigitView] = []

     var code = "" { // private yapabilirdik private set...?
        didSet {
            updateDigits()
            onCodeChange?(code) // code değişkenini dışarıya gönderiyor 
        }
    } // code her değiştiğinde bu kod bloğu çalışacak

    
    //uiview bir viewcontroller olmadığı için init içinde çağırıyoruz fonksiyonları didload yok burada
    
    
    init(digitCount: Int = 6) {
        self.digitCount = digitCount
        super.init(frame: .zero)
        configureView()
        buildHierarchy()
        setupLayout()
        buildDigits()
        updateDigits()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func focus() {
        textField.becomeFirstResponder() //klavye açar
    }

    func clear() {
        code = ""
        textField.text = ""
    }
}

extension VerificationCodeInputView {
    func configureView() {
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8

        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    func buildHierarchy() {
        addSubview(stackView)
        addSubview(textField)
    }

    func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // ui için iskelet 
    func buildDigits() {
        for _ in 0..<digitCount {
            let digitView = VerificationDigitView()
            digitViews.append(digitView)
            stackView.addArrangedSubview(digitView)
        }
    }

    // parçaladığın her sayıyı kutulara yerleştir aktif kutuyu bul configure ile style ver
    func updateDigits() {
        let characters = Array(code) //stringi arraye dönüştürdük

        for (index, digitView) in digitViews.enumerated() { // tüm kutuları tek tek geziyor
            let symbol = index < characters.count ? String(characters[index]) : ""
            //sayımız 12 ise aktif kutu 3. yani 
            let isActive = index == min(characters.count, digitCount - 1)
            let isFilled = index < characters.count
            digitView.configure(symbol: symbol, isActive: isActive && code.count < digitCount, isFilled: isFilled)
        }
    }

    @objc func handleTap() {
        focus()
    }
}

extension VerificationCodeInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if !code.isEmpty {
                code.removeLast()
                textField.text = code
            }
            return false
        }

        let filtered = string.filter(\.isNumber)
        guard !filtered.isEmpty else { return false }

        let remaining = digitCount - code.count
        guard remaining > 0 else { return false }

        code.append(contentsOf: filtered.prefix(remaining))
        textField.text = code
        return false
    }
}

private class VerificationDigitView: UIView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 44),
            heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }

    func configure(symbol: String, isActive: Bool, isFilled: Bool) {
        titleLabel.text = symbol.isEmpty ? "•" : symbol
        titleLabel.textColor = symbol.isEmpty
            ? AppColor.verificationEmptyText
            : AppColor.verificationFilledText

        backgroundColor = isActive ? .white : AppColor.codeInactive
        layer.borderWidth = isActive ? 3 : 0
        layer.borderColor = isActive ? AppColor.accentBlue.cgColor : UIColor.clear.cgColor

        if isFilled {
            backgroundColor = .white
            layer.borderWidth = 2
            layer.borderColor = AppColor.filledBorder.cgColor
        }
    }
}
