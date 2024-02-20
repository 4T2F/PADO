//
//  UpdatePhotomojiData.swift
//  PADO
//
//  Created by 최동호 on 2/6/24.
//
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

class UpdateFacemojiData {
    let db = Firestore.firestore()
    
    func getFaceMoji(documentID: String) async throws -> [Facemoji]? {
        do {
            let querySnapshot = try await db.collection("post").document(documentID).collection("facemoji").order(by: "time", descending: false).getDocuments()
            let facemojies = querySnapshot.documents.compactMap { document in
                try? document.data(as: Facemoji.self)
            }
            return filterBlockedFaceMoji(facemojies: facemojies)
        } catch {
            print("Error fetching comments: \(error)")
        }
        return nil
    }
    
    
    func deleteFaceMoji(documentID: String, storagefileName: String) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("facemoji/\(storagefileName)")
        
        guard !userNameID.isEmpty else { return }
        do {
            try await db.collection("post").document(documentID).collection("facemoji").document(userNameID).delete()
            
            try await storageRef.delete()
        } catch {
            print("포토모지 삭제 오류 : \(error.localizedDescription)")
        }
    }
    
    func updateEmoji(documentID: String, emoji: String) async {
        guard !userNameID.isEmpty else { return }
        
        do {
            try await db.collection("post").document(documentID).collection("facemoji").document(userNameID).updateData([
                "emoji" : emoji
            ])
        } catch {
            print("파이어베이스에 이모지 업로드 오류 : \(error.localizedDescription)")
        }
    }
    
    func updateFaceMoji(cropMojiUIImage: UIImage, documentID: String, selectedEmoji: String) async throws {
        guard !userNameID.isEmpty else { return }
        
        let imageData = try await UpdateImageUrl.shared.updateImageUserData(
            uiImage: cropMojiUIImage,
            storageTypeInput: .facemoji,
            documentid: documentID,
            imageQuality: .lowforFaceMoji,
            surfingID: ""
        )
        
        print(imageData)
        
        try await db.collection("post").document(documentID).collection("facemoji").document(userNameID).updateData([
            "userID" : userNameID,
            "storagename" : "\(userNameID)-\(documentID)",
            "time" : Timestamp(),
            "emoji" : selectedEmoji
        ])
    }
    
}

extension UpdateFacemojiData {
    private func filterBlockedFaceMoji(facemojies: [Facemoji]) -> [Facemoji] {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return facemojies.filter { facemoji in
            !blockedUserIDs.contains(facemoji.userID)
        }
    }
}
