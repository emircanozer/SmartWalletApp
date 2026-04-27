import Foundation

final class PrivacyViewModel {
    func makeViewData() -> PrivacyViewData {
        PrivacyViewData(
            brandText: "SmartWallet AI",
            titleText: "Aydınlatma Metni",
            subtitleText: "Kişisel verilerinizin hangi amaçlarla işlendiği, nasıl korunduğu ve haklarınız bu metinde açıklanmaktadır.",
            sections: [
                PrivacySectionViewData(
                    titleText: "1. VERİ SORUMLUSU",
                    bodyText: "SmartWallet AI olarak veri sorumlusu sıfatıyla verilerinizi işliyoruz. Kişisel verilerinizin güvenliği bizim için en yüksek önceliğe sahiptir ve tüm süreçler yasal mevzuata uygun olarak yürütülmektedir."
                ),
                PrivacySectionViewData(
                    titleText: "2. İŞLENEN KİŞİSEL VERİLER",
                    bodyText: "Kimlik, iletişim ve işlem güvenliği bilgileriniz yasal sınırlar dahilinde işlenmektedir. Bu veriler, finansal güvenliğinizi sağlamak ve size daha kişiselleştirilmiş bir cüzdan deneyimi sunmak amacıyla toplanmaktadır."
                ),
                PrivacySectionViewData(
                    titleText: "3. VERİLERİN İŞLENME AMAÇLARI",
                    bodyText: "Hizmet sunumu, güvenlik ve yasal yükümlülüklerin yerine getirilmesi. SmartWallet AI algoritmalarının finansal sağlığınızı analiz etmesi ve risk yönetimi süreçlerinin işletilmesi bu kapsamda yer almaktadır."
                ),
                PrivacySectionViewData(
                    titleText: "4. VERİLERİN AKTARILMASI",
                    bodyText: "Verileriniz yalnızca yasal zorunluluk hallerinde yetkili kurumlarla paylaşılır. Üçüncü taraf reklam ağları veya veri simsarlaryla herhangi bir veri paylaşımı politikamız bulunmamaktadır."
                ),
                PrivacySectionViewData(
                    titleText: "5. KULLANICI HAKLARI",
                    bodyText: "Verilerinize erişme, düzeltme ve silme talebinde bulunma hakkına sahipsiniz. 6698 sayılı Kanun’un 11. maddesi uyarınca dilediğiniz zaman işleme faaliyetlerimiz hakkında bilgi alabilirsiniz."
                ),
                PrivacySectionViewData(
                    titleText: "6. İLETİŞİM",
                    bodyText: "Sorularınız için kvkk@smartwallet.ai adresinden bize ulaşabilirsiniz. Talepleriniz KVKK ekibimiz tarafından en geç 7 gün içerisinde sonuçlandırılacaktır."
                )
            ]
        )
    }
}
