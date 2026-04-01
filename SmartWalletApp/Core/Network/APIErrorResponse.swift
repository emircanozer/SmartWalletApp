import Foundation

/* Bu modeli decode edip kullanıcıya backendin kendi mesajını gösterebiliyoruz
 faydalı bir kullanım time mesajı için kullanmışık 
 Yani sadece status code’a bakmıyoruz.
 Body’de anlamlı mesaj varsa onu alıyoruz*/

struct APIErrorResponse: Decodable {
    let message: String?
    let detail: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case detail = "Detail"
    }
}
