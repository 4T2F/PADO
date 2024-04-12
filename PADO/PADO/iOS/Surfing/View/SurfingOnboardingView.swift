//
//  OnboardingTabView.swift
//  PADO
//
//  Created by 강치우 on 2/21/24.
//

import SwiftUI

struct OnboardingPage {
    var title: String
    var description: String
    var imageName: String
}

struct SurfingOnboardingView: View {
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var followVM: FollowViewModel
    
    private let onboardingPages = [
        OnboardingPage(title: "사진을 선택하세요",
                       description: "친구에게 보낼 우스꽝스럽거나\n예쁜 사진을 선택해보세요 😝",
                       imageName: "selectpic"),
        OnboardingPage(title: "파도를 보낼 친구를 선택하세요",
                       description: "친구들과 일상의 즐거운 경험을\n공유하세요 🥳",
                       imageName: "surfpic"),
        OnboardingPage(title: "서퍼로 지정되어 있다면\n파도를 보낼 수 있어요",
                       description: "서퍼 확인은 친구 팔로워에서 확인 할 수 있어요 😎",
                       imageName: "followerpic"),
        OnboardingPage(title: "서퍼가 아니신가요?",
                       description: "서퍼 확인은 친구 팔로워에서 확인 할 수 있어요 😎",
                       imageName: "visitpic")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $surfingVM.showingTab) {
                ForEach(onboardingPages.indices, id: \.self) { index in
                    OnboardingPageView(title: onboardingPages[index].title,
                                       description: onboardingPages[index].description,
                                       imageName: onboardingPages[index].imageName)
                    .tag(index)
                }
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
