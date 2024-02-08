//
//  GridCell.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import Lottie
import SwiftUI

struct ReceivePostCell: View {
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    
    @State var heartLoading: Bool = false
    @State var isHeartCheck: Bool = false
    @State var postUser: User? = nil
    
    @State private var heartCounts: Int = 0
    @State private var commentCounts: Int = 0
    @State private var isShowingReportView: Bool = false
    @State private var isShowingCommentView: Bool = false
    
    let updateHeartData: UpdateHeartData
    let post: Post
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .containerRelativeFrame([.horizontal,.vertical])
                .overlay {
                    if let imageUrl = URL(string: post.imageUrl) {
                        ZStack {
                            KFImage.url(imageUrl)
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
                }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        if post.title.isEmpty {
                            HStack(alignment: .center, spacing: 8) {
                                Text("\(post.surferUid)님에게 받은 파도")
                                    .font(.system(size: 14))
                                
                                Text("\(post.created_Time.formatDate(post.created_Time))")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        } else {
                            HStack(alignment: .center, spacing: 8) {
                                Text("\(post.surferUid)님에게 받은 파도")
                                    .font(.system(size: 14))
                                
                                Text("\(post.created_Time.formatDate(post.created_Time))")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .padding(.bottom, 5)
                            
                            Text("\(post.title)")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom, 14)
                    
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
                                    Button {
                                        if !heartLoading {
                                            Task {
                                                heartLoading = true
                                                if let postID = post.id {
                                                    await updateHeartData.deleteHeart(documentID: postID)
                                                    isHeartCheck = await updateHeartData.checkHeartExists(documentID: postID)
                                                    heartLoading = false
                                                }
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
                                                if let postID = post.id, let postUser = postUser {
                                                    await updateHeartData.addHeart(documentID: postID)
                                                    isHeartCheck = await updateHeartData.checkHeartExists(documentID: postID)
                                                    heartLoading = false
                                                    await feedVM.updatePushNotiData.pushPostNoti(targetPostID: postID, receiveUser: postUser, type: .heart, message:"")
                                                }
                                                await profileVM.fetchHighlihts(id: userNameID)
                                                
                                            }
                                        }
                                    } label: {
                                        Image("heart")
                                    }
                                }
                                
                                // MARK: - 하트 숫자
                                Text("\(heartCounts)")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            // MARK: - 댓글
                            VStack(spacing: 10) {
                                Button {
                                    isShowingCommentView = true
                                } label: {
                                    Image("chat")
                                }
                                .sheet(isPresented: $isShowingCommentView) {
                                    if let postUser = postUser, let postID = post.id {
                                        CommentView(feedVM: feedVM,
                                                    surfingVM: surfingVM,
                                                    isShowingCommentView: $isShowingCommentView,
                                                    postUser: postUser,
                                                    post: post,
                                                    postID: postID)
                                    }
                                }
                                .presentationDetents([.large])
                                
                                // MARK: - 댓글 숫자
                                Text("\(commentCounts)")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .shadow(radius: 1, y: 1)
                            }
                            
                            // MARK: - 신고하기
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
            }
            .padding()
        }
        .onAppear {
            Task {
                self.postUser = await UpdateUserData.shared.getOthersProfileDatas(id: post.ownerUid)
                if let postID = post.id {
                    await fetchHeartCommentCounts(documentID: postID)
                    isHeartCheck = await updateHeartData.checkHeartExists(documentID: postID)
                }
            }
        }
    }
    
    func fetchHeartCommentCounts(documentID: String) async {
        let db = Firestore.firestore()
        db.collection("post").document(documentID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            self.heartCounts = data["heartsCount"] as? Int ?? 0
            self.commentCounts = data["commentCount"] as? Int ?? 0
        }
    }
}
