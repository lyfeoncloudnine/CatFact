//
//  Reactor.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import Foundation
import ObjectiveC.runtime

protocol Reactor: AnyObject {
    associatedtype Action
    associatedtype Mutation
    associatedtype State
    
    var action: PassthroughSubject<Action, Never> { get }
    var mutation: PassthroughSubject<Mutation, Never> { get }
    var state: CurrentValueSubject<State, Never> { get }
    var initialState: State { get }
    var currentState: State { get }
    
    func setUp(cancelBag: inout Set<AnyCancellable>) -> Void
    func mutate(action: Action) -> AnyPublisher<Mutation, Never>
    func reduce(state: State, mutation: Mutation) -> State
}

fileprivate enum ReactorKey {
    static var _actionKey = "actionKey"
    static var _mutationKey = "mutationKey"
    static var _stateKey = "stateKey"
}

extension Reactor {
    var currentState: State {
        state.value
    }
    
    private(set) var action: PassthroughSubject<Action, Never> {
        get {
            if let subject = withUnsafePointer(to: &ReactorKey._actionKey, { objc_getAssociatedObject(self, $0) as? PassthroughSubject<Action, Never> }) {
                return subject
            } else {
                let subject = PassthroughSubject<Action, Never>()
                withUnsafePointer(to: &ReactorKey._actionKey) { objc_setAssociatedObject(self, $0, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
                return subject
            }
        }
        set {
            withUnsafePointer(to: &ReactorKey._actionKey) { objc_setAssociatedObject(self, $0, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        }
    }
    
    private(set) var mutation: PassthroughSubject<Mutation, Never> {
        get {
            if let subject = withUnsafePointer(to: &ReactorKey._mutationKey, { objc_getAssociatedObject(self, $0) as? PassthroughSubject<Mutation, Never> }) {
                return subject
            } else {
                let subject = PassthroughSubject<Mutation, Never>()
                withUnsafePointer(to: &ReactorKey._mutationKey) { objc_setAssociatedObject(self, $0, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
                return subject
            }
        }
        set {
            withUnsafePointer(to: &ReactorKey._mutationKey) { objc_setAssociatedObject(self, $0, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        }
    }
    
    private(set) var state: CurrentValueSubject<State, Never> {
        get {
            if let subject = withUnsafePointer(to: &ReactorKey._stateKey, { objc_getAssociatedObject(self, $0) as? CurrentValueSubject<State, Never> }) {
                return subject
            } else {
                let subject = CurrentValueSubject<State, Never>(initialState)
                withUnsafePointer(to: &ReactorKey._stateKey) { objc_setAssociatedObject(self, $0, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
                return subject
            }
        }
        set {
            withUnsafePointer(to: &ReactorKey._stateKey) { objc_setAssociatedObject(self, $0, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        }
    }
    
    func setUp(cancelBag: inout Set<AnyCancellable>) {
        action
            .flatMap { [weak self] action -> AnyPublisher<Mutation, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return mutate(action: action)
            }
            .subscribe(mutation)
            .store(in: &cancelBag)
        
        mutation
            .scan(initialState) { [weak self] state, mutation -> State in
                guard let self else { return state }
                return reduce(state: state, mutation: mutation)
            }
            .receive(on: DispatchQueue.main)
            .subscribe(state)
            .store(in: &cancelBag)
    }
}

