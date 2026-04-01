import Foundation

/* her endpoint şu bilgileri sağlamalı dedik protokol ile tanımlayarak
 Yani bu protocol şu soruya cevap veriyor;
 Bir network isteğini oluşturmak için hangi minimum bilgilere ihtiyacım var?
 Mesela:
 path = /api/Auth/login
 method = .post
 body = encoded login request
 requiresAuthorization = false
 Bu sayede APIClient endpoint’i çalıştırabiliyor.*/

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var requiresAuthorization: Bool { get }
}

// belirtmezsen default değerler veriyor
extension Endpoint {
    var headers: [String: String] {
        [:] // hiç header yok demek 
    }

    var body: Data? {
        nil
    }

    var requiresAuthorization: Bool {
        false
    }
}

