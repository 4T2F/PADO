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
    static let shared = UpdateFollowData()
    
    let db = Firestore.firestore()
    
    func followUser(id: String) async {
        guard !userNameID.isEmpty else { return }
        
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).setData(["followingID": id,
                                                                                                                "status": true,
                                                                                                                "followTime": Timestamp()])
            try await db.collection("users").document(id).collection("follower").document(userNameID).setData(["followerID": userNameID])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func unfollowUser(id: String) async {
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).updateData(["status": false])
           
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func removeFollower(id: String) async {
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("users").document(userNameID).collection("follower").document(id).delete()
            try await db.collection("users").document(id).collection("following").document(userNameID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func directUnfollowUser(id: String) async {
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).delete()
            try await db.collection("users").document(userNameID).collection("surfing").document(id).delete()
            
            try await db.collection("users").document(id).collection("follower").document(userNameID).delete()
            try await db.collection("users").document(id).collection("surfer").document(userNameID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func userUnfollowMe(id: String) async {
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("users").document(id).collection("following").document(userNameID).delete()
            try await db.collection("users").document(id).collection("surfing").document(userNameID).delete()
            
            try await db.collection("users").document(userNameID).collection("follower").document(id).delete()
            try await db.collection("users").document(userNameID).collection("surfer").document(id).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func registerSurfer(id: String) async {
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("users").document(userNameID).collection("follower").document(id).delete()
            try await db.collection("users").document(userNameID).collection("surfer").document(id).setData(["surferID": id])
            try await db.collection("users").document(id).collection("surfing").document(userNameID).setData(["surfingID": userNameID,
                                                                                                              "status": true])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func removeSurfer(id: String) async {
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("users").document(userNameID).collection("surfer").document(id).delete()
            try await db.collection("users").document(id).collection("surfing").document(userNameID).delete()
            try await db.collection("users").document(userNameID).collection("follower").document(id).setData(["followerID": id])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func fetchFollowStatusData() async {
        
        guard !userNameID.isEmpty else { return }
        
        let querySnapshot = db.collection("users").document(userNameID).collection("following")
            .whereField("status", isEqualTo: false)
        
        do {
            let snapshot = try await querySnapshot.getDocuments()
            
            for document in snapshot.documents {
                let selectID = document.data()["followingID"] as! String
                try await db.collection("users").document(selectID).collection("follower").document(userNameID).delete()
                try await db.collection("users").document(selectID).collection("surfer").document(userNameID).delete()
                try await db.collection("users").document(userNameID).collection("surfing").document(selectID).delete()
                
                try await document.reference.delete()
            }
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
        
    }
    
    func checkFollowingStatus(id: String) -> Bool {
        return userFollowingIDs.contains(id)
    }
}
