import UIKit

final class InvestmentTradingDirectionSegmentView: UIView {
    var onDirectionChanged: ((InvestmentTradeDirection) -> Void)?

    private let backgroundView = UIView()
    private let stackView = UIStackView()
    private let buyButton = UIButton(type: .system)
    private let sellButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = 18
        buyButton.layer.cornerRadius = 14
        sellButton.layer.cornerRadius = 14
    }
}

extension InvestmentTradingDirectionSegmentView {
    func configure(selectedDirection: InvestmentTradeDirection) {
        applyStyle(to: buyButton, title: InvestmentTradeDirection.buy.title, isSelected: selectedDirection == .buy)
        applyStyle(to: sellButton, title: InvestmentTradeDirection.sell.title, isSelected: selectedDirection == .sell)
    }
}

 extension InvestmentTradingDirectionSegmentView {
    func configureView() {
        backgroundView.backgroundColor = AppColor.surfaceMuted

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        buyButton.addTarget(self, action: #selector(handleBuyTap), for: .touchUpInside)
        sellButton.addTarget(self, action: #selector(handleSellTap), for: .touchUpInside)
    }

    func buildHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        [buyButton, sellButton].forEach(stackView.addArrangedSubview)
    }

    func setupLayout() {
        [backgroundView, stackView, buyButton, sellButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func applyStyle(to button: UIButton, title: String, isSelected: Bool) {
        button.configuration = nil
        button.setTitle(title, for: .normal)
        button.setTitleColor(isSelected ? AppColor.accentOlive : AppColor.secondaryText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: isSelected ? .bold : .semibold)
        button.backgroundColor = isSelected ? AppColor.whitePrimary : .clear
    }

    @objc func handleBuyTap() {
        onDirectionChanged?(.buy)
    }

    @objc func handleSellTap() {
        onDirectionChanged?(.sell)
    }
}
