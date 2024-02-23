//
//  AppDelegate.swift
//  PADO
//
//  Created by 황민채 on 1/22/24.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import Foundation
import SwiftUI
import UserNotifications // 푸쉬 알림 탭했을 때 특정 페이지로 이동하기 위함

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in
                acceptAlert = "yes"
            }
        )
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
            
            // firebase Messaging Delegate 설정
            Messaging.messaging().delegate = self // Firebase 메시징 서비스의 대리자(delegate)를 현재의 AppDelegate 객체로 설정
            
            UNUserNotificationCenter.current().delegate = self
        }
        
//        if let launchOptions = launchOptions?[.remoteNotification] {
//            if let notification = launchOptions as? [String: AnyObject],
//               let aps = notification["aps"] as? [String: AnyObject] {
//                
//                if let categoryIdentifier = aps["categoryIdentifier"] as? String {
//                    switch categoryIdentifier {
//                    case "profile":
//                        NotificationCenter.default.post(name: Notification.Name("ProfileNotification"), object: aps["User_id"])
//                    case "post":
//                        NotificationCenter.default.post(name: Notification.Name("PostNotification"), object: aps["Post_id"])
//                    case "postit":
//                        NotificationCenter.default.post(name: Notification.Name("PostitNotification"), object: aps["User_id"])
//                    default:
//                        print("Unknown categoryIdentifier")
//                    }
//                } else {
//                    print("categoryIdentifier is not a string")
//                }
//            }
//        }
        return true
    }
    
    // 디바이스 토큰 등록(APNS로부터 디바이스 토큰을 받고, Firebase 메시징 서비스에 등록)
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// Firebase 메시징 토큰을 받았을 때 호출, 이 토큰은 Firebase를 통해 특정 디바이스로 푸시 알림을 보낼 때 사용
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String?) {
        
        guard let token = fcmToken else { return }
        
        userToken = token
        print(userToken)
        
        let dataDict: [String: String] = ["token": userToken]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

// 앱이 실행 중일 때 알림이 도착했을 때 호출
extension AppDelegate : UNUserNotificationCenterDelegate {
    // foreground 상태에서 푸시알림을 받았을 때 호출되는 함수
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound, .badge]) // UNNotificationPresentationOptions
        HapticHelper.shared.impact(style: .medium) // 햅틱알림
    }
    
    // 푸쉬알림을 탭했을 때 호출되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        
        switch categoryIdentifier {
        case "profile":
            NotificationCenter.default.post(name: Notification.Name("ProfileNotification"), object: userInfo["User_id"])
        case "post":
            NotificationCenter.default.post(name: Notification.Name("PostNotification"), object: userInfo["Post_id"])
        case "postit":
            NotificationCenter.default.post(name: Notification.Name("PostitNotification"), object: userInfo["User_id"])
        default:
            print("categoryIdentifier error")
        }
        
        HapticHelper.shared.impact(style: .medium) // 햅틱알림
        completionHandler()
    }
    
    // 원격 알림 수신 처리
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        return .newData
    }
}

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
