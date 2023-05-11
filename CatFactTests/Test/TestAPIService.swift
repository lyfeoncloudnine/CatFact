//
//  TestAPIService.swift
//  CatFactTests
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import XCTest

@testable import CatFact

final class TestAPIService: APIServiceType {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, Error> {
        if target.sampleData.isEmpty == false, let result = try? JSONDecoder().decode(T.self, from: target.sampleData) {
            return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
            
        } else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
    }
}
