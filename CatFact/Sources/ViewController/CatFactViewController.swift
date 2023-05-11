//
//  CatFactViewController.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import Combine
import UIKit

final class CatFactViewController: UIViewController, ReactorView {
    let mainView = CatFactView()
    
    var cancelBag = Set<AnyCancellable>()
    
    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: CatFactViewReactor) {
        // Action
        mainView.refreshButtonAction = {
            reactor.action.send(.refresh)
        }
        
        // State
        reactor.state.compactMap { $0.fact }
            .removeDuplicates()
            .sink { [weak self] in
                self?.mainView.factLabel.text = $0
            }
            .store(in: &cancelBag)
        
        reactor.state.map { $0.isLoading }
            .removeDuplicates()
            .sink { [weak self] in
                guard let self else { return }
                $0 ? mainView.loadingIndicator.startAnimating() : mainView.loadingIndicator.stopAnimating()
                mainView.refreshButton.isEnabled = !$0
            }
            .store(in: &cancelBag)
    }
}
