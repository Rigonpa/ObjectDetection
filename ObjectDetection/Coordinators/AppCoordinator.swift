//
//  AppCoordinator.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 09/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
//    let presenter = UINavigationController()
    
    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(presenter: navigationController)
        homeCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    override func finish() {}
}
