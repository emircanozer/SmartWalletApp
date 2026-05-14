import UIKit

/* Kullanıcı şifre alanına tıklamışsa klavye açıldığında özellikle şifre alanını görünür yapmak gerekiyor Hangi alan aktif bilinmezse neyi yukarı kaydıracağını bilemez*/
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

    // custom sınıflarımız var authinput gibi onlarda textfielda oto scroll yaparsak tasarımsal olarak kötü durur Bu yüzden: aktif olan textfield’ı bul onun bağlı olduğu büyük input kartını bul scrolu ona göre yap generic farklı sınıflarda var diye 
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
