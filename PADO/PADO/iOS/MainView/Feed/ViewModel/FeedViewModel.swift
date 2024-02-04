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
    
    @Published var selectedStoryImage: String? = nil
    @Published var selectedPostImageUrl: String = ""
    @Published var followingPosts: [Post] = []
    @Published var followingUsers: [String] = []
    @Published var watchedPostIDs: Set<String> = []
    
    @Published var feedOwnerProfileImageUrl: String = ""
    @Published var feedOwnerProfileID: String = ""
    @Published var feedSurferProfileImageUrl: String = ""
    @Published var feedSurferProfileID: String = ""
    @Published var selectedFeedTitle: String = ""
    @Published var selectedFeedTime: String = ""
    @Published var selectedFeedCheckHeart: Bool = false
    @Published var postFetchLoading: Bool = false
    @Published var selectedPostID: String = ""
    @Published var selectedFeedHearts: Int = 0
    @Published var selectedCommentCounts: Int = 0
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
    
    // MARK: - FaceMoji 관련
    @Published var faceMojiImage: Image = Image(systemName: "photo")
    @Published var faceMojiUIImage: UIImage = UIImage()
    @Published var facemojies: [Facemoji] = []
    @Published var deleteFacemoji: Bool = false
    
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
        
        await self.selectFirstStory()
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
    
    // 첫 번째 스토리를 선택하는 함수
    private func selectFirstStory() async {
        // storyData 배열의 첫 번째 스토리를 가져옴
        if let firstStory = self.followingPosts.first,
           let postId = firstStory.id {
            // 해당 스토리를 선택
            feedOwnerProfileID = firstStory.ownerUid
            feedSurferProfileID = firstStory.surferUid
            selectedPostImageUrl = firstStory.imageUrl
            selectedFeedTitle = firstStory.title
            selectedFeedTime = TimestampDateFormatter.formatDate(firstStory.created_Time)
            documentID = postId
            await selectStory(firstStory)
            let ownerProfileUrl = await setupProfileImageURL(id: firstStory.ownerUid)
            let surferProfileUrl = await setupProfileImageURL(id: firstStory.surferUid)
            await getCommentsDocument()
            
            feedOwnerProfileImageUrl = ownerProfileUrl
            feedSurferProfileImageUrl = surferProfileUrl
        }
    }
    
    // 스토리 선택 핸들러
    func selectStory(_ story: Post) async {
        // 스토리의 이름과 게시물의 소유자 UID가 같은 경우 해당 게시물의 이미지 URL을 선택
        if let storyID = story.id {
            selectedPostID = storyID
        }
        selectedPostImageUrl = story.imageUrl
        print("Selected post image URL: \(selectedPostImageUrl)")
        
        selectedFeedCheckHeart = await checkHeartExists()
        await fetchHeartCommentCounts()
        await watchedPost(story)
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

// MARK: - Heart관련
extension FeedViewModel {
    func addHeart() async {
        // 햅틱 피드백 생성
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        do {
            try await db.collection("users").document(userNameID).collection("highlight").document(documentID).setData(["documentID": documentID,
                                                                                                                        "sendHeartTime": Timestamp()])
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
    
    func deleteHeart() async {
        do {
            try await db.collection("users").document(userNameID).collection("highlight").document(documentID).delete()
            
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
    
}

// MARK: - Comment관련
extension FeedViewModel {
    // 포스트 - 포스팅제목 - 서브컬렉션 포스트에 접근해서 문서 댓글정보를 가져와 comments 배열에 할당
    func getCommentsDocument() async {
        do {
            let querySnapshot = try await db.collection("post").document(documentID).collection("comment").order(by: "time", descending: false).getDocuments()
            self.comments = querySnapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
        } catch {
            print("Error fetching comments: \(error)")
        }
    }
    
    
    //  댓글 작성 및 프로필 이미지 URL 반환
    func writeComment(inputcomment: String) async {
        let imageUrl = await setupProfileImageURL(id: userNameID)
        
        print(imageUrl)
        
        let initialPostData : [String: Any] = [
            "userID": userNameID,
            "content": inputcomment,
            "time": Timestamp(),
        ]
        await createCommentData(documentName: documentID, data: initialPostData)
    }
    
    func createCommentData(documentName: String, data: [String: Any]) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
        
        let formattedDate = dateFormatter.string(from: Date())
        let formattedCommentTitle = userNameID+formattedDate
        
        do {
            // 포스트에서 댓글을 보여주기 위해 만들어줌
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
    
    // 댓글 삭제 함수에 commentID = 댓글 서브 컬렉션의 DocumentID 매개변수
    func deleteComment(commentID: String) async {
        do {
            // 포스트의 'comment' 컬렉션에서 특정 댓글 삭제
            try await db.collection("post").document(documentID).collection("comment").document(commentID).delete()
            
            // 그 다음, 'post' 문서의 'commentCount'를 업데이트하는 트랜잭션을 시작합니다.
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
                
                transaction.updateData(["commentCount": oldCount - 1], forDocument: postRef)
                return nil
            })

            // 성공적으로 삭제됐다는 메시지 출력
            print(commentID)
            print("댓글이 성공적으로 삭제되었습니다.")
        } catch {
            print("댓글 삭제 중 오류 발생: \(error.localizedDescription)")
        }
    }
}

// MARK: - FaceMoji 관련
extension FeedViewModel {
    // 페이스 모지를 스토리지, 스토어에 업로드
    func updateFaceMoji() async throws {
        let imageData = try await UpdateImageUrl.shared.updateImageUserData(
            uiImage: faceMojiUIImage,
            storageTypeInput: .facemoji,
            documentid: documentID,
            imageQuality: .lowforFaceMoji,
            surfingID: ""
        )
        
        print(imageData)
        
        try await db.collection("post").document(documentID).collection("facemoji").document(userNameID).updateData([
            "userID" : userNameID,
            "storagename" : "\(userNameID)-\(documentID)",
            "time" : Timestamp()
        ])
    }
    
    func getFaceMoji() async throws {
        do {
            let querySnapshot = try await db.collection("post").document(documentID).collection("facemoji").order(by: "time", descending: false).getDocuments()
            self.facemojies = querySnapshot.documents.compactMap { document in
                try? document.data(as: Facemoji.self)
            }
        } catch {
            print("Error fetching comments: \(error)")
        }
        print(facemojies)
    }
    
    func deleteFaceModji(storagefileName: String) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("facemoji/\(storagefileName)")
        
        do {
            try await db.collection("post").document(documentID).collection("facemoji").document(userNameID).delete()
            
            try await storageRef.delete()
        } catch {
            print("페이스모지 삭제 오류 : \(error.localizedDescription)")
        }
        
    }
}
