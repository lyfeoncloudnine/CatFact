//
//  CatFactViewReactor.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import Foundation

final class CatFactViewReactor: Reactor {
    enum Action {}
    
    enum Mutation {}
    
    struct State {}
    
    let initialState = State()
    
    private var apiService: APIServiceType
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        state
    }
}
