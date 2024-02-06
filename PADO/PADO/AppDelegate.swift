//
//  AppDelegate.swift
//  PADO
//
//  Created by 황민채 on 1/22/24.
//

import FirebaseCore
import FirebaseMessaging
import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // MARK: - 사용자에게 알림 권한을 요청하고, 알림 타입(알림, 배지, 소리)을 설정
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in
                
            })
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
            
            // MARK: - firebase Messaging Delegate 설정
            Messaging.messaging().delegate = self // Firebase 메시징 서비스의 대리자(delegate)를 현재의 AppDelegate 객체로 설정
            
            UNUserNotificationCenter.current().delegate = self
        }
        return true
    }
    
    // MARK: - 디바이스 토큰 등록(APNS로부터 디바이스 토큰을 받고, Firebase 메시징 서비스에 등록)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: - 앱 활성화시 기존 뱃지 카운트 0으로 변경
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 17, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

// MARK: - Firebase 메시징 토큰을 받았을 때 호출, 이 토큰은 Firebase를 통해 특정 디바이스로 푸시 알림을 보낼 때 사용
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
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

// MARK: - 앱이 실행 중일 때 알림이 도착했을 때 호출
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print("willPresent: userInfo: ", userInfo)
        
        completionHandler([.banner, .sound, .badge])
        
        // Notification 분기처리
        if userInfo[AnyHashable("PADO")] as? String == "project" {
            print("It is PADO")
        } else {
            print("NOTHING")
        }
    }
    
    // MARK: - 사용자가 알림에 응답했을 때 호출, 예를 들어 사용자가 알림을 탭했을 때 이 메소드가 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
        completionHandler()
    }
    
    // MARK: - 원격 알림 수신 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}
