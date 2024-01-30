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
    
    let db = Firestore.firestore()
    
    // 포스트 - 포스팅제목 - 서브컬렉션 포스트에 접근해서 문서 댓글정보를 가져와 comments 배열에 할당
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
}
