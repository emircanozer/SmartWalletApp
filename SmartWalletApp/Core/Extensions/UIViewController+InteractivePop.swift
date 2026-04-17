import UIKit
import ObjectiveC



extension UIViewController {
    // nav stack olan ekranlarda basitçe swipe yaparak pop oluyor
    func enableInteractivePopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    func disableInteractivePopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

private var loadingOverlayKey: UInt8 = 0
private var loadingIndicatorKey: UInt8 = 1

extension UIViewController {
    private var loadingOverlayView: UIView {
        if let overlay = objc_getAssociatedObject(self, &loadingOverlayKey) as? UIView {
            return overlay
        }

        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        overlay.isHidden = true

        // indicator
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = AppColor.primaryText
        overlay.addSubview(indicator)

        //ortala
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        // hafızaya kaydet
        objc_setAssociatedObject(self, &loadingOverlayKey, overlay, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &loadingIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return overlay
    }

    // indicator
    private var loadingOverlayIndicator: UIActivityIndicatorView? {
        objc_getAssociatedObject(self, &loadingIndicatorKey) as? UIActivityIndicatorView
    }
    
    // view üstüne yarı saydam bir overlay ekliyor
    //ortada UIActivityIndicatorView(style: .large) gösteriyor

    func setCenteredLoading(_ isLoading: Bool) {
        let overlay = loadingOverlayView

        if overlay.superview == nil {
            view.addSubview(overlay)
            NSLayoutConstraint.activate([
                overlay.topAnchor.constraint(equalTo: view.topAnchor),
                overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

        overlay.superview?.bringSubviewToFront(overlay)
        overlay.isHidden = !isLoading

        if isLoading {
            loadingOverlayIndicator?.startAnimating()
        } else {
            loadingOverlayIndicator?.stopAnimating()
        }
    }
}
