//
//  StartView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var currentIndex: Int = 0
    @State private var titleText: [TextAnimation] = []
    @State private var subTitleAnimation: Bool = false
    @State private var endAnimation = false

    let titles = ["Clean your mind from", "Unique experience", "The ultimate sns"]
    let subTitles = ["Decorate your friend's picture", "Prepare your mind for sweet dreams", "Healty mind - better think - well being"]

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
                    Text("PADO에 로그인")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    Spacer()
                    
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
                            .offset(y: !subTitleAnimation ? 70 : 0)
                            .offset(y: endAnimation ? -50 : 0)
                            .opacity(endAnimation ? 0 : 1)
                            .padding(.top, 5)
                    }
                    .padding(.bottom, 80)
                    
                    HStack(spacing: 20) {
                        NavigationLink {
                            SignUpView()
                        } label: {
                            SignUpButton(text: "회원가입")
                        }

                        NavigationLink {
                            SignUpView()
                        } label: {
                            EnjoyButton(text: "로그인")
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .onAppear {
                if titleText.isEmpty {
                    startAnimation()
                }
            }
            .onChange(of: currentIndex) { _, _ in
                startAnimation()
            }
        }
    }

    func getSpilitedText(text: String, completion: @escaping () -> Void) {
        for (index, character) in text.enumerated() {
            titleText.append(TextAnimation(text: String(character)))

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.03) {
                withAnimation(.easeInOut(duration: 0.45)) {
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

    func startAnimation() {
        titleText.removeAll()
        subTitleAnimation = false
        endAnimation = false

        getSpilitedText(text: titles[currentIndex]) {
            withAnimation(.easeInOut(duration: 1)) {
                endAnimation.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
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
