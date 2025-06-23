//
//  HttpHeader.swift
//  MBWebService
//
//  Created by Burak Gül on 26.04.2025.
//

import Foundation

public struct HttpHeader {
    var headers: [String: String]
    public init(headers: [String : String]) {
        self.headers = headers
    }
}

extension HttpHeader {
   public static let defaultHttpHeader = HttpHeader(
        headers: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    )
}
