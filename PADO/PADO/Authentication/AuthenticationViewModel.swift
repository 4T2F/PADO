//
//  AuthenticationViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI
import Firebase

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var year = Year(day: "", month: "", year: "")
    @Published var country: Country = Country(isoCode: "KR")
    @Published var phoneNumber = ""
    
    @Published var otpText = ""
    
    @Published var navigationTag: String?
    
    @Published var isLoading: Bool = false
    @Published var verificationCode: String = ""
    
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var isExisted = false
    
    @Published var currentUser: User?
    
    @AppStorage("userID") var userID: String = ""
    
    init() {
        Task{
            print(userID)
            await fetchUser()

        }
        
    }
    
    func checkPhoneNumberExists(phoneNumber: String) async {
        let userDB = Firestore.firestore().collection("users")
        let query = userDB.whereField("phoneNumber", isEqualTo: phoneNumber)
        
        do {
            let querySnapshot = try await query.getDocuments()
            print("documets: \(querySnapshot.documents)")
            if !querySnapshot.documents.isEmpty {
                isExisted = false
            } else {
                isExisted = true
            }
            await sendOtp()
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    func sendOtp() async {
        guard !isLoading else { return }
        
        do {
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(country.phoneCode)\(phoneNumber)", uiDelegate: nil) // 사용한 가능한 번호인지
            verificationCode = result
            navigationTag = "VERIFICATION"
            isLoading = false
        } catch {
            handleError(error: error)
        }
    }
    
    func handleError(error: Error) {
        errorMessage = error.localizedDescription
        showAlert.toggle()
        isLoading = false
    }
    
    func verifyOtp() async {
        do {
            isLoading = true
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
            let result = try await Auth.auth().signIn(with: credential)
            let db = Firestore.firestore()
            
            try await db.collection("users").document(result.user.uid).setData([
                "name": name,
                "date": year.date,
                "id": result.user.uid,
                "phoneNumber": "+\(country.phoneCode)\(phoneNumber)"
            ])

            currentUser = User(name: name, date: year.date)
            isLoading = false
            print(result.user.uid)
        } catch {
            handleError(error: error)
        }
    }
    
    func fetchUIDByPhoneNumber(phoneNumber: String) async {
        let usersCollection = Firestore.firestore().collection("users")
        let query = usersCollection.whereField("phoneNumber", isEqualTo: phoneNumber)
        
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {
                self.userID = document.documentID
            }
        } catch {
            print("Error fetching user by phone number: (error)")
        }
    }
    
    func fetchUser() async {
        guard !userID.isEmpty else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
            print("UserID: \(userID)")
            print("Snapshot: \(String(describing: snapshot.data()))")
            
            guard let user = try? snapshot.data(as: User.self) else {
                print("Error: User data could not be decoded")
                return
            }
            self.currentUser = user
            print("Current User: \(String(describing: currentUser))")
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    
    func signOut() {
        do {
            // 로그아웃 구현 필요
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users").document(userID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    
    func saveUserData(data: [String: Any]) async {
        do {
            try await Firestore.firestore().collection("users").document(userID).updateData(data)
        } catch {
            handleError(error: error)
        }
    }
}

