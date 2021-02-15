//
//  NSDictionarySource.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

extension NSDictionary: AnyMapperSource {
    public func mapperSourceValue(for key: String) -> Any? { value(forKey: key) }
}
