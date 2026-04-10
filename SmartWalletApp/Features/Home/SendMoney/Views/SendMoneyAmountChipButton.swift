import UIKit

final class SendMoneyAmountChipButton: UIButton {
    let amount: Decimal

    init(amount: Decimal) {
        self.amount = amount
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        setTitleColor(AppColor.inputText, for: .normal)
        backgroundColor = AppColor.white92
        setTitle(Self.makeTitle(for: amount), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    func applySelected(_ isSelected: Bool) {
        backgroundColor = isSelected
            ? AppColor.primaryYellow
            : AppColor.white92
        setTitleColor(
            isSelected
                ? AppColor.primaryText
                : AppColor.inputText,
            for: .normal
        )
    }
}

 extension SendMoneyAmountChipButton {
    static func makeTitle(for amount: Decimal) -> String {
        let amountText = NSDecimalNumber(decimal: amount).stringValue
        return "\(amountText) TL"
    }
}
