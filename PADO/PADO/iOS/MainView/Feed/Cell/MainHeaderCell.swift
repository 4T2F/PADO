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
            KFImage.url(URL(string: vm.feedProfileImageUrl))
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(35)
                .overlay {
                    Image("pp")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .cornerRadius(35)
                        .offset(x: -20)
                }
            
            VStack(alignment: .leading) {
                Text("hSungjin x \(vm.feedProfileID)")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                
                Text("2시간 전")
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
                Text("오늘 니 쫌 잘나온날 ^^..")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.leading)
        }
        .padding(.top, 5)
        
    }
}

