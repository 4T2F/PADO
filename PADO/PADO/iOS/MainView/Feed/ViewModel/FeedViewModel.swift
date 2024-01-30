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
    
    @Published var feedProfileImageUrl: String = ""
    @Published var feedProfileID: String = ""
    @Published var selectedFeedTitle: String = ""
    @Published var selectedFeedTime: String = ""
    @Published var selectedFeedHearts: Int = 0
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var dragStart: CGPoint?
    let dragThreshold: CGFloat = 0
    
    init() {
        // Firestore의 `post` 컬렉션에 대한 실시간 리스너 설정
        findFollowingUsers()
    }
    
    private func findFollowingUsers() {
        listener = db.collection("users").document(userNameID).collection("following").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self, let documents = querySnapshot?.documents else {
                print("Error fetching following users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.followingUsers = documents.compactMap { $0.data()["followingID"] as? String }
            
            Task {
                await self.fetchFollowingPosts()
            }
        }
    }
    
    // Asynchronous wrapper for Firestore getDocuments
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

    // Get posts from following users asynchronously
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
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }
        
        // Create new story data
        self.updateStories()
        await self.selectFirstStory()
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
            Story(postID: post.id ?? "error", name: post.ownerUid, image: post.imageUrl, title: post.title, postTime: post.created_Time, hearts: post.hearts)
        }
    }
    
    // 첫 번째 스토리를 선택하는 함수
    @MainActor
    private func selectFirstStory() async {
        // storyData 배열의 첫 번째 스토리를 가져옴
        if let firstStory = self.stories.first {
            // 해당 스토리를 선택
            feedProfileID = firstStory.name
            
            selectedFeedTitle = firstStory.title
            selectedFeedTime = TimestampDateFormatter.formatDate(firstStory.postTime)
            selectedFeedHearts = firstStory.hearts
            selectStory(firstStory)
 
            let profileUrl = await setupProfileImageURL(id: firstStory.name)
     
            feedProfileImageUrl = profileUrl
        }
    }
    
    
    // 스토리 셀이 탭되었을 때 이를 업데이트하는 함수
    func selectPost(_ post: Post) {
        selectedPostImageUrl = post.imageUrl
    }
    
    // 스토리 선택 핸들러
    func selectStory(_ story: Story) {
        // 스토리의 이름과 게시물의 소유자 UID가 같은 경우 해당 게시물의 이미지 URL을 선택
        if let matchingPost = followingPosts.first(where: { $0.ownerUid == story.name }) {
            selectedPostImageUrl = matchingPost.imageUrl
            print("Selected post image URL: \(selectedPostImageUrl)")
            
            // 햅틱 피드백 생성
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            print("No matching post found for story: \(story.name)")
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
