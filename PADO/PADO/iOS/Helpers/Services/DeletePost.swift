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
    
    func deletePost(postID: String, postOwnerID: String, sufferID: String) async {
        
        do {
            let commentQuery = try await db.collection("post").document(postID).collection("comment").getDocuments()
            
            let padoRideQuery = try await db.collection("post").document(postID).collection("padoride").getDocuments()
            
            let facemojiQuery = try await db.collection("post").document(postID).collection("facemoji").getDocuments()
            
            for query in commentQuery.documents {
                try await db.collection("post").document(postID).collection("comment").document(query.documentID).delete()
            }
            
            for query in padoRideQuery.documents {
                let padoRideImageRef = storageRef.child("pado_ride")
                try await padoRideImageRef.child(query.data()["storageFileName"] as! String).delete()
                try await db.collection("post").document(postID).collection("padoride").document(query.documentID).delete()
            }
            
            for query in facemojiQuery.documents {
                let facemojiImageRef = storageRef.child("facemoji")
                try await facemojiImageRef.child(query.data()["storagename"] as! String).delete()
                try await db.collection("post").document(postID).collection("facemoji").document(query.documentID).delete()
            }
            
            try await db.collection("post").document(postID).delete()
            try await db.collection("users").document(postOwnerID).collection("mypost").document(postID).delete()
            try await db.collection("users").document(sufferID).collection("sendpost").document(postID).delete()
            
            let imageRef = storageRef.child("post")
            try await imageRef.child(postID).delete()
        } catch {
            print("게시글 삭제 오류: \(error.localizedDescription)")
        }
    }
    
    func deletePost(postID: String) async {
        do {
            let commentQuery = try await db.collection("post").document(postID).collection("comment").getDocuments()
            
            let padoRideQuery = try await db.collection("post").document(postID).collection("padoride").getDocuments()
            
            let facemojiQuery = try await db.collection("post").document(postID).collection("facemoji").getDocuments()
            
            for query in commentQuery.documents {
                try await db.collection("post").document(postID).collection("comment").document(query.documentID).delete()
            }
            
            for query in padoRideQuery.documents {
                let padoRideImageRef = storageRef.child("pado_ride")
                try await padoRideImageRef.child(query.data()["storageFileName"] as! String).delete()
                try await db.collection("post").document(postID).collection("padoride").document(query.documentID).delete()
            }
            
            for query in facemojiQuery.documents {
                let facemojiImageRef = storageRef.child("facemoji")
                try await facemojiImageRef.child(query.data()["storagename"] as! String).delete()
                try await db.collection("post").document(postID).collection("facemoji").document(query.documentID).delete()
            }
            
            try await db.collection("post").document(postID).delete()
            
            let imageRef = storageRef.child("post")
            try await imageRef.child(postID).delete()
        } catch {
            print("게시글 삭제 오류: \(error.localizedDescription)")
        }
    }
    
    func deletePadoridePost(postID: String, storageFileName: String, subID: String) async throws {
        try await db.collection("post").document(postID).collection("padoride").document(subID).delete()
        
        let imagesRef = storageRef.child("pado_ride")
        try await imagesRef.child(storageFileName).delete()
    }
    
    func deleteForBlock(blockUserId: String) async {
        var deletePostLists = Set<String>()
        do {
            // 내 유저 컬렉션에서 내 포스트에 접근해서 삭제
            let myPostDocument = try await db.collection("users").document(userNameID).collection("mypost")
                .whereField("surferID", isEqualTo: blockUserId).getDocuments()
            
            for myPostData in myPostDocument.documents {
                deletePostLists.insert(myPostData.documentID)
                try await db.collection("users").document(userNameID).collection("mypost").document(myPostData.documentID).delete()
            }
            
            // 내 유저 컬렉션에서 보낸 포스트에 접근해서 삭제
            let sendPostDocument = try await db.collection("users").document(userNameID).collection("sendpost")
                .whereField("surfingID", isEqualTo: blockUserId).getDocuments()
            
            for sendPostData in sendPostDocument.documents {
                deletePostLists.insert(sendPostData.documentID)
                try await db.collection("users").document(userNameID).collection("sendpost").document(sendPostData.documentID).delete()
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
            
            for postId in deletePostLists {
                await deletePost(postID: postId)
            }
        } catch {
            print("게시글 삭제 오류: \(error.localizedDescription)")
        }
    }
    
    
}
