//
//  FeedCell.swift
//  PADO
//
//  Created by 최동호, 황민채 on 2/6/24.
//

import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import Lottie
import SwiftUI

struct FeedCell: View {
    @State var heartLoading: Bool = false
    @State var isLoading: Bool = false
    @State var isHeartCheck: Bool = false
    @State var postUser: User? = nil
    @State var surferUser: User? = nil
    
    @State private var heartCounts: Int = 0
    @State private var commentCounts: Int = 0
    @State private var isShowingReportView: Bool = false
    @State private var isShowingCommentView: Bool = false
    
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var profileVM: ProfileViewModel
    
    let updateHeartData: UpdateHeartData
    let post: Post
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .containerRelativeFrame([.horizontal,.vertical])
                .overlay {
                    // MARK: - 사진
                    if let imageUrl = URL(string: post.imageUrl) {
                        ZStack {
                            KFImage.url(imageUrl)
                                .resizable()
                                .onSuccess { _ in
                                    // 이미지 로딩 성공 시
                                    isLoading = false
                                }
                                .onFailure { _ in
                                    // 이미지 로딩 실패 시
                                    isLoading = false
                                }
                                .onProgress { receivedSize, totalSize in
                                    // 로딩 중
                                    isLoading = true
                                }
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
                        
                        if isLoading { // feedVM에서 로딩 상태를 관리한다고 가정
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    // MARK: - 아이디 및 타이틀
                    VStack(alignment: .leading, spacing: 10) {
                        if let postUser = postUser, let surferUser = surferUser {
                            CircularImageView(size: .small,
                                              user: postUser)
                            .padding(.leading, 24)
                            .overlay {
                                CircularImageView(size: .small,
                                                  user: surferUser)
                                .offset(x: -12)
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("@\(post.surferUid)")
                                    .font(.system(size: 20))
                                
                                Text("\(post.created_Time.toFormattedString())")
                                    .font(.system(size: 14))
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            
                            Text("\(post.ownerUid)님에게 보낸 파도")
                                .fontWeight(.medium)
                        }
                        
                        Text("\(post.title)")
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
                                                    await feedVM.updatePushNotiData.pushNoti(receiveUser: postUser, type: .heart)
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
                self.surferUser = await UpdateUserData.shared.getOthersProfileDatas(id: post.surferUid)
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
