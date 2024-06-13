//
//  Mapper.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

struct Mapper: AnyMapper {

    let source: AnyMapperSource

    func value<T>(key: String,
                  transformer: AnyMapperTransformer<T?>,
                  options: AnyMapperOptions,
                  type: T?.Type) throws -> T? {

        guard let value = self.source.mapperSourceValue(for: key) else {
            if case let .replace(callBack) = transformer {
                return try callBack()
            } else if options.contains(.returnNilIfNoKey) {
                return nil
            }
            throw AnyMapperError.noKey(key: key, mapper: self)
        }
        do {
            return try decode(value: value, key: key, transformer: transformer)
        } catch {
            guard options.contains(.returnNilIfCantMap) else { throw error }
            return nil
        }
    }

    func value<T>(key: String,
                  transformer: AnyMapperTransformer<T>,
                  options: AnyMapperOptions,
                  type: T.Type) throws -> T {

        guard let value = source.mapperSourceValue(for: key) else {
            throw AnyMapperError.noKey(key: key, mapper: self)
        }
        return try decode(value: value, key: key, transformer: transformer)
    }

    func value<T>(keyPath: String,
                  transformer: AnyMapperTransformer<T?>,
                  options: AnyMapperOptions,
                  type: T?.Type) throws -> T? {

        guard keyPath.contains(".") else {
            return try value(
                key: keyPath,
                transformer: transformer,
                options: options,
                type: type
            )
        }

        let keys = keyPath.split(separator: ".")
        let value = try keys.reduce(source as Any?) { source, key in
            let key = String(key)
            guard let source = source as? AnyMapperSource else {
                guard options.contains(.returnNilIfCantMap) else {
                    throw AnyMapperError.incorrectType(key: keyPath, mapper: self, type: "AnyMapperSource")
                }
                return nil
            }
            return source.mapperSourceValue(for: key)
        }

        guard let value = value else {
            if case let .replace(callBack) = transformer {
                return try callBack()
            } else if options.contains(.returnNilIfNoKey) {
                return nil
            }
            throw AnyMapperError.noKey(key: keyPath, mapper: self)
        }
        do {
            return try decode(value: value, key: keyPath, transformer: transformer)
        } catch {
            guard options.contains(.returnNilIfCantMap) else { throw error }
            return nil
        }
    }

    func value<T>(keyPath: String,
                  transformer: AnyMapperTransformer<T>,
                  options: AnyMapperOptions,
                  type: T.Type) throws -> T {

        guard keyPath.contains(".") else {
            return try value(
                key: keyPath,
                transformer: transformer,
                options: options,
                type: type
            )
        }

        let keys = keyPath.split(separator: ".")
        let value = try keys.reduce(source as Any) { source, key in
            let key = String(key)
            guard let source = source as? AnyMapperSource else {
                throw AnyMapperError.incorrectType(key: keyPath, mapper: self, type: "AnyMapperSource")
            }
            if let value = source.mapperSourceValue(for: key) {
                return value
            } else {
                throw AnyMapperError.noKey(key: keyPath, mapper: self)
            }
        }

        return try decode(value: value, key: keyPath, transformer: transformer)
    }
}

private extension Mapper {

    func decode<T>(value: Any, key: String, transformer: AnyMapperTransformer<T>) throws -> T {
        let incorrect = { AnyMapperError.incorrect(message: $0, value: value, key: key, mapper: self) }
        switch transformer {
        case .none: break
        case .transform(let callBack):
            switch value {
            case Optional<Any>.none: // check for double optional
                throw AnyMapperError.optionalValue(value: value, key: key, mapper: self)
            default:
                return try callBack(value)
            }
        case .replace(let callBack):
            return try callBack()
        case .stringInt:
            guard let value = value as? String else {
                throw incorrect("Can't use 'stringInt'. Not 'String' value")
            }
            guard let result = Int(value) as? T else {
                throw incorrect("Can't use 'stringInt'. Not 'Int' return type")
            }
            return result
        case .stringDate(let formatter):
            guard let value = value as? String else {
                throw incorrect("Can't use 'stringDate'. Not 'String' value")
            }
            guard let date = formatter.date(from: value) else {
                throw incorrect("Can't use 'stringDate'. Can't formatting for 'Date'")
            }
            guard let result = date as? T else {
                throw incorrect("Can't use 'stringDate'. Not 'Date' return type")
            }
            return result
        case .stringISO8601Date(formatter: let formatter):
            guard let value = value as? String else {
                throw incorrect("Can't use 'stringISO8601Date'. Not 'String' value")
            }
            guard let date = formatter.date(from: value) else {
                throw incorrect("Can't use 'stringISO8601Date'. Can't formatting for 'Date'")
            }
            guard let result = date as? T else {
                throw incorrect("Can't use 'stringISO8601Date'. Not 'Date' return type")
            }
            return result
        }
        guard let result = value as? T else {
            throw AnyMapperError.incorrectType(key: key, mapper: self, type: String(describing: T.self))
        }
        return result
    }
}
