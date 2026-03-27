protocol Coordinator {
    // Bu dizi alt coordinator’ları tutar. sayfa kordinatörlerini bu arraye ekliyoruz
    var children: [Coordinator] { get set }
    func start()
}
/* Bu protokolü benimseyen herkes şu özelliklere ve fonksiyonlara sahip olmalı.
 AppCoordinator ana coordinator
 LoginCoordinator onun child’ı olabilir
 HomeCoordinator başka bir child olabilir
 Bu ne sağlar?
 Alt akışları takip etmeyi
 Memory yönetimini
 Gerekince child coordinator’ı kaldırmayı
 
 */

