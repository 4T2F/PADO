////
////  CommentViewModel.swift
////  PADO
////
////  Created by 강치우 on 1/22/24.
////
//
//import Firebase
//import FirebaseFirestore
//import SwiftUI
//
//@MainActor
//final class CommentViewModel: ObservableObject {
//    
//    @Published var comments: [Comment] = []
//    @Published var documentID: String = ""
//    @Published var inputcomment: String = ""
//    
//    let db = Firestore.firestore()
//    
//    // MARK: 포스트 - 포스팅제목 - 서브컬렉션 포스트에 접근해서 문서 댓글정보를 가져와 comments 배열에 할당
//    func getCommentsDocument() async {
//        do {
//            let querySnapshot = try await db.collection("post").document(documentID).collection("comment").getDocuments()
//            self.comments = querySnapshot.documents.compactMap { document in
//                try? document.data(as: Comment.self)
//            }
//        } catch {
//            print("Error fetching comments: \(error)")
//        }
//    }
//    // MARK: - 댓글 작성
//    func writeComment(inputcomment: String) async {
//        let initialPostData : [String: Any] = [
//            "userID": userNameID,
//            "content": inputcomment,
//            "time": Timestamp()
//       ]
//        await createCommentData(documentName: documentID, data: initialPostData)
//    }
//    
//    func createCommentData(documentName: String, data: [String: Any]) async {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
//        
//        let formattedDate = dateFormatter.string(from: Date())
//        let formattedCommentTitle = userNameID+formattedDate
//        
//        do {
//            try await db.collection("post").document(documentName).collection("comment").document(formattedCommentTitle).setData(data)
//        } catch {
//            print("Error saving post data: \(error.localizedDescription)")
//        }
//    }
//}
