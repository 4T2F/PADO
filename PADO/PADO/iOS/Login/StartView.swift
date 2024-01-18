//
//  StartView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct StartView: View {
    
//    @State private var buttonActive: Bool = true
    @State private var isShowingPhoneNumberView = false
    
    // 애니메이션 타이틀, 부제
    @State var titles = ["Clean your mind from", "Unique experience", "The ultimate sns"]
    @State var subTitles = ["Decorate your friend's picture", "Prepare your mind for sweet dreams", "Healty mind - better think - well being"]
    // 애니메이션
    @State var currentIndex: Int = 2
    @State var titleText: [TextAnimation] = []
    
    @State var subTitleAnimation: Bool = false
    @State var endAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ForEach(1...3, id: \.self) { index in
                        Image("Pic\(index)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .opacity(currentIndex == (index - 1) ? 1 : 0)
                    }
                    
                    LinearGradient(colors: [.clear, .black.opacity(0.5), .black], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        HStack(spacing: 0) {
                            ForEach(titleText) { text in
                                Text(text.text)
                                    .offset(y: text.offset)
                            }
                            .font(.largeTitle.bold())
                        }
                        .offset(y: endAnimation ? -50 : 0)
                        .opacity(endAnimation ? 0 : 1)
                        
                        Text(subTitles[currentIndex])
                            .opacity(0.7)
                            .offset(y: !subTitleAnimation ? 90 : 0)
                            .offset(y: endAnimation ? -50 : 0)
                            .opacity(endAnimation ? 0 : 1)
                            .padding(.top, 5)
                    }
                    .padding(.bottom, 100)
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: PhoneNumberView()) {
                            SignUpButton(text: "회원가입")
                        }
                        
                        Button {
                            // 로그인 뷰 이동 링크 달아야함
                        } label: {
                            EnjoyButton(text: "둘러보기")
                        }
                    }
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .onAppear {
                currentIndex = 0
            }
            .onChange(of: currentIndex) { oldValue, newValue in
                getSpilitedText(text: titles[currentIndex]) {
                    
                    withAnimation(.easeInOut(duration: 1)) {
                        endAnimation.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        titleText.removeAll()
                        subTitleAnimation.toggle()
                        endAnimation.toggle()
                        
                        if currentIndex < (titles.count - 1) {
                            currentIndex += 1
                        } else {
                            currentIndex = 0
                        }
                    }
                }
            }
        }
    }
    
    // 텍스트를 문자 배열로 분할하여 애니메이션화 하는 함수
    func getSpilitedText(text: String, completion: @escaping () -> ()) {
        for (index,character) in text.enumerated() {
            
            // 제목 텍스트에 추가
            titleText.append(TextAnimation(text: String(character)))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.03) {
                withAnimation(.easeInOut(duration: 0.45)){
                    titleText[index].offset = 0
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.count) * 0.02) {
            withAnimation(.easeInOut(duration: 0.75)) {
                subTitleAnimation.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
            completion()
        }
    }
}

#Preview {
    StartView()
}
