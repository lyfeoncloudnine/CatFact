//
//  ReactorView.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import Foundation
import ObjectiveC.runtime

protocol ReactorView: AnyObject {
    associatedtype SomeReactor: Reactor
    
    var reactor: SomeReactor? { get set }
    var cancelBag: Set<AnyCancellable> { get set }
    
    func bind(reactor: SomeReactor) -> Void
}

fileprivate enum ReactorViewKey {
    static var _reactorKey = "reactorKey"
}

extension ReactorView {
    var reactor: SomeReactor? {
        get {
            return withUnsafePointer(to: ReactorViewKey._reactorKey) { objc_getAssociatedObject(self, $0) as? SomeReactor }
        }
        set {
            withUnsafePointer(to: ReactorViewKey._reactorKey) { objc_setAssociatedObject(self, $0, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
            if let reactor = newValue {
                reactor.setUp(cancelBag: &cancelBag)
                bind(reactor: reactor)
            }
        }
    }
}
