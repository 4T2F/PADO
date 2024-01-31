//
//  ProfileViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/31/24.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var currentType: String = "파도"
    @Published var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    
    // URL Scheme을 사용하여 앱 열기 시도, 앱이 설치 되지 않았다면 대체 웹 URL로 이동
    func openSocialMediaApp(urlScheme: String, fallbackURL: String) {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: fallbackURL) {
            UIApplication.shared.open(url)
        }
    }
}
