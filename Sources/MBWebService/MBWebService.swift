// The Swift Programming Language
// https://docs.swift.org/swift-book

//  Created by Burak Gül && Mert Özseven on 26.04.2025.

import Foundation


public struct BodyData<T: Encodable> {
    public let data: T
}

public protocol MBWebServiceProtocol: Sendable {
    func fethcData<E: Encodable, D: Decodable>(
        urlString: String,
        queryItems: [URLQueryItem]?,
        header: HttpHeader?,
        method: HttpMethods,
        body: BodyData<E>?
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
    

    private static func dowloandData(session: URLSession, request: URLRequest) async throws -> Data {
        let (data,response) =  try! await session.data(for: request)
        return data
    }
    
    private func decode<T: Decodable>(_ type: T.Type,_ data: Data) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
    
    private func encode<T: Encodable>(_ value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
    
}

extension MBWebService: MBWebServiceProtocol {
    public func fethcData<E: Encodable, D: Decodable>(
        urlString: String,
        queryItems: [URLQueryItem]?,
        header: HttpHeader?,
        method: HttpMethods,
        body: BodyData<E>?
    ) async throws -> D {
        guard let url = Self.generateURL(urlString: urlString, queryItems: queryItems)
        else {throw MBError.one}
        let encodedBody: Data = try encode(body?.data)
        let request = Self.generateRequest(
            url: url,
            header: header,
            method: method,
            body: encodedBody
        )
        let session = URLSession(configuration: .default)
        
        
        let data = try await Self.dowloandData(session: session, request: request)
        let decodedData = try! decode(D.self, data)
        return decodedData
    }
    
}




