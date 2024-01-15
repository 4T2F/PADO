//
//  FeedCell.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct FeedCell: View {
    
    @Binding var isShowFollowButton: Bool
    @State var isFollowed = true
    
    var body: some View {
        ZStack {
            Color.mainBackground.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // Username
                HStack {
                    FeedSurfers()
                    
                    Spacer()
                    if isShowFollowButton {
                        BlueButtonView(buttonActive: $isFollowed,
                                       activeText: "팔로우",
                                       unActiveText: "팔로잉",
                                       widthValue: UIScreen.main.bounds.width * 0.2,
                                       heightValue: 30)
                        .padding(.trailing, 10)
                    }
                }
                
                // Image
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                Button(action: {
                                    // 하트 버튼 클릭 시 수행할 동작
                                }) {
                                    Image(systemName: "ellipsis")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                }
                                .padding(.top, 20)
                                
                                Button(action: {
                                    // 하트 버튼 클릭 시 수행할 동작
                                }) {
                                    Image(systemName: "heart")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                }
                                .padding(.top, 20)
                                
                                Button(action: {
                                    // 텍스트 클릭 시 수행할 동작
                                }) {
                                    Text("16.7K")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                }
                                .padding(.top, 2)
                                
                                Button(action: {
                                    // 얼굴 아이콘 클릭 시 수행할 동작
                                }) {
                                    Image(systemName: "face.smiling.fill")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                }
                                .padding(.top, 10)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 50)
                        }
                    }
                    .zIndex(1)
                    
                    VStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                        
                        HStack {
                            Text("게시글 제목임")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .padding(.leading, 4)
                            
                            Spacer()
                            
                            Button(action: {
                                // "댓글 달기..." 클릭 시 수행할 동작
                            }) {
                                Text("댓글 달기...")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16))
                            }
                            .padding(.trailing, 4)
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 600)
        }
    }
}

//#Preview {
//    FeedCell()
//}
