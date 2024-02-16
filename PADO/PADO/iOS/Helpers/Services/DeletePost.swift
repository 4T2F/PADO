//
//  DeletePost.swift
//  PADO
//
//  Created by 황성진 on 2/17/24.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class DeletePost {
    static let shared = DeletePost()
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    func deletePost(postID: String) {
        
    }
    
    func deletePadoridePost(postID: String, storageFileName: String) async throws {
        try await db.collection("post").document(postID).collection("padoride").document(userNameID).delete()
        
        let imagesRef = storageRef.child("pado_ride")
        try await imagesRef.child(storageFileName).delete()
    }
    
}
