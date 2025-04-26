//
//  File 2.swift
//  MBWebService
//
//  Created by Burak Gül on 26.04.2025.
//

import Foundation

public enum CustomError: Error {
    case detail(String)
}


public enum HttpStatusError: Error {
    case informational(Int)
    case redirection(Int)
    case clientError(Int)
    case serverError(Int)
    case unknown(Int)
}

