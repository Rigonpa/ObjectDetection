//
//  Item.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 12/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class Item: UICollectionViewCell {
    static var itemIdentifier: String = String(describing: Item.self)
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 70
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var viewModel: ItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            imageView.image = viewModel.image
            viewModel.viewDelegate = self
            setupUI()
        }
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
}

extension Item: ViewDelegate {
    func loadCollectionFirstTime() {
        guard let viewModel = viewModel else { return }
        imageView.image = viewModel.image
        
        setNeedsLayout()
    }
}
