//
//  PadoRideOnboardingView.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct PadoRideOnboardingView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var padorideVM: PadoRideViewModel
    
    private let onboardingPages = [
        OnboardingPage(title: "파도타기", description: "파도타기는 친구의 파도를\n꾸밀 수 있는 기능이에요 🎨", imageName: "ridepic1"),
        OnboardingPage(title: "꾸미고 싶은 파도를 선택하기", description: "친구의 원하는 사진을 골라서\n꾸밀 수 있어요 🧸", imageName: "ridepic2"),
        OnboardingPage(title: "친구의 사진 꾸미기", description: "텍스트, 사진, 펜툴을 활용해서\n사진을 꾸며보세요 🥳", imageName: "ridepic3"),
        OnboardingPage(title: "예쁘게 꾸민 사진을 공유하기", description: "사진을 친구와 공유하여\n즐거운 시간을 만끽하세요 😎", imageName: "ridepic4"),
        OnboardingPage(title: "파도타기 확인하기", description: "파도타기를 공유했다면 아이콘을 눌러\n꾸민 사진을 확인하세요 👋", imageName: "ridepic5")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $padorideVM.currentTab) {
                ForEach(onboardingPages.indices, id: \.self) { index in
                    OnboardingPageView(title: onboardingPages[index].title, description: onboardingPages[index].description, imageName: onboardingPages[index].imageName)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .background(.modal, ignoresSafeAreaEdges: .all)
    }
}
