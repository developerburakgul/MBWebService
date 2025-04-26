// The Swift Programming Language
// https://docs.swift.org/swift-book

//  Created by Burak Gül && Mert Özseven on 26.04.2025.

import Foundation


public protocol MBWebServiceProtocol: Sendable {
    func fethcData<E: Encodable, D: Decodable>(
        urlString: String,
        queryItems: [URLQueryItem]?,
        header: HttpHeader?,
        method: HttpMethods,
        body: BodyData<E>?,
        checkStatusCode: Bool
    ) async throws -> D
}

public final class MBWebService {
    static let shared: MBWebServiceProtocol = MBWebService()
    
    private static func generateURL(urlString: String,queryItems: [URLQueryItem]?) -> URL?{
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    private static func generateRequest(
        url: URL,
        header: HttpHeader?,
        method: HttpMethods,
        body: Data?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header?.headers
        request.httpBody = body
        return request
    }
    
    
    private static func downloadData(
        session: URLSession,
        request: URLRequest,
        checkStatusCode: Bool
    ) async throws -> Data {
        do {
            let (data,response) =  try await session.data(for: request)
            if checkStatusCode {
                try checkStatusCodeFor(response)
            }
            return data
        } catch {
            throw error
        }
        
    }
    
    private func decode<T: Decodable>(_ type: T.Type,_ data: Data) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
    
    private func encode<T: Encodable>(_ value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
    
    private static func checkStatusCodeFor(_ response: URLResponse) throws{
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpStatusError.unknown(-1)
        }
        let code = httpResponse.statusCode
        switch code {
        case 100..<200:
            throw HttpStatusError.informational(code)
        case 200..<300:
            return
        case 300..<400:
            throw HttpStatusError.redirection(code)
        case 400..<500:
            throw HttpStatusError.serverError(code)
        default:
            throw HttpStatusError.unknown(code)
        }
        
    }
    
}

extension MBWebService: MBWebServiceProtocol {
    public func fethcData<E: Encodable, D: Decodable>(
        urlString: String,
        queryItems: [URLQueryItem]?,
        header: HttpHeader?,
        method: HttpMethods,
        body: BodyData<E>?,
        checkStatusCode: Bool
    ) async throws -> D {
        do {
            guard let url = Self.generateURL(urlString: urlString, queryItems: queryItems)
            else {throw CustomError.detail("URL is invalid")}
            let encodedBody = try encode(body?.data)
            let request = Self.generateRequest(
                url: url,
                header: header,
                method: method,
                body: encodedBody
            )
            let session = URLSession(configuration: .default)
            let data = try await Self.downloadData(
                session: session,
                request: request,
                checkStatusCode: checkStatusCode
            )
            let decodedData = try decode(D.self, data)
            return decodedData
        } catch  {
            throw error
        }
    }
    
}
