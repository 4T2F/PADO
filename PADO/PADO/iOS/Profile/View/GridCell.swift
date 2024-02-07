//
//  GridCell.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Lottie
import Kingfisher
import SwiftUI

struct GridCell: View {
    @ObservedObject var feedVM: FeedViewModel
    
    @State var isHeartCheck: Bool = false
    @Binding var showDetail: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .containerRelativeFrame([.horizontal,.vertical])
                .overlay {
                    ZStack {
                        Image("pp")
                            .resizable()
                            .scaledToFill()
                            .containerRelativeFrame([.horizontal,.vertical])
                    }
                    .overlay {
                        if feedVM.isHeaderVisible {
                            LinearGradient(colors: [.black.opacity(0.5),
                                                    .black.opacity(0.4),
                                                    .black.opacity(0.3),
                                                    .black.opacity(0.2),
                                                    .black.opacity(0.1),
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .clear, .clear,
                                                    .black.opacity(0.1),
                                                    .black.opacity(0.1),
                                                    .black.opacity(0.1),
                                                    .black.opacity(0.2),
                                                    .black.opacity(0.3),
                                                    .black.opacity(0.4),
                                                    .black.opacity(0.5)],
                                           startPoint: .top,
                                           endPoint: .bottom
                            )
                            .ignoresSafeArea()
                        }
                    }
                }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("hanabi님에게 받은 파도")
                            .fontWeight(.semibold)
                        
                        Text("뷰 연동 해줘라")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 10) {
                            // MARK: - 멍게
                            VStack(spacing: 10) {
                                Button {
                                    withAnimation {
                                        // 햅틱 피드백 생성
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                        feedVM.isHeaderVisible.toggle()
                                    }
                                } label: {
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundStyle(.clear)
                                        .overlay {
                                            LottieView(animation: .named("button"))
                                                .looping()
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 200, height: 200)
                                        }
                                }
                            }
                            .padding(.bottom, 15)
                            
                            // MARK: - 하트
                            VStack(spacing: 10) {
                                if isHeartCheck {
                                    Button () {
                                        isHeartCheck.toggle()
                                    } label: {
                                        Circle()
                                            .frame(width: 24)
                                            .foregroundStyle(.clear)
                                            .overlay {
                                                LottieView(animation: .named("Heart"))
                                                    .playing()
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 65, height: 65)
                                            }
                                    }
                                } else {
                                    Button {
                                        isHeartCheck.toggle()
                                    } label: {
                                        Image("heart")
                                    }
                                }
                                
                                // MARK: - 하트 숫자
                                Text("153")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            // MARK: - 댓글
                            VStack(spacing: 10) {
                                Button () {
                                    
                                } label: {
                                    VStack {
                                        Image("chat")
                                    }
                                    .foregroundStyle(.white)
                                    .font(.footnote)
                                }
                                
                                // MARK: - 댓글숫자
                                Text("31")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            // MARK: - 신고하기
                            VStack(spacing: 10) {
                                Button {
                                    //
                                } label: {
                                    VStack {
                                        Text("...")
                                            .font(.system(size: 32))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        
                                        Text("")
                                    }
                                }
                            }
                            .padding(.top, -15)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
