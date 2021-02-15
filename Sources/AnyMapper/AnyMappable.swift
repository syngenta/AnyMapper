//
//  AnyMappable.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

public protocol AnyMappable {
    init(mapper: AnyMapper) throws
}

public extension AnyMappable {

    init(source: AnyMapperSource) throws {
        do {
            try self.init(mapper: Mapper(source: source))
        } catch let error {
            throw error
        }
    }
}
