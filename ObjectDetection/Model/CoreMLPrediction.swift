//
//  MLCorePrediction.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 13/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Vision
import QuartzCore
import UIKit

class CoreMLPrediction {
    
    let model = YOLOv3()
    let maxImageSize: CGFloat = 416
    
    private var isAnalysing = false
    private var request: VNCoreMLRequest?
    
    func predict(_ itemViewModel: ItemViewModel, completion: ((ItemViewModel) -> Void)?) {
        
        guard let visionModel = try? VNCoreMLModel(for: model.model) else { return }
        
        request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            guard let self = self else { return }
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            
            let completedItemViewModel = self.setNameAndFrameOfDetectedObjects(results, itemViewModel)
            completion?(completedItemViewModel)
            self.isAnalysing = false
        }
        request?.imageCropAndScaleOption = .centerCrop
        
        guard !isAnalysing else { return }
        isAnalysing = true
        
//        UserDefaults.standard.bool(forKey: HomeViewController.switchOn) ? predictWithVision(itemViewModel.image) : predictWithCoreML(itemViewModel.image)
        predictWithVision(itemViewModel.image)
        isAnalysing = false
    }
    
    private func predictWithCoreML(_ image: UIImage) {
//        let resizedImage = image.resize(maxImageSize)
//        guard let pixelBuffer = resizedImage.pixelBuffer else { return }
//        guard let output = try? model.prediction(image: pixelBuffer, iouThreshold: 0.5, confidenceThreshold: 0.6) else { return }
//
//        print(output)
    }
    
    private func predictWithVision(_ image: UIImage) {
        guard let pixelBuffer = image.pixelBuffer else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        guard let request = self.request else { return }
        try? handler.perform([request])
    }
    
    private func setNameAndFrameOfDetectedObjects(_ results: [VNRecognizedObjectObservation],
                                                 _ itemViewModel: ItemViewModel) -> ItemViewModel {
        for observation in results {
//            Select only the label with the highest confidence:
            let topObservation = observation.labels[0]
            let width = UIScreen.main.bounds.width
            let height = width
            let offsetY = (UIScreen.main.bounds.height - height) / 2
            let scale = CGAffineTransform.identity.scaledBy(x: width, y: height)
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -height - offsetY)
            let rect = observation.boundingBox.applying(scale).applying(transform)
            
            itemViewModel.objectsFrames.append(rect)
            itemViewModel.objectsNames.append(topObservation.identifier)
        }
        return itemViewModel
    }
}
