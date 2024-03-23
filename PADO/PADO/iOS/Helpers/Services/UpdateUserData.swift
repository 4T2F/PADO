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
        guard !userNameID.isEmpty else { return }
                
        let updatedb = db.collection("users").document(userNameID)
        
        do {
            try await updatedb.updateData(initialUserData)
            print("Document successfully updated")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func getOthersProfileDatas(id: String) async -> User? {
        guard !id.isEmpty else { return nil }
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").document(id).getDocument()
            
            guard let user = try? querySnapshot.data(as: User.self) else {
                print("Error: User data could not be decoded")
                return nil
            }
            return user
        } catch {
            print("Error fetching user: \(error)")
        }
        return nil
    }
}
