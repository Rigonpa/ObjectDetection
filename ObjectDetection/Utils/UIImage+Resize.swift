//
//  UIImage+Resize.swift
//  CoreML Basics
//
//  Created by Óscar Izquierdo Roldán on 14/11/2019.
//  Copyright © 2019 Óscar Izquierdo Roldán. All rights reserved.
//

import UIKit

//MARK: - IMAGE EXTENSION
extension UIImage {
    func getGoodSize(_ maxImageSize:CGFloat) -> CGSize? {
        
        let size = self.size
        if size.width > size.height && size.width > maxImageSize {
            let newHeight = maxImageSize * size.height / size.width
            return CGSize(width: maxImageSize, height: newHeight)
        }else if size.height > size.width && size.height > maxImageSize {
            let newWidth = maxImageSize * size.width / size.height
            return CGSize(width: newWidth, height: maxImageSize)
        }else if size.height == self.size.width && size.height > maxImageSize {
            return CGSize(width: maxImageSize, height: maxImageSize)
        }else{
            return nil
        }
    }
    
    func resizeWithProportions(_ maxSize:CGFloat = 500) -> UIImage {
        if let newSize = getGoodSize(maxSize) {
            return UIGraphicsImageRenderer(size: newSize).image(actions: { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            })
        }
        return self
    }
    
    func resize(_ maxSize: CGFloat = 500) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: maxSize, height: maxSize)).image(actions: { _ in
            self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxSize, height: maxSize)))
        })
    }
    
    var pixelBuffer: CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
