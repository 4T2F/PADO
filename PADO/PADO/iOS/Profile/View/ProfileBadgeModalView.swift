//
//  ProfileBadgeModalView.swift
//  PADO
//
//  Created by 강치우 on 1/31/24.
//

import SwiftUI

struct ProfileBadgeModalView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var profileVM = ProfileViewModel()
    
    @State private var buttonActive: Bool = false
    
    let user: User
    
    var body: some View {
        ZStack {
            Color.modal.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 15, content: {
                Text("\(user.nameID)님의 프로필 더 보기")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.top, 5)
                
                VStack(spacing: 20) {
                    // 인스타그램 버튼 (계정이 있을 때만 표시)
                    if !user.instaAddress.isEmpty {
                        Button {
                            profileVM.openSocialMediaApp(urlScheme: "instagram://user?username=\(user.instaAddress)", fallbackURL: "https://instagram.com/\(user.instaAddress)")
                        } label: {
                            SNSButton(buttonActive: $buttonActive, text: "Instagram", image: "instagram")
                        }
                    }
                    
                    // 틱톡 버튼 (계정이 있을 때만 표시)
                    if !user.tiktokAddress.isEmpty {
                        Button {
                            profileVM.openSocialMediaApp(urlScheme: "tiktok://user?username=\(user.tiktokAddress)", fallbackURL: "https://www.tiktok.com/@\(user.tiktokAddress)")
                        } label: {
                            SNSButton(buttonActive: $buttonActive, text: "TikTok", image: "tiktok")
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, -25)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
        }
    }
}
