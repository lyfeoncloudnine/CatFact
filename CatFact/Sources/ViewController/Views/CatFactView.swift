//
//  CatFactView.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import UIKit

final class CatFactView: UIView {
    let factLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let configuration = UIButton.Configuration.borderedProminent()
        let button = UIButton(configuration: configuration)
        button.setTitle("Refresh", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(refreshButtonTap(_:)), for: .touchUpInside)
        return button
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var refreshButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = .systemBackground
        
        addSubview(factLabel)
        addSubview(refreshButton)
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            factLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            factLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            factLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            refreshButton.leadingAnchor.constraint(equalTo: factLabel.leadingAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            refreshButton.trailingAnchor.constraint(equalTo: factLabel.trailingAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 56),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func refreshButtonTap(_ sender: UIButton) {
        refreshButtonAction?()
    }
}
