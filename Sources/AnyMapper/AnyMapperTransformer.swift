//
//  AnyMapperTransformer.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

public enum AnyMapperTransformer<T> {
    case none
    case transform((Any) throws -> T)
    case replace(() throws -> T)
    case stringInt
    case stringDate(formatter: DateFormatter)
    @available(iOS 10.0, *) @available(OSX 10.12, *) @available(tvOS 10.0, *) @available(watchOS 3.0, *)
    case stringISO8601Date(formatter: ISO8601DateFormatter)
}
