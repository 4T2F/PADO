//
//  ViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/23/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class FeedViewModel: ObservableObject {
    
    // MARK: - feed관련
    @Published var isShowingReportView = false
    @Published var isShowingCommentView = false
    @Published var isHeaderVisible = true
    @Published var textPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @Published var faceMojiPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    @Published var selectedStoryImage: String? = nil
    @Published var selectedPostImageUrl: String = ""
    @Published var followingPosts: [Post] = []
    @Published var stories: [Story] = []
    @Published var followingUsers: [String] = []
    @Published var watchedPostIDs: Set<String> = []
    
    @Published var feedProfileImageUrl: String = ""
    @Published var feedProfileID: String = ""
    @Published var selectedFeedTitle: String = ""
    @Published var selectedFeedTime: String = ""
    @Published var selectedFeedCheckHeart: Bool = false
    
    @Published var selectedFeedHearts: Int = 0
    @Published var selectedCommentCounts: Int = 0
    // MARK: - comment관련
    @Published var comments: [Comment] = []
    @Published var documentID: String = ""
    @Published var inputcomment: String = ""
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var dragStart: CGPoint?
    let dragThreshold: CGFloat = 0
    
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
                await self.cacheWatchedData()
                await self.fetchFollowingPosts()
            }
        }
    }
    
    // Firestore의 getDocuments에 대한 비동기 래퍼 함수
    @MainActor
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
    @MainActor
    private func fetchFollowingPosts() async {
        followingPosts.removeAll()
        
        for userID in followingUsers {
            let query = db.collection("post").whereField("ownerUid", isEqualTo: userID)
            do {
                let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
                let posts = documents.compactMap { document in
                    try? document.data(as: Post.self)
                }
                self.followingPosts.append(contentsOf: posts)
            } catch {
                print("포스트 가져오기 오류: \(error.localizedDescription)")
            }
        }
        
        // created_Time을 Date로 변환 후 내림차순 정렬
        self.followingPosts.sort { $0.created_Time.dateValue() > $1.created_Time.dateValue() }
        
        self.followingPosts.sort {
            !self.watchedPostIDs.contains($0.id ?? "") && self.watchedPostIDs.contains($1.id ?? "")
        }
        
        // 새로운 스토리 데이터 생성
        self.updateStories()
        await self.selectFirstStory()
    }
    
    @MainActor
    private func cacheWatchedData() async {
        do {
            let documents = try await db.collection("users").document(userNameID).collection("watched").getDocuments()
            self.watchedPostIDs = Set(documents.documents.compactMap { $0.documentID })
        } catch {
            print("Error fetching watched data: \(error.localizedDescription)")
        }
    }
    
    @MainActor
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
    
    // Firestore의 데이터를 기반으로 스토리 데이터 업데이트
    private func updateStories() {
        self.stories = self.followingPosts.map { post in
            Story(postID: post.id ?? "error", name: post.ownerUid, image: post.imageUrl, title: post.title, postTime: post.created_Time)

        }
    }
    
    // 첫 번째 스토리를 선택하는 함수
    @MainActor
    private func selectFirstStory() async {
        // storyData 배열의 첫 번째 스토리를 가져옴
        if let firstStory = self.stories.first {
            // 해당 스토리를 선택
            feedProfileID = firstStory.name
            selectedPostImageUrl = firstStory.image
            selectedFeedTitle = firstStory.title
            selectedFeedTime = TimestampDateFormatter.formatDate(firstStory.postTime)
//            selectedFeedHearts = firstStory.heartsCount
            documentID = firstStory.postID
            
            await selectStory(firstStory)
            let profileUrl = await setupProfileImageURL(id: firstStory.name)
            await getCommentsDocument()
            
            feedProfileImageUrl = profileUrl
        }
    }

    // 스토리 선택 핸들러
    @MainActor
    func selectStory(_ story: Story) async {
        // 스토리의 이름과 게시물의 소유자 UID가 같은 경우 해당 게시물의 이미지 URL을 선택
        
        selectedPostImageUrl = story.image
        print("Selected post image URL: \(selectedPostImageUrl)")
        
        selectedFeedCheckHeart = await checkHeartExists()
        await fetchHeartCommentCounts()
        await watchedPost(story)
        // 햅틱 피드백 생성
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    @MainActor
    func fetchHeartCommentCounts() async {
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
            self.selectedFeedHearts = data["heartsCount"] as? Int ?? 0
            self.selectedCommentCounts = data["commentCount"] as? Int ?? 0
        }
    }
    
    @MainActor
    func watchedPost(_ story: Story) async {
        do {
            try await db.collection("users").document(userNameID).collection("watched")
                .document(story.postID).setData(["created_Time": story.postTime,
                                                 "watchedPost": story.postID])
            self.watchedPostIDs.insert(story.postID)
            
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

// MARK: - Heart관련
extension FeedViewModel {
    @MainActor
    func addHeart() async {
        do {
            try await db.collection("post").document(documentID).collection("heart").document(userNameID).setData(["nameID": userNameID])
            // 그 다음, 'post' 문서의 'heartsCount'를 업데이트하는 트랜잭션을 시작합니다.
            _ = try await db.runTransaction({ (transaction, errorPointer) -> Any? in
                let postRef = self.db.collection("post").document(self.documentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldCount = postDocument.data()?["heartsCount"] as? Int else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve hearts count from snapshot \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return nil
                }
                
                transaction.updateData(["heartsCount": oldCount + 1], forDocument: postRef)
                return nil
            })
           
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func deleteHeart() async {
        do {
            try await db.collection("post").document(documentID).collection("heart").document(userNameID).delete()
            // 그 다음, 'post' 문서의 'heartsCount'를 업데이트하는 트랜잭션을 시작합니다.
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(self.documentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldCount = postDocument.data()?["heartsCount"] as? Int else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve hearts count from snapshot \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return nil
                }
                
                transaction.updateData(["heartsCount": oldCount - 1], forDocument: postRef)
                return nil
            })
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func checkHeartExists() async -> Bool {
        let heartDocRef = db.collection("post").document(documentID).collection("heart").document(userNameID)

        do {
            let documentSnapshot = try await heartDocRef.getDocument()
            // 문서가 존재하지 않으면 false, 존재하면 true 반환
            return documentSnapshot.exists
        } catch {
            print("Error checking heart document: \(error)")
            return false
        }
    }
    
}

// MARK: - Comment관련
extension FeedViewModel {
    // 포스트 - 포스팅제목 - 서브컬렉션 포스트에 접근해서 문서 댓글정보를 가져와 comments 배열에 할당
    @MainActor
    func getCommentsDocument() async {
        do {
            let querySnapshot = try await db.collection("post").document(documentID).collection("comment").order(by: "time", descending: false).getDocuments()
            self.comments = querySnapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
        } catch {
            print("Error fetching comments: \(error)")
        }
        print(comments)
    }
    //  댓글 작성 및 프로필 이미지 URL 반환
    func writeComment(inputcomment: String) async {
        let profileImageUrl = await setupProfileImageURL(id: userNameID)
        
        let initialPostData : [String: Any] = [
            "userID": userNameID,
            "content": inputcomment,
            "time": Timestamp(),
            "profileImageUrl": profileImageUrl
        ]
        await createCommentData(documentName: documentID, data: initialPostData)
    }
    
    @MainActor
    func createCommentData(documentName: String, data: [String: Any]) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
        
        let formattedDate = dateFormatter.string(from: Date())
        let formattedCommentTitle = userNameID+formattedDate
        
        do {
            try await db.collection("post").document(documentName).collection("comment").document(formattedCommentTitle).setData(data)
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(self.documentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldCount = postDocument.data()?["commentCount"] as? Int else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve hearts count from snapshot \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return nil
                }
                
                transaction.updateData(["commentCount": oldCount + 1], forDocument: postRef)
                return nil
            })
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
    }
}
