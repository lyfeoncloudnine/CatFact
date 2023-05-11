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
    static var _reatorKey = "reactorKey"
}

extension ReactorView {
    var reactor: SomeReactor? {
        get {
            return (objc_getAssociatedObject(self, &ReactorViewKey._reatorKey) as? SomeReactor)
        }
        set {
            objc_setAssociatedObject(self, &ReactorViewKey._reatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let reactor = newValue {
                reactor.setUp(cancelBag: &cancelBag)
                bind(reactor: reactor)
            }
        }
    }
}
