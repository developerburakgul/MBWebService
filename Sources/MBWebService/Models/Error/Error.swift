//
//  File 2.swift
//  MBWebService
//
//  Created by Burak Gül on 26.04.2025.
//

import Foundation

public protocol ErrorProtocol: LocalizedError {
    var description: String { get }
}

public enum CustomError: ErrorProtocol {
    case detail(String)

    public var description: String {
        switch self {
        case .detail(let message):
            return message
        }
    }
}

public enum HttpStatusError: ErrorProtocol {
    case informational(Int)
    case redirection(Int)
    case clientError(Int)
    case serverError(Int)
    case unknown(Int)

    public var description: String {
        switch self {
        case .informational(let code):
            return "Informational error with status code: \(code)"
        case .redirection(let code):
            return "Redirection error with status code: \(code)"
        case .clientError(let code):
            return "Client error with status code: \(code)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .unknown(let code):
            return "Unknown error with status code: \(code)"
        }
    }
}

public enum EncodeDecodeError: ErrorProtocol {
    case encodingFailed
    case decodingFailed

    public var description: String {
        switch self {
        case .encodingFailed:
            return "Encoding failed"
        case .decodingFailed:
            return "Decoding failed"
        }
    }
}
