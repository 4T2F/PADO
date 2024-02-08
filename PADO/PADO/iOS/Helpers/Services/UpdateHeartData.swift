//
//  UpdateHeartData.swift
//  PADO
//
//  Created by 최동호 on 2/6/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class UpdateHeartData {
    
    let db = Firestore.firestore()
    
    func addHeart(documentID: String) async {
        // 햅틱 피드백 생성
        
        do {
            try await db.collection("users").document(userNameID).collection("highlight").document(documentID).setData(["documentID": documentID,
                                                                                                                        "sendHeartTime": Timestamp()])
            try await db.collection("post").document(documentID).collection("heart").document(userNameID).setData(["nameID": userNameID])
            // 그 다음, 'post' 문서의 'heartsCount'를 업데이트하는 트랜잭션을 시작합니다.
            _ = try await db.runTransaction({ (transaction, errorPointer) -> Any? in
                let postRef = self.db.collection("post").document(documentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldCount = postDocument.data()?["heartsCount"] as? Int else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve hearts count from snapshot \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return nil
                }
                
                transaction.updateData(["heartsCount": oldCount + 1], forDocument: postRef)
                return nil
            })
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func deleteHeart(documentID: String) async {
        do {
            try await db.collection("users").document(userNameID).collection("highlight").document(documentID).delete()
            
            try await db.collection("post").document(documentID).collection("heart").document(userNameID).delete()
            // 그 다음, 'post' 문서의 'heartsCount'를 업데이트하는 트랜잭션을 시작합니다.
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(documentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldCount = postDocument.data()?["heartsCount"] as? Int else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve hearts count from snapshot \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return nil
                }
                
                transaction.updateData(["heartsCount": oldCount - 1], forDocument: postRef)
                return nil
            })
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func checkHeartExists(documentID: String) async -> Bool {
        let heartDocRef = db.collection("post").document(documentID).collection("heart").document(userNameID) // 로그아웃할때 여기서 튕김
        
        do {
            let documentSnapshot = try await heartDocRef.getDocument()
            // 문서가 존재하지 않으면 false, 존재하면 true 반환
            return documentSnapshot.exists
        } catch {
            print("Error checking heart document: \(error)")
            return false
        }
    }
    
}
