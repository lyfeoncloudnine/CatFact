//
//  CatFactViewReactorTests.swift
//  CatFactTests
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import XCTest

@testable import CatFact

final class CatFactViewReactorTests: XCTestCase {
    var apiService: APIServiceType!
    var cancelBag: Set<AnyCancellable>!
    var reactor: CatFactViewReactor!
    
    override func setUp() {
        super.setUp()
        
        apiService = TestAPIService()
        cancelBag = .init()
        reactor = CatFactViewReactor(apiService: apiService)
        reactor.setUp(cancelBag: &cancelBag)
    }
    
    override func tearDown() {
        reactor = nil
        cancelBag = nil
        apiService = nil
        
        super.tearDown()
    }
    
    func testRefresh() {
        let expectation = XCTestExpectation()
        
        reactor.action.send(.refresh)
        
        reactor.state.compactMap { $0.fact }
            .removeDuplicates()
            .sink {
                XCTAssertEqual($0, "Cats are now Britain's favourite pet: there are 7.7 million cats as opposed to 6.6 million dogs.")
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 10)
    }
}
