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
        try await db.collection("users").document(sufferID).collection("sendpost").document(postID).delete()
        
        let imageRef = storageRef.child("post")
        try await imageRef.child(postID).delete()
    }
    
    func deletePadoridePost(postID: String, storageFileName: String, subID: String) async throws {
        try await db.collection("post").document(postID).collection("padoride").document(subID).delete()
        
        let imagesRef = storageRef.child("pado_ride")
        try await imagesRef.child(storageFileName).delete()
    }
    
    func deleteForBlock(blockUserId: String) async throws {
        let postImageRef = storageRef.child("post")
        let padorideImaegRef = storageRef.child("pado_ride")
        
        // 내 유저 컬렉션에서 내 포스트에 접근해서 삭제
        let myPostDocument = try await db.collection("user").document(userNameID).collection("mypost")
            .whereField("surferID", isEqualTo: blockUserId).getDocuments()
        
        for myPostData in myPostDocument.documents {
            let imageDelete = try await db.collection("post").document(myPostData.documentID).collection("padoride").getDocuments()
            
            for imageData in imageDelete.documents {
                if let storageFileName = imageData.data()["storageFileName"] as? String {
                    try await padorideImaegRef.child(storageFileName).delete()
                }
            }
            
            try await db.collection("post").document(myPostData.documentID).delete()
            try await postImageRef.child(myPostData.documentID).delete()
            try await db.collection("user").document(userNameID).collection("mypost").document(myPostData.documentID).delete()
        }
        
        // 내 유저 컬렉션에서 보낸 포스트에 접근해서 삭제
        let sendPostDocument = try await db.collection("user").document(userNameID).collection("sendpost")
            .whereField("surfingID", isEqualTo: blockUserId).getDocuments()
        
        for sendPostData in sendPostDocument.documents {
            let imageDelete = try await db.collection("post").document(sendPostData.documentID).collection("padoride").getDocuments()
            
            for imageData in imageDelete.documents {
                if let storageFileName = imageData.data()["storageFileName"] as? String {
                    try await padorideImaegRef.child(storageFileName).delete()
                }
            }
            
            try await db.collection("post").document(sendPostData.documentID).delete()
            try await postImageRef.child(sendPostData.documentID).delete()
            try await db.collection("user").document(userNameID).collection("sendpost").document(sendPostData.documentID).delete()
        }
        
        // 상대방 유저 컬렉션에서 내가 보낸 포스트를 삭제
        let blockUserMypost = try await db.collection("users").document(blockUserId).collection("mypost")
            .whereField("surferID", isEqualTo: userNameID).getDocuments()
        for blockUserData in blockUserMypost.documents {
            try await db.collection("users").document(blockUserId).collection("mypost").document(blockUserData.documentID).delete()
        }
        
        // 상대방 유저 컬렉션에서 나한테 보낸 포스트를 삭제
        let blockUserSendpost = try await db.collection("users").document(blockUserId).collection("sendpost")
            .whereField("surfingID", isEqualTo: userNameID).getDocuments()
        for blockUserData in blockUserSendpost.documents {
            try await db.collection("users").document(blockUserId).collection("sendpost").document(blockUserData.documentID).delete()
        }
    }
}
