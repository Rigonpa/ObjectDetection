//
//  HomeViewModel.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 09/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation

protocol HomeCoordinatorDelegate {
    func catalogSelected()
}

protocol HomeViewDelegate {
    
}

class HomeViewModel {
    
    var coordinatorDelegate: HomeCoordinatorDelegate?
    var viewDelegate: HomeViewDelegate?
    
    func catalogSelected() {
        coordinatorDelegate?.catalogSelected()
    }
    
    func customSelected() {
        coordinatorDelegate?.catalogSelected()
    }
}
