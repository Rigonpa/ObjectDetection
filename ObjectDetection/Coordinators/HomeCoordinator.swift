//
//  AppCoordinator.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 09/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    let presenter: UINavigationController
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    override func start() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.title = "Home"
        
        homeViewModel.coordinatorDelegate = self
        homeViewModel.viewDelegate = homeViewController
        
        presenter.pushViewController(homeViewController, animated: true)
        
    }
    
    override func finish() {}
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    func catalogSelected() {
        let collectionViewModel = CollectionViewModel()
        let collectionViewController = CollectionViewController(viewModel: collectionViewModel)
        collectionViewController.title = "Collection"
        
        collectionViewModel.coordinatorDelegate = self
        collectionViewModel.viewDelegate = collectionViewController
        
        presenter.pushViewController(collectionViewController, animated: true)
    }
}

extension HomeCoordinator: CollectionCoordinatorDelegate {
    func itemSelected(itemViewModel: ItemViewModel) {
        let objectDetectionViewModel = ObjectDetectionViewModel(itemViewModel: itemViewModel)
        let objectDetectionViewController = ObjectDetectionViewController(viewModel: objectDetectionViewModel)
        objectDetectionViewController.title = "Object detection"
        
        objectDetectionViewModel.viewDelegate = objectDetectionViewController
        
        presenter.pushViewController(objectDetectionViewController, animated: true)
    }
    
    func backButtonWasPressed() {
        presenter.popViewController(animated: true)
    }
}
