//
//  ImageRatioResize.swift
//  PADO
//
//  Created by 황성진 on 2/12/24.
//

import SwiftUI

class ImageRatioResize {
    
    static let shared = ImageRatioResize()
    
    private init() { }
    
    // 추후 삭제 예정
    
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
    
    func resizeImage(_ originalImage: UIImage, toSize newSize: CGSize) async -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1 // 픽셀 기반 크기 조정을 위해 scale을 1로 설정합니다.
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        
        let resizedImage = renderer.image { context in
            originalImage.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return resizedImage
    }
}
