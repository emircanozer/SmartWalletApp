import Foundation

// auth akışında kullandığımız app içi yardımcı modeller
struct PendingRegistrationContext {
    let name: String
    let email: String
    let password: String
    let registration: RegisterResponse
}

/*
 Bu modelin amacı kayıt akışındaki bilgileri ekranlar arasında taşımak. kordinatör de var 
 name
 email
 password
 registration
 Çünkü register ekranından verification ekranına geçince hâlâ bazı bilgilere ihtiyacımız var
 verify-email için email
 verify başarılı olunca otomatik login için email + password
 IBAN success ekranı için register response içindeki iban
 Bunları ayrı ayrı taşısaydık kod dağılırdı. Bunun yerine tek paket yaptık:
 kayıt oldu ama doğrulaması henüz tamamlanmamış kullanıcı context’i
 Yani bu dosyanın işi:

 register sonrası auth akış state’ini taşımak
 */
