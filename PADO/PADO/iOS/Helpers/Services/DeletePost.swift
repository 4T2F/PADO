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
    
    func deletePost(postID: String, postOwnerID: String, sufferID: String) async throws {
        try await db.collection("post").document(postID).delete()
        try await db.collection("users").document(postOwnerID).collection("mypost").document(postID).delete()
        //postOwnerID 는 오너 아이디가 들어감
        try await db.collection("users").document(sufferID).collection("sendpost").document(postID).delete()
        
        let imageRef = storageRef.child("post")
        try await imageRef.child(postID).delete()
    }
    
    func deletePadoridePost(postID: String, storageFileName: String, subID: String) async throws {
        try await db.collection("post").document(postID).collection("padoride").document(subID).delete()
        
        let imagesRef = storageRef.child("pado_ride")
        try await imagesRef.child(storageFileName).delete()
    }
    
}
