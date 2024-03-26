//
//  FeedCellViewModel.swift
//  PADO
//
//  Created by 최동호 on 3/16/24.
//

import FirebaseFirestore
import FirebaseStorage

import SwiftUI

class FeedCellViewModel: ObservableObject {
    @Published var heartLoading: Bool = false
    @Published var isLoading: Bool = false
    @Published var isHeartCheck: Bool = false
    @Published var isHeaderVisible = true
    @Published var postUser: User? = nil
    @Published var surferUser: User? = nil
    @Published var postOwnerButtonOnOff: Bool = false
    @Published var postSurferButtonOnOff: Bool = false
    
    // 뷰 오픈
    @Published var isShowingMoreText: Bool = false
    @Published var isShowingReportView: Bool = false
    @Published var isShowingLoginPage: Bool = false
    @Published var isShowingHeartUserView: Bool = false
    
    // 삭제
    @Published var deletePadorideModal: Bool = false
    @Published var deleteMyPost: Bool = false
    @Published var deleteSendPost: Bool = false
    
    // 파도타기 관련
    @Published var padoRidePosts: [PadoRide] = []
    @Published var currentPadoRideIndex: Int? = nil
    @Published var isShowingPadoRide: Bool = false
    @Published var checkPadoRide: [PadoRide] = []
    
    @Published var hearts: [Heart] = []
    
    private var db = Firestore.firestore()
   
