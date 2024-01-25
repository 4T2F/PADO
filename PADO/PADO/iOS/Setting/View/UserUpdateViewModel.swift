//
//  UserUpdateViewModel.swift
//  PADO
//
//  Created by 황성진 on 1/25/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore


class UserUpdateViewModel: ObservableObject {
    static let shared = UserUpdateViewModel()
    
    let db = Firestore.firestore()
    
    let initialUserData: [String: Any] = [:]
    
    func updateUserData(initialUserData: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
                
        let updatedb = db.collection("users").document(uid)
        
        do {
            try await updatedb.updateData(initialUserData)
            print("Document successfully updated")
        } catch {
            print("Error updating document: \(error)")
        }
        
    }
}
