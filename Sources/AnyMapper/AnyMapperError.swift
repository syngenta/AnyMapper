//
//  AnyMapperError.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

public enum AnyMapperError: Error {
    case incorrectType(key: String, mapper: AnyMapper, type: String)
    case noKey(key: String, mapper: AnyMapper)
    case optionalValue(value: Any, key: String, mapper: AnyMapper)
    case incorrect(message: String, value: Any, key: String, mapper: AnyMapper)
}