    // 파도타기 게시글 불러오기
    @MainActor
    func fetchPadoRides(postID: String) async {
        padoRidePosts.removeAll()
        
        let postRef = db.collection("post").document(postID)
        let padoRideCollection = postRef.collection("padoride")
        
        do {
            let snapshot = try await padoRideCollection.getDocuments()
            self.padoRidePosts = snapshot.documents.compactMap { document in
                try? document.data(as: PadoRide.self)
            }
        } catch {
            print("PadoRides 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    // 파도타기 게시글의 유무 확인
    @MainActor
    func checkForPadorides(postID: String) async {
        checkPadoRide.removeAll()
        guard !postID.isEmpty else { return }
        
        let postRef = db.collection("post").document(postID)
        let padoRideCollection = postRef.collection("padoride")
        
        do {
            let snapshot = try await padoRideCollection.getDocuments()
            self.checkPadoRide = snapshot.documents.compactMap { document in
                try? document.data(as: PadoRide.self)
            }
        } catch {
            print("PadoRides 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    func touchPadoRideButton(postID: String) {
        if let currentIndex = currentPadoRideIndex {
            // 다음 이미지로 이동
            let nextIndex = currentIndex + 1
            if nextIndex < padoRidePosts.count {
                currentPadoRideIndex = nextIndex
            } else {
                // 모든 PadoRide 이미지를 보여준 후, 원래 포스트로 돌아감
                currentPadoRideIndex = nil
                isHeaderVisible = true
                isShowingPadoRide = false
                padoRidePosts = []
            }
        } else {
            // 최초로 PadoRide 이미지 보여주기
            // PadoRidePosts가 이미 로드되었는지 확인
            if padoRidePosts.isEmpty {
                Task {
                    await fetchPadoRides(postID: postID)
                    if !padoRidePosts.isEmpty {
                        
                        isHeaderVisible = false
                        isShowingPadoRide = true
                        currentPadoRideIndex = 0
                    }
                }
            } else {
                isHeaderVisible = true
                isShowingPadoRide = false
                currentPadoRideIndex = 0
            }
        }
    }
    
    @MainActor
    func touchDeleteHeart(post:Post) async {
        if !heartLoading && !blockPost(post: post) {
            Task {
                heartLoading = true
                
                await UpdateHeartData.shared.deleteHeart(post: post)
                isHeartCheck.toggle()
                heartLoading = false
            }
        }
    }
    
    @MainActor
    func touchAddHeart(post: Post) async {
        if userNameID.isEmpty {
            isShowingLoginPage = true
        } else if !heartLoading && !blockPost(post: post) {
            Task {
                let generator =  UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                heartLoading = true
                if let postID = post.id, let postUser = postUser {
                    await UpdateHeartData.shared.addHeart(post: post)
                    isHeartCheck.toggle()
                    heartLoading = false
                    await UpdatePushNotiData.shared.pushPostNoti(targetPostID: postID,
                                                                 receiveUser: postUser,
                                                                 type: .heart,
                                                                 message: "",
                                                                 post: post)
                }
            }
        }
    }
    
    func touchReport(post: Post) {
        if let padoRideIndex = currentPadoRideIndex {
            if post.ownerUid == userNameID {
                // 내가 받은 게시물의 멍게 삭제 로직
                deletePadorideModal = true
            } else if padoRidePosts[padoRideIndex].id == userNameID {
                // 내가 보낸 멍게의 삭제 로직
                deletePadorideModal = true
            } else {
                if !userNameID.isEmpty {
                    isShowingReportView.toggle()
                } else {
                    isShowingLoginPage = true
                }
            }
        } else {
            if post.ownerUid == userNameID {
                // 내가 받은 게시물 삭제 로직
                deleteMyPost = true
            } else if post.surferUid == userNameID {
                // 내가 보낸 게시물 삭제 로직
                deleteSendPost = true
            } else {
                if !userNameID.isEmpty {
                    isShowingReportView.toggle()
                } else {
                    isShowingLoginPage = true
                }
            }
        }
    }
    
    @MainActor
    func deletePado(post: Post) async {
        Task {
            await DeletePost.shared.deletePost(postID: post.id ?? "",
                                               postOwnerID: post.ownerUid,
                                               sufferID: post.surferUid)
            deleteMyPost = false
            needsDataFetch.toggle()
        }
    }
    
    @MainActor
    func deletePadoRide(postID: String) async {
        let fileName = padoRidePosts[currentPadoRideIndex ?? 0].storageFileName
        let subID = padoRidePosts[currentPadoRideIndex ?? 0].id
        
        Task {
            try await DeletePost.shared.deletePadoridePost(postID: postID,
                                                           storageFileName: fileName,
                                                           subID: subID ?? "")
            if padoRidePosts.count == 1 {
                fetchPadoRideExist(postID: postID)
            }
            
            currentPadoRideIndex = nil
            isHeaderVisible = true
            isShowingPadoRide = false
            deletePadorideModal = false
            padoRidePosts = []
        }
    }
    
    func fetchPadoRideExist(postID: String) {
        guard !postID.isEmpty else { return }
        db.collection("post").document(postID).updateData(["padoExist": false])
    }
    
    @MainActor
    func fetchPostData(post: Post) async {
        self.postUser = await UpdateUserData.shared.getOthersProfileDatas(id: post.ownerUid)
        self.surferUser = await UpdateUserData.shared.getOthersProfileDatas(id: post.surferUid)
        
        isHeartCheck =  UpdateHeartData.shared.checkHeartExists(post: post)
        
        self.postOwnerButtonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: post.ownerUid)
        self.postSurferButtonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: post.surferUid)
    }

    func blockPost(post: Post) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return blockedUserIDs.contains(post.ownerUid) || blockedUserIDs.contains(post.surferUid)
    }
    
    @MainActor
    func doubleTapCell(size: CGFloat, position: CGPoint, post: Post) {
        let id = UUID()
        var heartSize = size
        
        // 이미 좋아요가 있는 경우, 크기를 증가
        if let lastHeart = hearts.last {
            heartSize = lastHeart.size + 10
        }
        
        self.hearts.append(.init(id: id,
                                       tappedRect: position,
                                       isAnimated: false,
                                       size: heartSize))
        
        withAnimation(.snappy(duration: 1.5), completionCriteria:
            .logicallyComplete) {
                if let index = self.hearts.firstIndex(where: { $0.id == id }) {
                    self.hearts[index].isAnimated = true
                }
            } completion: {
                self.hearts.removeAll(where: { $0.id == id })
            }
        
        Task {
            if !isHeartCheck {
                await touchAddHeart(post: post)
            }
        }
    }
}
