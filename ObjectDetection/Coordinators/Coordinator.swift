//
//  Coordinator.swift
//  AvengersApp
//
//  Created by Ricardo González Pacheco on 25/04/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation

class Coordinator {
    
    fileprivate var childCoordinators = [Coordinator]()
    func start() {
        preconditionFailure("This function must be overriden by a subclass")
    }
    
    func finish() {
        preconditionFailure("This function must be overriden by a subclass")
    }
    
    func presentModule() {
        preconditionFailure("This function must be overriden by a subclass")
    }
    
    func addChildCoordinator(coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(coordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(of: coordinator) else {
            print("Not possible to delete this child coordinator: \(coordinator)")
            return
        }
        childCoordinators.remove(at: index)
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter{ $0 is T == false}
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}
