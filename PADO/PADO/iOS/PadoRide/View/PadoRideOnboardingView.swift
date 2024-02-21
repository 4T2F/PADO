//
//  PadoRideOnboardingView.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct PadoRideOnboardingView: View {
    @State private var currentTab = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
                VStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("파도타기")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Text("파도타기는 친구의 파도를\n꾸밀 수 있는 기능이에요 🎨")
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.callout)
                            .lineSpacing(2)
                    }
                    
                    Image("ridepic1")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(0)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("꾸미고 싶은 파도를 선택하기")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("텍스트, 사진, 펜툴을 활용해서\n사진을 꾸며보세요 🥳")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.callout)
                        .lineSpacing(2)
                    
                    Image("ridepic2")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(1)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("예쁘게 꾸민 사진을 공유하기")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("사진을 친구와 공유하여\n즐거운 시간을 만끽하세요 😎")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.callout)
                        .lineSpacing(2)
                    
                    Image("ridepic3")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(2)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("파도타기 확인하기")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("파도타기를 공유했다면 아이콘을 눌러\n꾸민 사진을 확인하세요 👋")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.callout)
                        .lineSpacing(2)
                    
                    Image("ridepic4")
                        .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .background(.modal, ignoresSafeAreaEdges: .all)
    }
}
