//
//  ImageRatioResize.swift
//  PADO
//
//  Created by 황성진 on 2/12/24.
//

import SwiftUI

func resizedImageRect(for originalImage: UIImage, targetSize: CGSize) -> CGRect {
    let widthRatio = targetSize.width / originalImage.size.width
    let heightRatio = targetSize.height / originalImage.size.height
    let ratio = min(widthRatio, heightRatio)
    
    let newSize = CGSize(width: originalImage.size.width * ratio, height: originalImage.size.height * ratio)
    let rect = CGRect(x: (targetSize.width - newSize.width) / 2.0,
                      y: (targetSize.height - newSize.height) / 2.0,
                      width: newSize.width,
                      height: newSize.height)
    return rect
}
