//
//  ViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/23/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

@MainActor
class FeedViewModel:Identifiable ,ObservableObject {
    
    // MARK: - feed관련
    @Published var isShowingReportView = false
    @Published var isShowingCommentView = false
    @Published var isHeaderVisible = true
    @Published var textPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @Published var faceMojiPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
  
    @Published var followingPosts: [Post] = []
    @Published var todayPadoPosts: [Post] = []
    @Published var followingUsers: [String] = []
    @Published var watchedPostIDs: Set<String> = []
    
    @Published var selectedFeedCheckHeart: Bool = false
    @Published var postFetchLoading: Bool = false
    @Published var selectedFeedHearts: Int = 0
    @Published var selectedCommentCounts: Int = 0
    
    @Published var scrollsave: String?

    // MARK: - comment관련
    @Published var comments: [Comment] = []
    @Published var documentID: String = ""
    @Published var inputcomment: String = ""
    @Published var showdeleteModal: Bool = false
    @Published var showreportModal: Bool = false
    @Published var selectedComment: Comment?
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var dragStart: CGPoint?
    let dragThreshold: CGFloat = 0
    let updateCommentData = UpdateCommentData()
    let updatePushNotiData = UpdatePushNotiData()
    // MARK: - FaceMoji 관련
    @Published var faceMojiUIImage: UIImage?
    @Published var cropMojiUIImage: UIImage?
    @Published var cropMojiImage: Image = Image("")
    @Published var facemojies: [Facemoji] = []
    @Published var deleteFacemojiModal: Bool = false
    @Published var showCropFaceMoji: Bool = false
    @Published var showEmojiView: Bool = false
    @Published var selectedEmoji: String = ""
    @Published var selectedFacemoji: Facemoji?
    
    let updateFacemojiData = UpdateFacemojiData()
    
    @Published var lastFollowFetchedDocument: DocumentSnapshot? = nil
    @Published var lastTodayPadoFetchedDocument: DocumentSnapshot? = nil
    
    init() {
        // Firestore의 `post` 컬렉션에 대한 실시간 리스너 설정
        findFollowingUsers()
    }
    
