//
//  FeedCell.swift
//  TiktokReplica
//
//  Created by Berk Ilgar Özalp on 3.02.2024.
//

import Lottie
import SwiftUI

struct FeedCell: View {
    @State var heartLoading: Bool = false
    
    @Binding var isShowingReportView: Bool
    @Binding var isShowingCommentView: Bool
    
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var profileVM: ProfileViewModel
    
    @State private var postOwner: User? = nil
    let updatePushNotiData = UpdatePushNotiData()
    
    var post: Int
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .containerRelativeFrame([.horizontal,.vertical])
                .overlay {
                    //MARK: - 사진
                    Text("Post \(post)")
                        .foregroundStyle(.white)
                }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    //MARK: - 아이디 및 타이틀
                    VStack(alignment: .leading, spacing: 10) {
                        Text("hanabi님이 goat님에게 보낸 파도")
                            .fontWeight(.semibold)
                        
                        Text("아 살자 마렵다 진짜")
                        
                    }.font(.subheadline)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 10) {
                            //MARK: - 멍게
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
                            
                            //MARK: - 하트
                            VStack(spacing: 10) {
                                if feedVM.selectedFeedCheckHeart {
                                    Button {
                                        if !heartLoading {
                                            Task {
                                                heartLoading = true
                                                await feedVM.deleteHeart()
                                                feedVM.selectedFeedCheckHeart = await feedVM.checkHeartExists()
                                                heartLoading = false
                                                await profileVM.fetchHighlihts(id: userNameID)
                                            }
                                        }
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
                                        if !heartLoading {
                                            Task {
                                                heartLoading = true
                                                await feedVM.addHeart()
                                                feedVM.selectedFeedCheckHeart = await feedVM.checkHeartExists()
                                                heartLoading = false
                                                await profileVM.fetchHighlihts(id: userNameID)
                                                self.postOwner = await UpdateUserData.shared.getOthersProfileDatas(id: feedVM.feedOwnerProfileID)
                                                await updatePushNotiData.pushNoti(receiveUser: postOwner!, type: .heart)
                                            }
                                        }
                                    } label: {
                                        Image("heart")
                                    }
                                }
                                
                                //MARK: - 하트 숫자
                                Text("\(feedVM.selectedFeedHearts)")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            //MARK: - 댓글
                            VStack(spacing: 10) {
                                Button {
                                    isShowingCommentView = true
                                } label: {
                                    Image("chat")
                                }
                                .sheet(isPresented: $isShowingCommentView) {
                                    CommentView(feedVM: feedVM,
                                                surfingVM: surfingVM, isShowingCommentView: $isShowingCommentView)
                                }
                                .presentationDetents([.large])
                                
                                //MARK: - 댓글 숫자
                                Text(String(feedVM.selectedCommentCounts))
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            //MARK: - 신고하기
                            VStack(spacing: 10) {
                                Button {
                                    isShowingReportView.toggle()
                                } label: {
                                    VStack {
                                        Text("...")
                                            .font(.system(size: 32))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        
                                        Text("")
                                    }
                                }
                                .sheet(isPresented: $isShowingReportView) {
                                    ReportSelectView(isShowingReportView: $isShowingReportView)
                                        .presentationDetents([.medium, .fraction(0.8)]) // 모달높이 조절
                                        .presentationDragIndicator(.visible)
                                }
                            }
                            .padding(.top, -15)
                        }
                    }
                }
                .padding(.bottom ,80)
            }
            .padding()
        }
    }
}
