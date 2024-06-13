//
//  AnyMapper.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

public protocol AnyMapper {
    var source: AnyMapperSource { get }
    func value<T>(key: String,
                  transformer: AnyMapperTransformer<T>,
                  options: AnyMapperOptions,
                  type: T.Type) throws -> T

    func value<T>(key: String,
                  transformer: AnyMapperTransformer<T?>,
                  options: AnyMapperOptions,
                  type: T?.Type) throws -> T?

    func value<T>(keyPath: String,
                  transformer: AnyMapperTransformer<T>,
                  options: AnyMapperOptions,
                  type: T.Type) throws -> T

    func value<T>(keyPath: String,
                  transformer: AnyMapperTransformer<T?>,
                  options: AnyMapperOptions,
                  type: T?.Type) throws -> T?
}

// extension for default parameters
public extension AnyMapper {

    func value<T>(key: String,
                  transformer: AnyMapperTransformer<T> = .none,
                  options: AnyMapperOptions = .default,
                  type: T.Type = T.self) throws -> T {

        try self.value(key: key, transformer: transformer, options: options, type: type)
    }

    func value<T>(key: String,
                  transformer: AnyMapperTransformer<T?> = .none,
                  options: AnyMapperOptions = .default,
                  type: T?.Type = T?.self) throws -> T? {

        try self.value(key: key, transformer: transformer, options: options, type: type)
    }

    func value<T>(keyPath: String,
                  transformer: AnyMapperTransformer<T> = .none,
                  options: AnyMapperOptions = .default,
                  type: T.Type = T.self) throws -> T {

        try self.value(keyPath: keyPath, transformer: transformer, options: options, type: type)
    }

    func value<T>(keyPath: String,
                  transformer: AnyMapperTransformer<T?> = .none,
                  options: AnyMapperOptions = .default,
                  type: T?.Type = T?.self) throws -> T? {

        try self.value(keyPath: keyPath, transformer: transformer, options: options, type: type)
    }
}
