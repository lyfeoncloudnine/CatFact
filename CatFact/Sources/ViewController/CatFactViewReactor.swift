//
//  CatFactViewReactor.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import Foundation

final class CatFactViewReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setFact(String)
        case setLoading(Bool)
    }
    
    struct State {
        var fact: String?
        var isLoading = false
    }
    
    let initialState = State()
    
    private var apiService: APIServiceType
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        switch action {
        case .refresh:
            let loadingOn: AnyPublisher<Mutation, Never> = Just(Mutation.setLoading(true)).eraseToAnyPublisher()
            let loadingOff: AnyPublisher<Mutation, Never> = Just(Mutation.setLoading(false)).eraseToAnyPublisher()
            
            let request = apiService.request(CatRequest.fact)
                .map { (catFact: CatFact) -> Mutation in
                    return .setFact(catFact.fact)
                }
                .catch { _ in
                    Just(Mutation.setFact("Refresh Fail :("))
                }
                .eraseToAnyPublisher()
            
            return loadingOn
                .append(request)
                .append(loadingOff)
                .eraseToAnyPublisher()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setFact(let fact):
            newState.fact = fact
            
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
}
