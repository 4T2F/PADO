//
//  Color+.swift
//  PADO
//
//  Created by 강치우 on 2/17/24.
//

import UIKit

extension UIColor {
    func isLight(threshold: Float = 0.6) -> Bool {
        let originalCGColor = self.cgColor
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        
        guard let components = RGBCGColor?.components,
              components.count >= 3 else {
            return true
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}

extension UIImage {
    func averageColor() -> UIColor? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        
        guard let context = UIGraphicsGetCurrentContext(),
              let pixelBuffer = context.data else { return nil }
        
        let data = pixelBuffer.bindMemory(to: UInt8.self, capacity: 4)
        let red = CGFloat(data[0]) / 255
        let green = CGFloat(data[1]) / 255
        let blue = CGFloat(data[2]) / 255
        let alpha = CGFloat(data[3]) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