    func findFollowingUsers() {
        followingUsers.removeAll()
        listener = db.collection("users").document(userNameID).collection("following").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self, let documents = querySnapshot?.documents else {
                print("Error fetching following users: \(error?.localizedDescription ?? "Unknown error")")
                return
                
            }
            
            self.followingUsers = documents.compactMap { $0.data()["followingID"] as? String }
            self.followingUsers.append(userNameID)
            
            Task {
                self.postFetchLoading = true
                await self.cacheWatchedData()
                await self.fetchFollowingPosts()
                self.postFetchLoading = false
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
    
    // 팔로잉 중인 사용자들로부터 포스트 가져오기 (비동기적으로)
    private func fetchFollowingPosts() async {
        followingPosts.removeAll()
        lastFollowFetchedDocument = nil
        // 현재 날짜로부터 2일 전의 날짜를 계산
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()
           // Date 객체를 Timestamp로 변환
        let twoDaysAgoTimestamp = Timestamp(date: twoDaysAgo)
        
  
        let query = db.collection("post")
            .whereField("created_Time", isGreaterThanOrEqualTo: twoDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .limit(to: 5)
        
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            
            self.lastFollowFetchedDocument = documents.last
            self.followingPosts = documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            .filter { post in
                followingUsers.contains(where: { $0 == post.ownerUid })
            }
        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
        self.followingPosts.sort {
            !self.watchedPostIDs.contains($0.id ?? "") && self.watchedPostIDs.contains($1.id ?? "")
        }
    }
    
    // 오늘 파도 포스트 가져오기
    func fetchTodayPadoPosts() async {
        todayPadoPosts.removeAll()
        lastTodayPadoFetchedDocument = nil
        
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
           // Date 객체를 Timestamp로 변환
        let sevenDaysAgoTimestamp = Timestamp(date: sevenDaysAgo)
        
        let query = db.collection("post")
            .whereField("created_Time", isGreaterThanOrEqualTo: sevenDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .order(by: "heartsCount", descending: true)
            .limit(to: 5)
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            self.todayPadoPosts = documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            self.lastTodayPadoFetchedDocument = documents.last

        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    func fetchFollowMorePosts() async {
        guard let lastDocument = lastFollowFetchedDocument else { return }
        
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()
        let twoDaysAgoTimestamp = Timestamp(date: twoDaysAgo)
        
        let query = db.collection("post")
            .whereField("created_Time", isGreaterThanOrEqualTo: twoDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .order(by: "heartsCount", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: 3)
            
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            
            self.lastFollowFetchedDocument = documents.last
            let documentsData = documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            .filter { post in
                followingUsers.contains(where: { $0 == post.ownerUid })
            }
            print("받아온 데이터")
            print(documentsData)
            print("여깄음")
            for documentData in documentsData {
                self.followingPosts.append(documentData)
            }

        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    func fetchTodayPadoMorePosts() async {
        guard let lastDocument = lastTodayPadoFetchedDocument else { return }
    
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
           // Date 객체를 Timestamp로 변환
        let sevenDaysAgoTimestamp = Timestamp(date: sevenDaysAgo)
        
        let query = db.collection("post")
            .whereField("created_Time", isGreaterThanOrEqualTo: sevenDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .order(by: "heartsCount", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: 3)
        
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            let documentsData = documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            self.lastTodayPadoFetchedDocument = documents.last
            for documentData in documentsData {
                self.todayPadoPosts.append(documentData)
            }
        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    private func cacheWatchedData() async {
        do {
            let documents = try await db.collection("users").document(userNameID).collection("watched").getDocuments()
            self.watchedPostIDs = Set(documents.documents.compactMap { $0.documentID })
        } catch {
            print("Error fetching watched data: \(error.localizedDescription)")
        }
    }
    
    func setupProfileImageURL(id: String) async -> String {
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").document(id).getDocument()
            
            guard let user = try? querySnapshot.data(as: User.self) else {
                print("Error: User data could not be decoded")
                return ""
            }
            
            guard let profileImage = user.profileImageUrl else { return "" }
            
            return profileImage
            
        } catch {
            print("Error fetching user: \(error)")
        }
        
        return ""
    }
    
  
    func watchedPost(_ story: Post) async {
        do {
            if let postID = story.id {
                try await db.collection("users").document(userNameID).collection("watched")
                    .document(postID).setData(["created_Time": story.created_Time,
                                               "watchedPost": postID])
                self.watchedPostIDs.insert(postID)
            }
        } catch {
            print("Error : \(error)")
        }
    }
    
    // 댓글 움직이는 로직
    func handleDragGestureChange(_ gesture: DragGesture.Value) {
        if dragStart == nil {
            dragStart = gesture.startLocation
        }
        let dragAmount = CGPoint(x: gesture.translation.width, y: gesture.translation.height)
        let initialPosition = dragStart ?? CGPoint.zero
        
        // 현재 드래그 중인 오브젝트에 따라 위치를 업데이트
        textPosition = CGPoint(x: initialPosition.x + dragAmount.x, y: initialPosition.y + dragAmount.y)
    }
    
    func handleDragGestureEnd() {
        dragStart = nil
    }
    
    // faceMoji 드래그 로직
    func handleFaceMojiDragChange(_ gesture: DragGesture.Value) {
        if dragStart == nil {
            dragStart = gesture.startLocation
        }
        let dragAmount = CGPoint(x: gesture.translation.width, y: gesture.translation.height)
        let initialPosition = dragStart ?? CGPoint.zero
        
        faceMojiPosition = CGPoint(x: initialPosition.x + dragAmount.x, y: initialPosition.y + dragAmount.y)
    }
    
    // faceMoji 드래그 종료 처리
    func handleFaceMojiDragEnd() {
        dragStart = nil
    }
    
    // 위 아래 제스쳐할 때 사라지거나 나타나는 로직
    func toggleHeaderVisibility(basedOnDragValue value: DragGesture.Value) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if value.translation.height > dragThreshold {
                isHeaderVisible = false
            } else if -value.translation.height > dragThreshold {
                isHeaderVisible = true
            }
        }
    }
}

// Timestamp 형식의 시간을 가져와서 날짜 및 시간 형식으로 변환
extension Timestamp {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-M-d"
        return formatter.string(from: self.dateValue())
    }
}

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
