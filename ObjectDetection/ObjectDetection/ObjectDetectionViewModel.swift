//
//  ObjectDetectionViewModel.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 13/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

protocol ObjectDetectionViewDelegate {
    func objectsDetected(_ itemViewModel: ItemViewModel)
}

class ObjectDetectionViewModel {
    
    let coreMLPrediction = CoreMLPrediction()
    
    var viewDelegate: ObjectDetectionViewDelegate?
    
    let itemViewModel: ItemViewModel
    init(itemViewModel: ItemViewModel) {
        self.itemViewModel = itemViewModel
    }
    
    func viewDidLoad() -> UIImage {
        return itemViewModel.image
    }
    
    func viewDidAppear() {
        coreMLPrediction.predict(itemViewModel) {[weak self] processedItemViewModel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewDelegate?.objectsDetected(processedItemViewModel)
            }
        }
    }
}
