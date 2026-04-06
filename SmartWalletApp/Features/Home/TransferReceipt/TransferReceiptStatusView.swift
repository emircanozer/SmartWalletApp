import UIKit

final class TransferReceiptStatusView: UIView {
    private let glowView = UIView()
    private let outerCircleView = UIView()
    private let middleCircleView = UIView()
    private let innerCircleView = UIView()
    private let checkImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        [glowView, outerCircleView, middleCircleView, innerCircleView].forEach {
            $0.layer.cornerRadius = min($0.bounds.width, $0.bounds.height) / 2
        }
    }
}

extension TransferReceiptStatusView {
    func configureView() {
        glowView.backgroundColor = UIColor(red: 1.0, green: 0.85, blue: 0.15, alpha: 0.18)
        glowView.layer.shadowColor = UIColor(red: 1.0, green: 0.84, blue: 0.1, alpha: 1.0).cgColor
        glowView.layer.shadowOpacity = 0.34
        glowView.layer.shadowRadius = 24
        glowView.layer.shadowOffset = .zero

        outerCircleView.backgroundColor = UIColor(red: 0.18, green: 0.19, blue: 0.21, alpha: 1.0)

        middleCircleView.backgroundColor = .clear
        middleCircleView.layer.borderWidth = 5
        middleCircleView.layer.borderColor = UIColor(red: 0.63, green: 0.54, blue: 0.11, alpha: 0.9).cgColor

        innerCircleView.backgroundColor = UIColor(red: 1.0, green: 0.83, blue: 0.08, alpha: 1.0)

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .black)
        checkImageView.image = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
        checkImageView.tintColor = UIColor(red: 0.18, green: 0.19, blue: 0.21, alpha: 1.0)
        checkImageView.contentMode = .scaleAspectFit
    }

    func buildHierarchy() {
        [glowView, outerCircleView, middleCircleView, innerCircleView].forEach(addSubview)
        innerCircleView.addSubview(checkImageView)

        [glowView, outerCircleView, middleCircleView, innerCircleView, checkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            glowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            glowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            glowView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.96),
            glowView.heightAnchor.constraint(equalTo: glowView.widthAnchor),

            outerCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerCircleView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.62),
            outerCircleView.heightAnchor.constraint(equalTo: outerCircleView.widthAnchor),

            middleCircleView.centerXAnchor.constraint(equalTo: outerCircleView.centerXAnchor),
            middleCircleView.centerYAnchor.constraint(equalTo: outerCircleView.centerYAnchor),
            middleCircleView.widthAnchor.constraint(equalTo: outerCircleView.widthAnchor, multiplier: 0.72),
            middleCircleView.heightAnchor.constraint(equalTo: middleCircleView.widthAnchor),

            innerCircleView.centerXAnchor.constraint(equalTo: outerCircleView.centerXAnchor),
            innerCircleView.centerYAnchor.constraint(equalTo: outerCircleView.centerYAnchor),
            innerCircleView.widthAnchor.constraint(equalTo: outerCircleView.widthAnchor, multiplier: 0.34),
            innerCircleView.heightAnchor.constraint(equalTo: innerCircleView.widthAnchor),

            checkImageView.centerXAnchor.constraint(equalTo: innerCircleView.centerXAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: innerCircleView.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalTo: innerCircleView.widthAnchor, multiplier: 0.46),
            checkImageView.heightAnchor.constraint(equalTo: checkImageView.widthAnchor)
        ])
    }
}
