//
//  ObjectDetectionViewController.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 13/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class ObjectDetectionViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let group = DispatchGroup()
    
    let viewModel: ObjectDetectionViewModel
    init(viewModel: ObjectDetectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        imageView.image = viewModel.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.viewDidAppear()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ObjectDetectionViewController: ObjectDetectionViewDelegate {
    func objectsDetected(_ itemViewModel: ItemViewModel) {
        guard !itemViewModel.objectsFrames.isEmpty else { return }
        for position in 0...itemViewModel.objectsFrames.count - 1 {
            let boundingBox = BoundingBox()
            boundingBox.addToLayer(view.layer)
            boundingBox.show(frame: itemViewModel.objectsFrames[position],
                             label: itemViewModel.objectsNames[position],
                             color: .orange)
        }
    }
}
