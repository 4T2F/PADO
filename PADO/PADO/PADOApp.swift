//
//  PADOApp.swift
//  PADO
//
//  Created by 최동호 on 1/2/24.
//

import SwiftUI

@main
struct PADOApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
