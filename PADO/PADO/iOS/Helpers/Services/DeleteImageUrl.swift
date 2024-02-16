//
//  DeleteImageUrl.swift
//  PADO
//
//  Created by 황성진 on 2/15/24.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class DeleteImageUrl {
    static let shared = DeleteImageUrl()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    private init() { }
    
    func deleteProfileURL() async throws {
        try await db.collection("users").document(userNameID).updateData([
            "profileImageUrl": FieldValue.delete()
        ])
        
        let imagesRef = storageRef.child("profile_image")
        try await imagesRef.child(userNameID).delete()
    }
    
    func deleteBackURL() async throws {
        try await db.collection("users").document(userNameID).updateData([
            "backProfileImageUrl" : FieldValue.delete()
        ])
        
        let imagesRef = storageRef.child("back_image")
        try await imagesRef.child(userNameID).delete()
    }
    
    
}
