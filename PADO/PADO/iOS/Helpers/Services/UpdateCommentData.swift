//
//  UpdateCommentData.swift
//  PADO
//
//  Created by 최동호 on 2/6/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class UpdateCommentData {
    
    let db = Firestore.firestore()
    // 포스트 - 포스팅제목 - 서브컬렉션 포스트에 접근해서 문서 댓글정보를 가져와 comments 배열에 할당
 
    func getCommentsDocument(post: Post) async -> [Comment]? {
        guard let postID = post.id else { return nil }
        do {
            let querySnapshot = try await db.collection("post").document(postID).collection("comment").order(by: "time", descending: false).getDocuments()
            let comments = querySnapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
            print(comments)
            let filteredComments = filterBlockedComments(comments: comments)
            
            return filteredComments
        } catch {
            print("Error fetching comments: \(error)")
        }
        return nil
    }
    
    //  댓글 작성 및 프로필 이미지 URL 반환
    func writeComment(post: Post, 
                      imageUrl: String,
                      inputcomment: String) async {
        
        guard !userNameID.isEmpty else { return }
        
        let initialPostData : [String: Any] = [
            "userID": userNameID,
            "content": inputcomment,
            "time": Timestamp(),
            "heartIDs": [],
            "replyComments": []
        ]
        await createCommentData(post: post,
                                data: initialPostData)
    }
    
    func createCommentData(post: Post, data: [String: Any]) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
        
        let formattedDate = dateFormatter.string(from: Date())
        let formattedCommentTitle = userNameID+formattedDate
        guard let postID = post.id else { return }
        do {
            // 포스트에서 댓글을 보여주기 위해 만들어줌
            try await db.collection("post").document(postID).collection("comment").document(formattedCommentTitle).setData(data)
            
            try await db.collection("post").document(postID).updateData(["commentCount": post.commentCount + 1])
            
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
    }
    
    // 댓글 삭제 함수에 commentID = 댓글 서브 컬렉션의 DocumentID 매개변수
    func deleteComment(post: Post, commentID: String) async {
        guard let postID = post.id else { return }
        do {
            // 포스트의 'comment' 컬렉션에서 특정 댓글 삭제
            try await db.collection("post").document(postID).collection("comment").document(commentID).delete()
            
            try await db.collection("post").document(postID).updateData(["commentCount": post.commentCount-1])
            
            // 성공적으로 삭제됐다는 메시지 출력
            print(commentID)
            print("댓글이 성공적으로 삭제되었습니다.")
        } catch {
            print("댓글 삭제 중 오류 발생: \(error.localizedDescription)")
        }
    }
}

extension UpdateCommentData {
    private func filterBlockedComments(comments: [Comment]) -> [Comment] {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        let filteredComments = comments.filter { comment in
            !blockedUserIDs.contains(comment.userID)
        }
        
        return filteredComments
    }
}
