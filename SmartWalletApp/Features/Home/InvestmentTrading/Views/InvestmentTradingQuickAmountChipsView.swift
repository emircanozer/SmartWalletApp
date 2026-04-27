import UIKit

final class InvestmentTradingQuickAmountChipsView: UIView {
    var onQuickAmountSelected: ((Decimal) -> Void)?

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InvestmentTradingQuickAmountChipsView {
    func configure(with items: [InvestmentTradingQuickAmountItem]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        items.forEach { item in
            let button = UIButton(type: .system)
            var configuration = UIButton.Configuration.plain()
            configuration.title = item.title
            configuration.baseForegroundColor = AppColor.inputText
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
            button.configuration = configuration
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            button.backgroundColor = AppColor.whitePrimary
            button.layer.cornerRadius = 14
            button.layer.borderWidth = 1
            button.layer.borderColor = AppColor.borderSoft.cgColor
            button.accessibilityIdentifier = "\(item.value)"
            button.addAction(UIAction { [weak self] _ in
                self?.onQuickAmountSelected?(item.value)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
}

 extension InvestmentTradingQuickAmountChipsView {
    func configureView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
    }

    func buildHierarchy() {
        addSubview(stackView)
    }

    func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
