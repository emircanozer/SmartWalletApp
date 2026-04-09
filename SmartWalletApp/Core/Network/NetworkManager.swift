import Foundation



final class APIClient {
    private let baseURL: URL 
    private let session: URLSession
    // auth isteyen request’te access token gerekiyorsa onu vermek için
    private let tokenProvider: () -> String?
    private let decoder: JSONDecoder

    init(
        baseURL: URL = NetworkConfiguration.baseURL,
        session: URLSession = .shared, //session = urlsession.shared
        // değişebilir
        tokenProvider: @escaping () -> String? = { nil }
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider
        self.decoder = JSONDecoder()
        // tarih için
        self.decoder.dateDecodingStrategy = .iso8601
    }

    /* hangi modeli istiyorsan, ben isteği atayım ve o modele çevirip geri vereyim
     generic decodable olan her model bu fonku kullanabilir response self sayesinde bu parametre sayesinde fonksiyon “hangi tipe decode edeceğini” biliyor.
     Yani login çağrısıysa dönüş LoginResponse -> response sayesinde Yani tek fonksiyon, farklı response tipleri döndürebiliyor. Bu generic’in en büyük faydası
     
     fonksiyonu çağırdığımız yerde decodable olan istediğimiz modeli tanımlıyabiliriz en güzel yanı her model için farklı fonk tanımlamamıza gerek yok generic yaptığımız için her farklı yerde fonku çağırdığımız yerde model tipini yazmamız yeterli örn loginresponse , registerresponse gibi

     */
    
    func send<Response: Decodable>(_ endpoint: Endpoint, as type: Response.Type = Response.self) async throws -> Response {
        let request = try makeRequest(from: endpoint) // request oluşturuyor
        logRequest(request) // console için önemsiz
        let (data, response) = try await session.data(for: request) // sonra urlsession istek atıyor
        let httpResponse = try validate(response: response)
        logResponse(data: data, response: httpResponse)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw parseError(from: data, statusCode: httpResponse.statusCode)
        }

        if Response.self == EmptyResponse.self {
            return EmptyResponse() as! Response
        }

        guard !data.isEmpty else {
            throw NetworkError.emptyResponse
        }

        do {
            // gelen data verisini generic olan response tipine çeviriyoruz (servis de bu fonk kullanılırken hangi response modeli döndürülmek istenirse o gelir)
            return try decoder.decode(Response.self, from: data)
        } catch {
            print("DEBUG Network: decode hatasi path=\(endpoint.path) responseType=\(Response.self) error=\(error.localizedDescription)")
            throw NetworkError.decodingFailed
        }
    }

    func send(_ endpoint: Endpoint) async throws {
        let request = try makeRequest(from: endpoint)
        logRequest(request)
        let (data, response) = try await session.data(for: request)
        let httpResponse = try validate(response: response)
        logResponse(data: data, response: httpResponse)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw parseError(from: data, statusCode: httpResponse.statusCode)
        }
    }
}

 extension APIClient {
    // endpointten url request oluşturuyor
    func makeRequest(from endpoint: Endpoint) throws -> URLRequest {
        let url = baseURL.appending(path: endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // token gerekiyorsa 
        if endpoint.requiresAuthorization, let token = tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    func validate(response: URLResponse) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        return httpResponse
    }

    func parseError(from data: Data, statusCode: Int) -> NetworkError {
        if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
            let message = apiError.detail ?? apiError.message
            print("DEBUG Network: server error status=\(statusCode) message=\(message ?? "-")")
            if statusCode == 401 {
                return .unauthorized(message: message)
            }
            return .server(statusCode: statusCode, message: message)
        }

        if statusCode == 401 {
            print("DEBUG Network: unauthorized status=401 body=\(bodyPreview(from: data))")
            return .unauthorized(message: nil)
        }

        print("DEBUG Network: server error status=\(statusCode) undecodedBody=\(bodyPreview(from: data))")
        return .server(statusCode: statusCode, message: nil)
    }

    func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "-"
        let path = request.url?.path ?? "-"
        let hasAuthorization = request.value(forHTTPHeaderField: "Authorization") != nil
        print("DEBUG Network: request method=\(method) path=\(path) auth=\(hasAuthorization)")

        guard let body = request.httpBody, !body.isEmpty else {
            print("DEBUG Network: request body=<empty>")
            return
        }

        print("DEBUG Network: request body=\(bodyPreview(from: body))")
    }

    func logResponse(data: Data, response: HTTPURLResponse) {
        let path = response.url?.path ?? "-"
        print("DEBUG Network: response status=\(response.statusCode) path=\(path) bytes=\(data.count)")
        print("DEBUG Network: response body=\(bodyPreview(from: data))")
    }

    func bodyPreview(from data: Data) -> String {
        guard !data.isEmpty else {
            return "<empty>"
        }

        let body = String(data: data, encoding: .utf8) ?? "<non-utf8>"
        if body.count > 500 {
            return String(body.prefix(500)) + "..."
        }

        return body
    }
}
