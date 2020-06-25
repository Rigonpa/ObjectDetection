//
//  ItemViewModel.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 12/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

protocol ViewDelegate {
    func loadCollectionFirstTime()
}

class ItemViewModel {
    
    var viewDelegate: ViewDelegate?
    
    let image: UIImage
    var objectsFrames: [CGRect] = []
    var objectsNames: [String] = []
    init(image: UIImage) {
        self.image = image
        
        self.viewDelegate?.loadCollectionFirstTime()
    }
}
