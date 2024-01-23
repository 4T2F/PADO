//
//  Feed.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct FeedView: View {
    
    @State var isShowFollowButton: Bool
    @Binding var mainMenu: String
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var isAlertItem = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(1..<8) { _ in
                            FeedCell(isShowFollowButton: $isShowFollowButton)
                                .padding(.bottom, 80)
                        }
                    }
                    .padding(.top, 40)
                }
                
                VStack {
                    VStack {
                        HStack {
                            Text("PADO")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 22))
                            
                            Spacer()
                            
                            Button {
                                // 알림뷰 이동
                            } label: {
                                ZStack {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.white)
                                    Text(".")
                                        .bold()
                                        .font(.system(size: 30))
                                        .foregroundStyle(.red)
                                        .offset(x: 8, y: -15)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    FeedView(isShowFollowButton: true, mainMenu: .constant("feed"))
}
