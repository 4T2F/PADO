//
//  CommentViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
final class CommentViewModel: ObservableObject {
    
    @Published var comments: [Comment] = []
    @Published var documentID: String = ""
    @Published var inputcomment: String = ""
    
    let db = Firestore.firestore()
    
    // MARK: 포스트 - 포스팅제목 - 서브컬렉션 포스트에 접근해서 문서 댓글정보를 가져와 comments 배열에 할당
    func getCommentsDocument() async {
        do {
            let querySnapshot = try await db.collection("post").document(documentID).collection("comment").getDocuments()
            self.comments = querySnapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
        } catch {
            print("Error fetching comments: \(error)")
        }
    }
    // MARK: - 댓글 작성
    func writeComment(inputcomment: String) async {
        // 게시 요청 관련 로직 추가
        let initialPostData : [String: Any] = [
            "userID": userNameID,
            "content": inputcomment,
            "time": Timestamp()
       ]
        await createCommentData(documentName: documentID, data: initialPostData)
    }
    
    func createCommentData(documentName: String, data: [String: Any]) async {
        do {
            try await db.collection("post").document(documentName).collection("comment").document(userNameID).setData(data)
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
    }
}
