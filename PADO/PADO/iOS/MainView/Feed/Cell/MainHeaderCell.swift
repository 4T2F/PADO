//
//  MainHeader.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import Kingfisher
import SwiftUI

struct MainHeaderCell: View {
    @ObservedObject var vm: FeedViewModel

    var body: some View {
        HStack {
            // 프로필 사진 들어가야함 근데 프로필 사진 없으면 기본 이미지 들어가게 해야함.
            UrlProfileImageView(imageUrl: vm.feedSurferProfileImageUrl,
                                size: .small,
                                defaultImageName: "defaultProfile")
            .overlay {
                UrlProfileImageView(imageUrl: vm.feedOwnerProfileImageUrl,
                                    size: .small,
                                    defaultImageName: "defaultProfile")
                .offset(x: -24)
            }

            VStack(alignment: .leading) {
                Text("\(vm.feedSurferProfileID)님이 \(vm.feedOwnerProfileID)님에게 보낸 파도")
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                
                Text(vm.selectedFeedTime)
                    .font(.system(size: 12))
            }
            
            Spacer()
            
            // 알림이 없으면 기본 Bell_light 바꾸는 로직 추가해야함
            NavigationLink(destination: NotificationView()) {
                Image("Bell_pin_light")
            }
        }
        .padding(.horizontal)
        .padding(.leading, 20)
        .padding(.top, 10)
        
        VStack(alignment: .leading) {
            HStack {
                Text(vm.selectedFeedTitle)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.leading)
        }
        .padding(.top, 5)
        
    }
}

