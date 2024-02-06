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
    func getCommentsDocument(postID: String) async -> [Comment]? {
        print(postID)
        do {
            let querySnapshot = try await db.collection("post").document(postID).collection("comment").order(by: "time", descending: false).getDocuments()
            let comments = querySnapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
            print(comments)
            return comments
        } catch {
            print("Error fetching comments: \(error)")
        }
        
        return nil
    }
    
    //  댓글 작성 및 프로필 이미지 URL 반환
    func writeComment(documentID: String, imageUrl: String, inputcomment: String) async {
        
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
                let postRef = self.db.collection("post").document(documentName)
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
    func deleteComment(documentID: String, commentID: String) async {
        do {
            // 포스트의 'comment' 컬렉션에서 특정 댓글 삭제
            try await db.collection("post").document(documentID).collection("comment").document(commentID).delete()
            
            // 그 다음, 'post' 문서의 'commentCount'를 업데이트하는 트랜잭션을 시작합니다.
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(documentID)
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
