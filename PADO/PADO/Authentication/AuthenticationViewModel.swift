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
    
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    
    static let shared = AuthenticationViewModel()
//    
//    init() {
//            userSession = Auth.auth().currentUser
//            fetchUser()
//        }
    

    func sendOtp() async {
        guard !isLoading else { return }
      
        do {
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(country.phoneCode)\(phoneNumber)", uiDelegate: nil)
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
                "fullname": name,
                "date": year.date,
                "id": result.user.uid,
                "phoneNumber": "+\(country.phoneCode)\(phoneNumber)"
            ])
            
            userSession = result.user
            currentUser = User(name: name, date: year.date)
            isLoading = false
            print(result.user.uid)
        } catch {
            handleError(error: error)
        }
    }
    
    func signOut() {
        do {
            userSession = nil
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        guard let uid = userSession?.uid else { return }
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users").document(uid).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let user = try? snapshot?.data(as: User.self) else {
                print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.currentUser = user
        }
    }
    
    func saveUserData(data: [String: Any]) async {
        guard let userId = userSession?.uid else { return }
        
        do {
            try await Firestore.firestore().collection("users").document(userId).updateData(data)
        } catch {
            handleError(error: error)
        }
    }
}

