//
//  APIServiceType.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/14.
//

import Combine
import Foundation

protocol APIServiceType {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, Error>
}
