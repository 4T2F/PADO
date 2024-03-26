//
//  UpdateHeartData.swift
//  PADO
//
//  Created by 최동호 on 2/6/24.
//

import FirebaseFirestore
import FirebaseStorage

import SwiftUI

class UpdateHeartData {
    
    static let shared = UpdateHeartData()
    
    let db = Firestore.firestore()
    
    func addHeart(post: Post) async {
        guard !userNameID.isEmpty else { return }
        guard let postID = post.id else { return }
        do {
            try await db.collection("users").document(userNameID).collection("highlight").document(postID).setData(["documentID": postID,
                                                                                                                        "sendHeartTime": Timestamp()])
          
            var newHeartIDs = post.heartIDs
            guard !newHeartIDs.contains(userNameID) else { return }
            newHeartIDs.append(userNameID)
            try await db.collection("post").document(postID).updateData(["heartIDs": newHeartIDs])
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func deleteHeart(post: Post) async {
        guard !userNameID.isEmpty else { return }
        guard let postID = post.id else { return }
        do {
            try await db.collection("users").document(userNameID).collection("highlight").document(postID).delete()
            var newHeartIDs = post.heartIDs
            
            guard let index = newHeartIDs.firstIndex(of: userNameID) else { return }
            newHeartIDs.remove(at: index)
            try await db.collection("post").document(postID).updateData(["heartIDs": newHeartIDs])
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func checkHeartExists(post: Post) -> Bool {
        guard !userNameID.isEmpty else { return false }
        
        return post.heartIDs.contains(userNameID)
    }
}

