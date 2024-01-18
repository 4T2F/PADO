//
//  MyFeedHeaderView.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import SwiftUI

struct MyFeedHeaderView: View {
    // MARK: - PROPERTY
    let userId: String = "Hsungjin"
    let userNickName: String = "황성진"
    let userIntroduce: String = "저는 아흥 입니다!"
    @State var showingGlobeView: Bool = true
    @State var displayBar: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(userId)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 27)
                            .foregroundStyle(.white)
                    }
                } //: HSTACK
                .padding()
                
                
                ZStack(alignment: .bottomTrailing) {
                    CircularImageView(size: .xxLarge)
                    
                    // 버튼버전이랑 view버전(SocialGlobeView) 두개 만들어놨어요 쓰고싶은거 쓰세요
                    if showingGlobeView {
                        Button {
                            withAnimation() {
                                displayBar.toggle()
                            }
                        } label: {
                            Image(systemName: "globe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .foregroundStyle(Color.black)
                                )
                        }
                        .padding(-20)
                    }
                    
                    if displayBar {
                        SocialNetWorkBarView()
                            .transition(.opacity) // 여기서 원하는 트랜지션을 적용할 수 있습니다.
                            .padding(.horizontal, -70)
                            .padding(.bottom, -30)
                    }
                } //: ZSTACK
                
                Text(userNickName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(.systemGray2))
                    .padding(.vertical, 5)
                
                Text(userIntroduce)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(.systemGray2))
                    .padding(.vertical, 5)
                
                HStack {
                    VStack {
                        Text("5")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(4)
                        
                        Text("wave time")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.systemGray2))
                            .padding(4)
                    } //: VSTACK
                    
                    Rectangle()
                        .foregroundStyle(Color(.systemGray2))
                        .frame(width: 1, height: 30)
                        .padding()
                    
                        NavigationLink(destination: FollowView()) {
                            VStack {
                            Text("1")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(4)
                            
                            Text("follower")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(.systemGray2))
                                .padding(4)
                            } //: VSTACK
                        } //: NAVI
                    
                    Rectangle()
                        .foregroundStyle(Color(.systemGray2))
                        .frame(width: 1, height: 30)
                        .padding()
                    
                        NavigationLink(destination: FollowView()) {
                            VStack {
                            Text("1")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(4)
                            
                            Text("following")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(.systemGray2))
                                .padding(4)
                            } //: VSTACK
                        } //: NAVI
                    
                } //: HSTACK
                
            } //: VSTACK
        } //: NAVI
    }
}

#Preview {
    MyFeedHeaderView()
}
