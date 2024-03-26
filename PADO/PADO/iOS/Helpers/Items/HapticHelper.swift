//
//  HapticHelper.swift
//  PADO
//
//  Created by 황민채 on 3/26/24.
//

import SwiftUI

// 포그라운드에서 푸시 알림이 올 때 햅틱이 오는 기능
class HapticHelper {
    
    static let shared = HapticHelper()
    
    private init() { }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
