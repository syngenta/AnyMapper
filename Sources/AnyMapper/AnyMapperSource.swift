//
//  AnyMapperSource.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

public protocol AnyMapperSource {
    func mapperSourceValue(for key: String) -> Any?
}
