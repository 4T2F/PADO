//
//  UpdateFollowData.swift
//  PADO
//
//  Created by 최동호 on 1/30/24.
//
import Firebase
import FirebaseFirestoreSwift
import Foundation

class UpdateFollowData {
    
    let db = Firestore.firestore()
    
    func followUser(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).setData(["followingID": id])
            try await db.collection("users").document(id).collection("follower").document(userNameID).setData(["followerID": userNameID])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func unfollowUser(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).delete()
            try await db.collection("users").document(id).collection("follower").document(userNameID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func registerSurfer(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("follower").document(id).delete()
            try await db.collection("users").document(userNameID).collection("surfer").document(id).setData(["surferID": id])
            try await db.collection("users").document(id).collection("surfer").document(userNameID).setData(["surfingID": userNameID])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func removeSurfer(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("surfer").document(id).delete()
            try await db.collection("users").document(id).collection("surfing").document(userNameID).delete()
            try await db.collection("users").document(userNameID).collection("follower").document(id).setData(["followerID": id])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func checkFollowStatus(id: String) async -> Bool {
        // ID 중복 확인
        let db = Firestore.firestore()
        let query = db.collection("users").document(userNameID).collection("following").whereField("followingID", isEqualTo: id)
        
        do {
            let querySnapshot = try await query.getDocuments()
            return querySnapshot.documents.isEmpty
        } catch {
            print("Error checking for duplicate ID: \(error)")
            return true
        }
    }
}
