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
import UserNotifications // 푸쉬 알림 탭했을 때 특정 페이지로 이동하기 위함

class AppDelegate: NSObject, UIApplicationDelegate {
    let viewModel = AuthenticationViewModel()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // 사용자에게 알림 권한을 요청하고, 알림 타입(알림, 배지, 소리)을 설정
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in
                
            })
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
            
            // firebase Messaging Delegate 설정
            Messaging.messaging().delegate = self // Firebase 메시징 서비스의 대리자(delegate)를 현재의 AppDelegate 객체로 설정
            
            UNUserNotificationCenter.current().delegate = self
        }
        return true
    }
    
    // 디바이스 토큰 등록(APNS로부터 디바이스 토큰을 받고, Firebase 메시징 서비스에 등록)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 앱 활성화시 기존 뱃지 카운트 0으로 변경
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 17, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

// Firebase 메시징 토큰을 받았을 때 호출, 이 토큰은 Firebase를 통해 특정 디바이스로 푸시 알림을 보낼 때 사용
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

// 앱이 실행 중일 때 알림이 도착했을 때 호출
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        completionHandler([.banner, .sound, .badge])
        
        HapticHelper.shared.impact(style: .medium) // 햅틱알림
        // Notification 분기처리
        if userInfo[AnyHashable("PADO")] as? String == "project" {
            print("It is PADO")
        } else {
            print("NOTHING")
        }
    }
    
    // 포그/백그 사용자가 푸쉬알림을 탭했을 때 이 메소드가 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        completionHandler()
        let userInfo = response.notification.request.content.userInfo
        // 푸쉬알림 탭 분기처리
        // 1.앱 켜져있음
        if application.applicationState == .active {
            print("푸쉬알림 탭(앱 켜져있음)")
            // 이제 여기서 알림의 종류를 분기시켜주면 됨
            print("\(response.notification.request.content)")
            if response.notification.request.content.categoryIdentifier == "follow" {
               // NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index":1])
                viewModel.s = true
                print("하이ㅏㅁ러;ㅣㅏ")
            }
        }
        // 2.앱 꺼져있음
        if application.applicationState == .inactive {
            print("푸쉬알림 탭(앱 꺼져있음)")
        }
        
    }
    
    // 원격 알림 수신 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        return .noData
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
