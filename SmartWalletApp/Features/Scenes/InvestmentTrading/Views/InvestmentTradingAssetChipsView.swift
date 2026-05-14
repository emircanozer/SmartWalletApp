import UIKit

final class InvestmentTradingAssetChipsView: UIView {
    var onSelectionChanged: ((InvestmentTradingAssetType) -> Void)?

    private let scrollView = UIScrollView()
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

// Bu fonksiyon item listesini alıyor ve her biri için UIButton yaratıyor 
extension InvestmentTradingAssetChipsView {
    func configure(with items: [InvestmentTradingAssetChipItem]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        items.forEach { item in
            let button = UIButton(type: .system)
            var configuration = UIButton.Configuration.filled()
            configuration.title = item.title
            configuration.baseBackgroundColor = item.isSelected ? AppColor.primaryYellow : AppColor.whitePrimary
            configuration.baseForegroundColor = item.isSelected ? AppColor.primaryText : AppColor.secondaryText
            configuration.cornerStyle = .capsule
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)
            button.configuration = configuration
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: item.isSelected ? .bold : .semibold)
            button.layer.cornerRadius = 18
            button.layer.borderWidth = 1
            button.layer.borderColor = (item.isSelected ? AppColor.primaryYellow : AppColor.borderSoft).cgColor
            button.tag = item.assetType.backendValue
            button.addTarget(self, action: #selector(handleChipTap(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    // seçileni clasoure ile gönderiyor 
    @objc private func handleChipTap(_ sender: UIButton) {
        onSelectionChanged?(InvestmentTradingAssetType(backendValue: sender.tag))
    }
}

extension InvestmentTradingAssetChipsView {
    func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        stackView.axis = .horizontal
        stackView.spacing = 10
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }

    func setupLayout() {
        [scrollView, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}
