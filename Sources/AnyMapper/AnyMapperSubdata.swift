//
//  AnyMapperSubdata.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 20.04.2021.
//

import Foundation

public protocol AnyMapperSubdata {
    func set(key: String, value: Any?)
    func value<T>(key: String,
                  options: AnyMapperOptions,
                  type: T.Type) throws -> T

    func value<T>(key: String,
                  options: AnyMapperOptions,
                  type: T?.Type) throws -> T?
}

public extension AnyMapperSubdata {

    func value<T>(key: String,
                  options: AnyMapperOptions = .default,
                  type: T.Type = T.self) throws -> T {

        try self.value(key: key, options: options, type: type)
    }

    func value<T>(key: String,
                  options: AnyMapperOptions = .default,
                  type: T?.Type = T?.self) throws -> T? {

        try self.value(key: key, options: options, type: type)
    }
}

public class MapperSubdata: AnyMapperSubdata {

    private(set) var data: [String: Any?] = [:]

    public init() {}

    public init(key: String, value: Any?) {
        data[key] = value
    }

    public func set(key: String, value: Any?) {
        data[key] = value
    }

    public func value<T>(key: String, options: AnyMapperOptions, type: T.Type) throws -> T {
        try Mapper(source: data).value(key: key)
    }

    public func value<T>(key: String, options: AnyMapperOptions, type: T?.Type) throws -> T? {
        try Mapper(source: data).value(key: key)
    }
}
