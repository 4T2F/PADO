//
//  UpdatePostData.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class UpdatePostData {
    static let shared = UpdatePostData()
    
    let db = Firestore.firestore()
    
    @MainActor
    func fetchPostById(postId: String) async -> Post? {
        do {
            let postRef = db.collection("post").document(postId)
            let postSnapshot = try await postRef.getDocument()
            let post = try postSnapshot.data(as: Post.self)
            return post
        } catch {
            print("Error fetching post with ID \(postId): \(error)")
            return nil
        }
    }
}
