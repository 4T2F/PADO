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
            try await db.collection("users").document(userNameID).collection("following").document(id).setData(["followingID": id, 
                                                                                                                "status": true,
                                                                                                                "followTime": Timestamp()])
            try await db.collection("users").document(id).collection("follower").document(userNameID).setData(["followerID": userNameID])
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func unfollowUser(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).updateData(["status": false])
            try await db.collection("users").document(id).collection("follower").document(userNameID).delete()
            try await db.collection("users").document(id).collection("surfer").document(userNameID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func removeFollower(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("follower").document(id).delete()
            try await db.collection("users").document(id).collection("following").document(userNameID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func directUnfollowUser(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("following").document(id).delete()
            try await db.collection("users").document(id).collection("follower").document(userNameID).delete()
            try await db.collection("users").document(id).collection("surfer").document(userNameID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func registerSurfer(id: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("follower").document(id).delete()
            try await db.collection("users").document(userNameID).collection("surfer").document(id).setData(["surferID": id])
            try await db.collection("users").document(id).collection("surfing").document(userNameID).setData(["surfingID": userNameID])
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
    
    func fetchFollowStatusData() {
        db.collection("users").document(userNameID).collection("following")
            .whereField("status", isEqualTo: false)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // 각 문서에 대해 삭제 연산을 수행합니다.
                        document.reference.delete { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                }
            }
    }
    
    func checkFollowStatus(id: String) async -> Bool {
        let db = Firestore.firestore()
        let query = db.collection("users").document(userNameID).collection("following").whereField("followingID", isEqualTo: id)
        
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {
                if let status = document.data()["status"] as? Bool {
                    return status
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        return false
    }
    
}
