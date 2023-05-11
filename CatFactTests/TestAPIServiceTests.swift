//
//  TestAPIServiceTests.swift
//  CatFactTests
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import XCTest

@testable import CatFact

final class TestAPIServiceTests: XCTestCase {
    var apiService: APIServiceType!
    var cancelBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        apiService = TestAPIService()
        cancelBag = .init()
    }
    
    override func tearDown() {
        cancelBag = nil
        apiService = nil
        
        super.tearDown()
    }
    
    func testDecode() {
        let expectation = XCTestExpectation()
        
        apiService.request(CatRequest.fact)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("fail with error: \(error)")
                    
                case .finished:
                    break
                }
            }, receiveValue: { (catFact: CatFact) in
                XCTAssertEqual(catFact.fact, "Cats are now Britain's favourite pet: there are 7.7 million cats as opposed to 6.6 million dogs.")
                expectation.fulfill()
            })
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 10)
    }
}
