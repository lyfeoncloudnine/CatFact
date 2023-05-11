//
//  TargetType.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol TargetType {
    var baseURL: String { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var sampleData: Data { get }
}

extension TargetType {
    var sampleData: Data { Data() }
}
