import UIKit

final class SendMoneyAmountChipButton: UIButton {
    let amount: Decimal

    init(amount: Decimal) {
        self.amount = amount
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        setTitleColor(UIColor(red: 0.23, green: 0.25, blue: 0.31, alpha: 1.0), for: .normal)
        backgroundColor = UIColor(white: 1.0, alpha: 0.92)
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
            ? UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
            : UIColor(white: 1.0, alpha: 0.92)
        setTitleColor(
            isSelected
                ? UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)
                : UIColor(red: 0.23, green: 0.25, blue: 0.31, alpha: 1.0),
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
