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
    
    func deleteProfileURL() async {
        do {
            try await db.collection("users").document(userNameID).updateData([
                "profileImageUrl": FieldValue.delete()
            ])
            
            let imagesRef = storageRef.child("profile_image")
            try await imagesRef.child(userNameID).delete()
        } catch {
            print("프로필 이미지 초기화 오류 : \(error.localizedDescription)")
        }
    }
    
    func deleteBackURL() async {
        do {
            try await db.collection("users").document(userNameID).updateData([
                "backProfileImageUrl" : FieldValue.delete()
            ])
            
            let imagesRef = storageRef.child("back_image")
            try await imagesRef.child(userNameID).delete()
        } catch {
            print("배경 이미지 초기화 오류 : \(error.localizedDescription)")
        }
    }
}
