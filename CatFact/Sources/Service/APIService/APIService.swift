//
//  APIService.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL"
            
        case .invalidResponse:
            return "유효하지 않은 응답"
        }
    }
}

final class APIService: APIServiceType {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, Error> {
        guard var components = URLComponents(string: target.baseURL + target.endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        components.queryItems = target.parameters?.compactMap { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.invalidResponse }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
