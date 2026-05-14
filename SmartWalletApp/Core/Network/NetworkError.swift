import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized(message: String?)
    case server(statusCode: Int, message: String?)
    case decodingFailed
    case encodingFailed
    case emptyResponse // backend 200 döndü ama body boş geldi emptyResponse
    case underlying(Error)

    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz istek adresi."
        case .invalidResponse:
            return "Sunucudan geçerli bir yanıt alınamadı."
        case .unauthorized(let message):
            return message ?? "Oturum doğrulanamadı." //**backend hata mesajı döndürürse onunki gözüküyor yoksa bu gözüküyor
        case .server(_, let message):
            return message ?? "Sunucu tarafında bir hata oluştu."
        case .decodingFailed:
            return "Sunucu verisi çözümlenemedi."
        case .encodingFailed:
            return "İstek verisi hazırlanamadı."
        case .emptyResponse:
            return "Sunucudan boş yanıt alındı."
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
