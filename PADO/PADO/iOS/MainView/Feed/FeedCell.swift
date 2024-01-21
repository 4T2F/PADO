//
//  FeedCell.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct FeedCell: View {
    
    @Binding var isShowFollowButton: Bool
    @State var isShowingReportView = false
    @State var isFollowed = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // Username
                HStack {
                    FeedSurfers()
                    
                    Spacer()
                    
                    Button {
                        isShowingReportView.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 25, height: 6)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 12)
                    .sheet(isPresented: $isShowingReportView) {
                        ReportSelectView(isShowingReportView: $isShowingReportView)
                            .presentationDetents([.height(600)]) // 모달높이 조절
                    }
                }
                .padding(.top, 50)
                
                // Image
                Image("back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 520)
                    .padding(.bottom, 10)
                HStack {
                    Text("Hsungjin")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                    Text("제목입니다")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        // 좋아요 버튼
                    }) {
                        Image(systemName: "heart")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                    }
                    .padding(.trailing, 10)
                    
                }
                .padding(.bottom)
                
                HStack {
                    Button {
                        // 댓글 뷰 열기
                    } label: {
                        Text("댓글 달기...")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 600)
        }
    }
}

#Preview {
    FeedView(isShowFollowButton: true, mainMenu: .constant("feed"))
}
