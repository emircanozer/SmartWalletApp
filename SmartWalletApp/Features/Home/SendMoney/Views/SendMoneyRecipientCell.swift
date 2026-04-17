import UIKit

final class SendMoneyRecipientCell: UITableViewCell {
    static let reuseIdentifier = "SendMoneyRecipientCell"

    private var recipientRowView: SendMoneyRecipientRowView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recipientRowView?.removeFromSuperview()
        recipientRowView = nil
    }

    func configure(with recipient: SendMoneyRecipient, isSelected: Bool) {
        recipientRowView?.removeFromSuperview()

        let rowView = SendMoneyRecipientRowView(recipient: recipient)
        rowView.applySelected(isSelected)
        rowView.isUserInteractionEnabled = false
        rowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rowView)

        NSLayoutConstraint.activate([
            rowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        recipientRowView = rowView
    }
}
