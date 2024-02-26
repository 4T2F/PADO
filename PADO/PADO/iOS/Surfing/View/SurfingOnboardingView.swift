//
//  OnboardingTabView.swift
//  PADO
//
//  Created by 강치우 on 2/21/24.
//

import SwiftUI

struct SurfingOnboardingView: View {
    @State private var currentTab = 0
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var followVM: FollowViewModel
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
                VStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("사진을 선택하세요")
                            .font(.system(.title3))
                            .fontWeight(.medium)
                        
                        Text("친구에게 보낼 우스꽝스럽거나\n예쁜 사진을 선택해보세요 😝")
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.callout)
                            .lineSpacing(2)
                    }
                    
                    Image("selectpic")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(0)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("파도를 보낼 친구를 선택하세요")
                        .font(.system(.title3))
                        .fontWeight(.medium)
                    
                    Text("친구들과 일상의 즐거운 경험을\n공유하세요 🥳")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.callout)
                        .lineSpacing(2)
                    
                    Image("surfpic")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(1)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("서퍼로 지정되어 있다면\n파도를 보낼 수 있어요")
                        .font(.system(.title3))
                        .fontWeight(.medium)
                    
                    Text("서퍼 확인은 친구 팔로워에서 확인 할 수 있어요 😎")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.callout)
                        .lineSpacing(2)
                    
                    Image("followerpic")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(2)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("서퍼가 아니신가요?")
                        .font(.system(.title3))
                        .fontWeight(.medium)
                    
                    Text("친구 프로필의 방명록에 서퍼 요청을\n해보는건 어떨까요? 👋")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.callout)
                        .lineSpacing(2)
                    
                    Image("visitpic")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            
            Button {
                if userFollowingIDs.isEmpty {
                    surfingVM.isShowPopularModal = true
                } else if followVM.surfingIDs.isEmpty {
                    surfingVM.isShowFollowingModal = true
                } else {
                    surfingVM.isShowingPhotoModal = true
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 40)
                        .foregroundStyle(.blueButton)
                    
                        Text("사진 선택")
                        .font(.system(.body))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                }
            }
            .padding(.bottom)
        }
    }
}
