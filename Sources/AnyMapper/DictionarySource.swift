//
//  DictionarySource.swift
//  AnyMapper
//
//  Created by Evegeny Kalashnikov on 12.02.2021.
//

import Foundation

extension Dictionary: AnyMapperSource where Key == String {
    public func mapperSourceValue(for key: String) -> Any? { self[key] }
}
