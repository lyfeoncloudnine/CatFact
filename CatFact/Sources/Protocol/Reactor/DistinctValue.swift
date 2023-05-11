//
//  DistinctValue.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Foundation

struct DistinctValue<T: Equatable>: Equatable {
    var value: T {
        didSet {
            count += 1
        }
    }
    
    private var count: UInt = 0
    
    init(_ value: T) {
        self.value = value
    }
    
    static func == (lhs: DistinctValue<T>, rhs: DistinctValue<T>) -> Bool {
        return lhs.value == rhs.value && lhs.count == rhs.count
    }
}
