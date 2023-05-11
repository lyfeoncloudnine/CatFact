//
//  CatRequest.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Foundation

enum CatRequest {
    case fact
}

extension CatRequest: TargetType {
    var baseURL: String {
        "https://catfact.ninja/"
    }
    
    var endpoint: String {
        "fact"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var sampleData: Data {
        guard let path = Bundle.main.path(forResource: "fact", ofType: "json") else { return Data() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return Data() }
        return data
    }
}
