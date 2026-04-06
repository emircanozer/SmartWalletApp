import UIKit

final class TransferSuccessIndicatorView: UIView {
    
    private let glowView = UIView()
    private let outerRingView = UIView()
    private let middleRingView = UIView()
    private let innerCircleView = UIView()
    private let checkImageView = UIImageView()

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

        // Layout'u zorla oturt
        //AutoLayout’ı şimdi çalıştır
        self.layoutIfNeeded()

       
        [glowView, outerRingView, middleRingView, innerCircleView].forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }

        outerRingView.clipsToBounds = true
        middleRingView.clipsToBounds = true
        innerCircleView.clipsToBounds = true

        
        glowView.layer.shadowPath = UIBezierPath(ovalIn: glowView.bounds).cgPath
    }
}


 extension TransferSuccessIndicatorView {

    func configureView() {
        backgroundColor = .clear

       
        glowView.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.35, alpha: 0.16)
        glowView.layer.shadowColor = UIColor(red: 1.0, green: 0.86, blue: 0.2, alpha: 0.72).cgColor
        glowView.layer.shadowOpacity = 1
        glowView.layer.shadowRadius = 38
        glowView.layer.shadowOffset = .zero

       
        outerRingView.backgroundColor = UIColor(red: 0.19, green: 0.2, blue: 0.21, alpha: 1.0)
        outerRingView.layer.shadowColor = UIColor.black.withAlphaComponent(0.18).cgColor
        outerRingView.layer.shadowOpacity = 1
        outerRingView.layer.shadowRadius = 18
        outerRingView.layer.shadowOffset = CGSize(width: 0, height: 10)

       
        middleRingView.backgroundColor = .clear
        middleRingView.layer.borderWidth = 4
        middleRingView.layer.borderColor = UIColor(red: 0.53, green: 0.47, blue: 0.08, alpha: 1.0).cgColor

        
        innerCircleView.backgroundColor = UIColor(red: 1.0, green: 0.84, blue: 0.17, alpha: 1.0)

        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 34, weight: .black)
        checkImageView.image = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
        checkImageView.tintColor = UIColor(red: 0.17, green: 0.18, blue: 0.21, alpha: 1.0)
        checkImageView.contentMode = .scaleAspectFit
    }

    func buildHierarchy() {
        addSubview(glowView)
        addSubview(outerRingView)

        outerRingView.addSubview(middleRingView)
        outerRingView.addSubview(innerCircleView)

        innerCircleView.addSubview(checkImageView)
    }

    func setupLayout() {
        [glowView, outerRingView, middleRingView, innerCircleView, checkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([

           
            glowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            glowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            glowView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.22),
            glowView.heightAnchor.constraint(equalTo: glowView.widthAnchor),

         
            outerRingView.topAnchor.constraint(equalTo: topAnchor),
            outerRingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerRingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerRingView.bottomAnchor.constraint(equalTo: bottomAnchor),

        
            middleRingView.centerXAnchor.constraint(equalTo: outerRingView.centerXAnchor),
            middleRingView.centerYAnchor.constraint(equalTo: outerRingView.centerYAnchor),
            middleRingView.widthAnchor.constraint(equalTo: outerRingView.widthAnchor, multiplier: 0.7),
            middleRingView.heightAnchor.constraint(equalTo: middleRingView.widthAnchor),

          
            innerCircleView.centerXAnchor.constraint(equalTo: outerRingView.centerXAnchor),
            innerCircleView.centerYAnchor.constraint(equalTo: outerRingView.centerYAnchor),
            innerCircleView.widthAnchor.constraint(equalTo: outerRingView.widthAnchor, multiplier: 0.36),
            innerCircleView.heightAnchor.constraint(equalTo: innerCircleView.widthAnchor),

         
            checkImageView.centerXAnchor.constraint(equalTo: innerCircleView.centerXAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: innerCircleView.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 36),
            checkImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
