//
//  AnyMapperOptions.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

public struct AnyMapperOptions: OptionSet {

    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let returnNilIfNoKey = AnyMapperOptions(rawValue: 1 << 0)
    public static let returnNilIfCantMap = AnyMapperOptions(rawValue: 1 << 1)

    public static let none: Self = []
    public static let `default`: Self = [.returnNilIfNoKey, .returnNilIfCantMap]
}
