//
//  ProfileViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/31/24.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var currentType: String = "받은 파도"
    @Published var padoPosts: [Post] = []
    @Published var sendPadoPosts: [Post] = []
    @Published var highlights: [Post] = []
    @Published var padoRides: [PadoRide] = []
    @Published var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @Published var selectedPostID: String = ""
    @Published var blockUser: [BlockUser] = []
    @Published var lastPadoFetchedDocument: DocumentSnapshot? = nil
    @Published var lastSendPadoFetchedDocument: DocumentSnapshot? = nil
    @Published var lastHighlightsFetchedDocument: DocumentSnapshot? = nil

    // 좋아요 공개 비공개
    @Published var openHighlight: Bool = false
    // 각각의 그리드 탭
    @Published var isShowingReceiveDetail: Bool = false
    @Published var isShowingSendDetail: Bool = false
    @Published var isShowingHightlight: Bool = false
    // 프로필사진, 뒷배경 터치 관련
    @Published var touchProfileImage: Bool = false
    @Published var touchBackImage: Bool = false
    // 프로필사진, 뒷배경 트랜지션
    @Published var isDragging = false
    @Published var position = CGSize.zero
    // 새로고침
    @Published var isRefresh: Bool = false
    // 팔로워, 팔로잉 취소
    @Published var buttonOnOff: Bool = false
    // 팔로워, 팔로잉 액션
    @Published var followerActive: Bool = false
    @Published var followingActive: Bool = false
    // 신고
    @Published var isShowingUserReport: Bool = false
    // 유저 포스트 불러올 동안 로티불러오게 하는 불린값
    @Published var fetchingPostData: Bool = true
    // 포스트 패치 관련
    @Published var fetchedPadoData: Bool = false
    @Published var fetchedSendPadoData: Bool = false
    @Published var fetchedHighlights: Bool = false
    // 사용자 차단 로직
    @Published var isUserBlocked: Bool = false
    
    // 신고 모달
    @Published var isShowingReportView: Bool = false
    // 로그인이 안되어있을 때
    @Published var isShowingLoginPage: Bool = false
    // 피드 글자 관련
    @Published var isShowingMoreText: Bool = false
    // 하트를 누른 유저
    @Published var isShowingHeartUserView: Bool = false
    
    // 파도타기 삭제 관련
    @Published var deleteMyPadoride: Bool = false
    @Published var deleteSendPadoride: Bool = false
    // 게시글 삭제 관련
    @Published var deleteMyPost: Bool = false
    @Published var deleteSendPost: Bool = false
    
    private var postListeners: [String: ListenerRegistration] = [:]
    private var db = Firestore.firestore()
    
    // URL Scheme을 사용하여 앱 열기 시도, 앱이 설치 되지 않았다면 대체 웹 URL로 이동
    func openSocialMediaApp(urlScheme: String, fallbackURL: String) {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: fallbackURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor
    func fetchPostID(user: User) async {
        await fetchPadoPosts(id: user.nameID)
        await fetchSendPadoPosts(id: user.nameID)
        if user.nameID == userNameID {
            await fetchHighlihts(id: user.nameID)
        } else {
            guard user.openHighlight != nil,
                  user.openHighlight == "yes" else { return }
            await fetchHighlihts(id: user.nameID)
        }
    }
    
    @MainActor
    func fetchPadoPosts(id: String) async {
        lastPadoFetchedDocument = nil
        padoPosts.removeAll()
        fetchedPadoData = false
        guard !id.isEmpty else { return }
        do {
            let padoQuerySnapshot =  db.collection("users").document(id).collection("mypost")
                .order(by: "created_Time", descending: true)
                .limit(to: 12)
            
            let documents = try await getDocumentsAsync(collection:
                                                            db.collection("users").document(id).collection("mypost"),
                                                        query: padoQuerySnapshot)
            
            lastPadoFetchedDocument = documents.last
            
            for document in documents {
                let docRef = db.collection("post").document(document.documentID)
                postListeners[document.documentID] = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    guard let document = documentSnapshot, document.exists,
                          let post = try? document.data(as: Post.self) else {
                        print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    guard self.filterBlockedPost(post: post) else {
                        print("\(document.documentID)는 차단된 사람의 글입니다")
                        return
                    }
                    
                    // 배열 업데이트
                    self.updatePostArray(post: post, inputType: .pado)
                }
            }
            
            if documents.count == 12 {
                fetchedPadoData = true
            }
            
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchSendPadoPosts(id: String) async {
        lastSendPadoFetchedDocument = nil
        sendPadoPosts.removeAll()
        fetchedSendPadoData = false
        guard !id.isEmpty else { return }
        do {
            let padoQuerySnapshot =  db.collection("users").document(id).collection("sendpost")
                .order(by: "created_Time", descending: true)
                .limit(to: 12)
            
            let documents = try await getDocumentsAsync(collection:
                                                            db.collection("users").document(id).collection("sendpost"),
                                                        query: padoQuerySnapshot)
            lastSendPadoFetchedDocument = documents.last
            
            for document in documents {
                let docRef = db.collection("post").document(document.documentID)
                postListeners[document.documentID] = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    guard let document = documentSnapshot, document.exists,
                          let post = try? document.data(as: Post.self) else {
                        print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    guard self.filterBlockedPost(post: post) else {
                        print("\(document.documentID)는 차단된 사람의 글입니다")
                        return
                    }
                    
                    // 배열 업데이트
                    self.updatePostArray(post: post, inputType: .sendPado)
                }
            }
            
            if documents.count == 12 {
                fetchedSendPadoData = true
            }
            
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchHighlihts(id: String) async {
        lastHighlightsFetchedDocument = nil
        highlights.removeAll()
        fetchedHighlights = false
        guard !id.isEmpty else { return }
        do {
            let padoQuerySnapshot =  db.collection("users").document(id).collection("highlight")
                .order(by: "sendHeartTime", descending: true)
                .limit(to: 12)
            
            let documents = try await getDocumentsAsync(collection:
                                                            db.collection("users").document(id).collection("highlight"),
                                                        query: padoQuerySnapshot)
            lastHighlightsFetchedDocument = documents.last
            
            for document in documents {
                let docRef = db.collection("post").document(document.documentID)
                postListeners[document.documentID] = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    guard let document = documentSnapshot, document.exists,
                          let post = try? document.data(as: Post.self) else {
                        print(" \(error?.localizedDescription ?? "Unknown error")은 삭제된 게시글 입니다.")
                        return
                    }
                    
                    guard self.filterBlockedPost(post: post) else {
                        print("\(document.documentID)는 차단된 사람의 글입니다")
                        return
                    }
                    
                    // 배열 업데이트
                    self.updatePostArray(post: post, inputType: .highlight)
                }
            }
            if documents.count == 12 {
                fetchedHighlights = true
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }

    private func updatePostArray(post: Post, inputType: InputPostType) {
        switch inputType {
        case .pado:
            if let index = padoPosts.firstIndex(where: { $0.id == post.id }) {
                padoPosts[index] = post
            } else {
                padoPosts.append(post)
            }
        case .sendPado:
            if let index = sendPadoPosts.firstIndex(where: { $0.id == post.id }) {
                sendPadoPosts[index] = post
            } else {
                sendPadoPosts.append(post)
            }
        case .highlight:
            if let index = highlights.firstIndex(where: { $0.id == post.id }) {
                highlights[index] = post
            } else {
                highlights.append(post)
            }
        }
    }
    
    // Firestore의 getDocuments에 대한 비동기 래퍼 함수
    func getDocumentsAsync(collection: CollectionReference, query: Query) async throws -> [QueryDocumentSnapshot] {
        try await withCheckedThrowingContinuation { continuation in
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let querySnapshot = querySnapshot {
                    continuation.resume(returning: querySnapshot.documents)
                } else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    func stopAllPostListeners() {
        for (_, listener) in postListeners {
            listener.remove()
        }
        postListeners.removeAll()
    }
}

// MARK: 추가 데이터 받아오기
extension ProfileViewModel {
    @MainActor
    func fetchMorePadoPosts(id: String) async {
        fetchedPadoData = false
        guard !id.isEmpty else { return }
        guard let lastPadoDocuments = lastPadoFetchedDocument else { return }
        do {
            let padoQuerySnapshot =  db.collection("users").document(id).collection("mypost")
                .order(by: "created_Time", descending: true)
                .start(afterDocument: lastPadoDocuments)
                .limit(to: 6)
            
            let documents = try await getDocumentsAsync(collection:
                                                            db.collection("users").document(id).collection("mypost"),
                                                        query: padoQuerySnapshot)
            lastPadoFetchedDocument = documents.last
            
            for document in documents {
                let docRef = db.collection("post").document(document.documentID)
                postListeners[document.documentID] = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    guard let document = documentSnapshot, document.exists,
                          let post = try? document.data(as: Post.self) else {
                        print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    guard self.filterBlockedPost(post: post) else {
                        print("\(document.documentID)는 차단된 사람의 글입니다")
                        return
                    }
                    
                    // 배열 업데이트
                    self.updatePostArray(post: post,
                                         inputType: .pado)
                }
            }
            if documents.count == 6 {
                fetchedPadoData = true
            }
            
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchMoreSendPadoPosts(id: String) async {
        fetchedSendPadoData = false
        guard !id.isEmpty else { return }
        guard let lastSendPadoDocuments = lastSendPadoFetchedDocument else { return }
        do {
            let padoQuerySnapshot =  db.collection("users").document(id).collection("sendpost")
                .order(by: "created_Time", descending: true)
                .start(afterDocument: lastSendPadoDocuments)
                .limit(to: 6)
            
            let documents = try await getDocumentsAsync(collection:
                                                            db.collection("users").document(id).collection("sendpost"),
                                                        query: padoQuerySnapshot)
            
            lastSendPadoFetchedDocument = documents.last
            
            for document in documents {
                let docRef = db.collection("post").document(document.documentID)
                postListeners[document.documentID] = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    guard let document = documentSnapshot, document.exists,
                          let post = try? document.data(as: Post.self) else {
                        print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    guard self.filterBlockedPost(post: post) else {
                        print("\(document.documentID)는 차단된 사람의 글입니다")
                        return
                    }
                    
                    // 배열 업데이트
                    self.updatePostArray(post: post,
                                         inputType: .sendPado)
                }
            }
            if documents.count == 6 {
                fetchedSendPadoData = true
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchMoreHighlihts(id: String) async {
        fetchedHighlights = false
        guard !id.isEmpty else { return }
        guard let lastHighlightsDocuments = lastHighlightsFetchedDocument else { return }
        
        do {
            let padoQuerySnapshot =  db.collection("users").document(id).collection("highlight")
                .order(by: "sendHeartTime", descending: true)
                .start(afterDocument: lastHighlightsDocuments)
                .limit(to: 6)
            
            let documents = try await getDocumentsAsync(collection:
                                                            db.collection("users").document(id).collection("highlight"),
                                                        query: padoQuerySnapshot)
            
            lastHighlightsFetchedDocument = documents.last
            
            for document in documents {
                let docRef = db.collection("post").document(document.documentID)
                postListeners[document.documentID] = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    guard let document = documentSnapshot, document.exists,
                          let post = try? document.data(as: Post.self) else {
                        print(" \(error?.localizedDescription ?? "Unknown error")은 삭제된 게시글 입니다.")
                        return
                    }
                    
                    guard self.filterBlockedPost(post: post) else {
                        print("\(document.documentID)는 차단된 사람의 글입니다")
                        return
                    }
                    
                    // 배열 업데이트
                    self.updatePostArray(post: post, 
                                         inputType: .highlight)
                }
            }
            if documents.count == 6 {
                fetchedHighlights = true
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
}

extension ProfileViewModel {
    // 차단된 사용자들 정보 불러오기
    @MainActor
    func fetchBlockUsers() async {
        guard !userNameID.isEmpty else { return }
        
        let blockingCollectionRef = db.collection("users").document(userNameID).collection("blockingUsers")
        
        let blockedCollectionRef =            db.collection("users").document(userNameID).collection("blockedUsers")
        
        do {
            let blockingSnapshot = try await blockingCollectionRef.getDocuments()
            blockingUser = blockingSnapshot.documents.compactMap { document -> BlockUser? in
                try? document.data(as: BlockUser.self)
            }
            blockUser = blockingSnapshot.documents.compactMap { document -> BlockUser? in
                try? document.data(as: BlockUser.self)
            }
            let blockedSnapshot = try await blockedCollectionRef.getDocuments()
            blockedUser = blockedSnapshot.documents.compactMap { document -> BlockUser? in
                try? document.data(as: BlockUser.self)
            }
            
        } catch {
            print("Error fetching blocked users: \(error.localizedDescription)")
        }
    }
    
    // 사용자 차단
    @MainActor
    func blockUser(blockingUser: User, user: User) async {
        
        let blockingUserRef = db.collection("users").document(user.nameID).collection("blockingUsers").document(blockingUser.nameID)
        
        let blockedUserRef = db.collection("users").document(blockingUser.nameID).collection("blockedUsers").document(user.nameID)
        
        do {
            try await blockingUserRef.setData([
                "blockUserID": blockingUser.nameID,
                "blockUserProfileImage": blockingUser.profileImageUrl ?? "",
                "blockTime": Timestamp(date: Date())
            ])
            
            try await blockedUserRef.setData([
                "blockUserID": user.nameID,
                "blockUserProfileImage": user.profileImageUrl ?? "",
                "blockTime": Timestamp(date: Date())
            ])
            
            await UpdateFollowData.shared.directUnfollowUser(id: blockingUser.nameID)
            
            await UpdateFollowData.shared.userUnfollowMe(id: blockingUser.nameID)
            
            await fetchBlockUsers()
        }
        catch {
            print("Error blocking user: \(error.localizedDescription)")
        }
        
    }
    
    // 사용자 차단 해제
    @MainActor
    func unblockUser(blockingUser: User, user: User) async {
        let blockingUserRef = db.collection("users").document(user.nameID).collection("blockingUsers").document(blockingUser.nameID)
        
        let blockedUserRef = db.collection("users").document(blockingUser.nameID).collection("blockedUsers").document(user.nameID)
        
        do {
            try await blockingUserRef.delete()
            try await blockedUserRef.delete()
            
            await fetchBlockUsers()
        } catch {
            print("Error unblocking user: \(error.localizedDescription)")
        }
    }
    
    private func filterBlockedPost(post: Post) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        if blockedUserIDs.contains(post.ownerUid) || blockedUserIDs.contains(post.surferUid) {
            return false
        } else {
            return true
        }
    }
}
