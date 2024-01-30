//
//  UserUpdateViewModel.swift
//  PADO
//
//  Created by 황성진 on 1/25/24.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class UpdateUserData {
    static let shared = UpdateUserData()
    
    let db = Firestore.firestore()
    
    func updateUserData(initialUserData: [String: Any]) async throws {
                
        let updatedb = db.collection("users").document(userNameID)
        
        do {
            try await updatedb.updateData(initialUserData)
            print("Document successfully updated")
        } catch {
            print("Error updating document: \(error)")
        }
    }
}
