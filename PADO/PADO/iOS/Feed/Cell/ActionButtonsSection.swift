//
//  ActionButtonsSection.swift
//  PADO
//
//  Created by 강치우 on 3/17/24.
//

import Lottie

import SwiftUI

struct ActionButtonsSection: View {
    @ObservedObject var feedCellVM: FeedCellViewModel
    
    @Binding var post: Post
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                // MARK: - 멍게
                VStack(spacing: 10) {
                    if post.padoExist ?? false {
                        Button {
                            withAnimation {
                                // 햅틱 피드백 생성
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                
                                feedCellVM.touchPadoRideButton(postID: post.id ?? "")
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
                    } else {
                        Circle()
                            .frame(width: 30)
                            .foregroundStyle(.clear)
                    }
                }
                .padding(.bottom, 15)
                
                
                // MARK: - 하트
                VStack(spacing: 10) {
                    if feedCellVM.isHeartCheck {
                        Button {
                            Task {
                                await feedCellVM.touchDeleteHeart(post: post)
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
                            Task {
                                await feedCellVM.touchAddHeart(post: post)
                            }
                        } label: {
                            Image("heart")
                        }
                        .sheet(isPresented: $feedCellVM.isShowingLoginPage, content: {
                            StartView(isShowStartView: $feedCellVM.isShowingLoginPage)
                                .presentationDragIndicator(.visible)
                        })
                    }
                    
                    // MARK: - 하트 숫자
                    Button {
                        if post.heartIDs.count > 1 {
                            feedCellVM.isShowingHeartUserView = true
                        }
                    } label: {
                        Text("\(post.heartIDs.count-1)")
                            .font(.system(.caption2))
                            .fontWeight(.semibold)
                            .shadow(radius: 1, y: 1)
                    }
                    .sheet(isPresented: $feedCellVM.isShowingHeartUserView, content: {
                        HeartUsersView(userIDs: post.heartIDs)
                    })
                }
                
                // MARK: - 댓글
                NavigationLink {
                    if let postUser = feedCellVM.postUser,
                       !feedCellVM.blockPost(post: post) {
                        CommentView(postUser: postUser,
                                    post: post)
                        
                    }
                } label: {
                    VStack(spacing: 10) {
                        Image("chat")
                        
                        // MARK: - 댓글 숫자
                        Text("\(post.commentCount)")
                            .font(.system(.caption2))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .shadow(radius: 1, y: 1)
                    }
                }
                
                // MARK: - 신고하기
                VStack(spacing: 10) {
                    Button {
                        feedCellVM.touchReport(post: post)
                    } label: {
                        VStack {
                            Text("...")
                                .font(.system(.largeTitle))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                            
                            Text("")
                        }
                    }
                    .sheet(isPresented: $feedCellVM.deletePadorideModal) {
                        PostSelectModalView(title: "해당 파도타기를 삭제하시겠습니까?") {
                            if let postID = post.id {
                                await feedCellVM.deletePadoRide(postID: postID)
                            }
                        }
                        .presentationDetents([.fraction(0.4)])
                    }
                    
                    .sheet(isPresented: $feedCellVM.deleteSendPost) {
                        PostSelectModalView(title: "해당 파도를 삭제하시겠습니까?") {
                            await feedCellVM.deletePado(post: post)
                        }
                        .presentationDetents([.fraction(0.4)])
                    }
                    .sheet(isPresented: $feedCellVM.isShowingReportView) {
                        ReportSelectView(isShowingReportView: $feedCellVM.isShowingReportView)
                            .presentationDetents([.medium, .fraction(0.8)]) // 모달높이 조절
                            .presentationDragIndicator(.visible)
                    }
                    .sheet(isPresented: $feedCellVM.isShowingLoginPage, content: {
                        StartView(isShowStartView: $feedCellVM.isShowingLoginPage)
                            .presentationDragIndicator(.visible)
                    })
                }
                .padding(.top, -15)
            }
        }
    }
}
