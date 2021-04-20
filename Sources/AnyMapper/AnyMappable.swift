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

public protocol AnyMappableSubdata: AnyMappable {
    init(mapper: AnyMapper, subdata: AnyMapperSubdata) throws
}

public extension AnyMappable {

    init(source: AnyMapperSource) throws {
        try self.init(mapper: Mapper(source: source))
    }
}

public extension AnyMappable where Self: AnyMappableSubdata {

    init(mapper: AnyMapper) throws {
        try self.init(mapper: mapper, subdata: MapperSubdata())
    }

    init(source: AnyMapperSource, subdata: AnyMapperSubdata) throws {
        try self.init(mapper: Mapper(source: source), subdata: subdata)
    }
}
