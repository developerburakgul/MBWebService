//
//  HttpHeader.swift
//  MBWebService
//
//  Created by Burak Gül on 26.04.2025.
//

import Foundation

public struct HttpHeader {
    var headers: [String: String]
    init(headers: [String : String]) {
        self.headers = headers
    }
}
