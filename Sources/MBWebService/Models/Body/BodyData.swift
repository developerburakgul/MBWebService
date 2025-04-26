//
//  BodyData.swift
//  MBWebService
//
//  Created by Burak Gül on 26.04.2025.
//


public struct BodyData<T: Encodable> {
    public let data: T
}