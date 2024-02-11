//
//  CropWhiteBackground.swift
//  PADO
//
//  Created by 황성진 on 2/11/24.
//

import SwiftUI

class CropWhiteBackground {
    func processImage(inputImage: UIImage) async throws -> UIImage {
        
        enum CroppingError: Error {
            case imageNotFound, failedToCrop
        }
        
        let croppingFrame: CGRect
        let scaleFactor: CGFloat
        let processedImageWidth: CGFloat
        let processedImageHeight: CGFloat
        let croppedImage: UIImage
        guard let cgImage: CGImage = inputImage.cgImage else {
            print("image not found")
            throw CroppingError.imageNotFound
        }
        
        //Declaration of cropping frame size
        scaleFactor = inputImage.scale
        processedImageWidth = (inputImage.size.width * scaleFactor)
        processedImageHeight = (inputImage.size.height * scaleFactor) - (125 * scaleFactor)
        
        //Declaration of frame for cropping
        croppingFrame = CGRect(x: 0, y: 0, width: processedImageWidth, height: processedImageHeight)
        
        //Cropping CGImage
        guard let processedCGImage: CGImage = cgImage.cropping(to: croppingFrame) else {
            print("image not found")
            throw CroppingError.failedToCrop
        }
        
        //Convert CGImage to UIImage
        croppedImage = UIImage(cgImage: processedCGImage, scale: scaleFactor, orientation: inputImage.imageOrientation)
        
        return croppedImage
    }
}
