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
    @Published var post: [Post] = []
    
    private var db = Firestore.firestore()
    
    var dragStart: CGPoint?
    let dragThreshold: CGFloat = 0
    
    init() {
        // Firestore에서 게시물을 불러오는 함수 호출
        fetchPosts { [weak self] in
            // 게시물 로딩이 완료되면 첫 번째 스토리를 선택
            self?.selectFirstStory()
        }
    }
    
    // 첫 번째 스토리를 선택하는 함수
    private func selectFirstStory() {
        // storyData 배열의 첫 번째 스토리를 가져옴
        if let firstStory = storyData.first {
            // 해당 스토리를 선택
            selectStory(firstStory)
        }
    }
    
    // Firestore에서 게시물을 불러오는 함수, 완료 시 콜백
    func fetchPosts(completion: @escaping () -> Void = {}) {
        db.collection("post").getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion()
                return
            }
            
            // 불러온 게시물을 post 배열에 할당
            self?.post = querySnapshot!.documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            
            print("Fetched posts: \(self?.post ?? [])")
            // 콜백 함수 호출
            completion()
        }
    }
    
    // 스토리 셀이 탭되었을 때 이를 업데이트하는 함수
    func selectPost(_ post: Post) {
        selectedPostImageUrl = post.imageUrl
    }
    
    // 스토리 선택 핸들러
    func selectStory(_ story: Story) {
        // 스토리의 이름과 게시물의 소유자 UID가 같은 경우 해당 게시물의 이미지 URL을 선택
        if let matchingPost = post.first(where: { $0.ownerUid == story.name }) {
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
