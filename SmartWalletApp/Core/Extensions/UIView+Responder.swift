import UIKit


extension UIView {
    var currentFirstResponder: UIView? {
        if isFirstResponder { return self }

        for subview in subviews {
            if let responder = subview.currentFirstResponder {
                return responder
            }
        }

        return nil
    }

    func nearestSuperview<T: UIView>(of type: T.Type) -> T? {
        var current = superview

        while let view = current {
            if let typed = view as? T {
                return typed
            }
            current = view.superview
        }

        return nil
    }
}
