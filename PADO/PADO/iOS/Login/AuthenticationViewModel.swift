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
    @Published var phoneNumber = ""
    
    @Published var otpText = ""
    
    @Published var isLoading: Bool = false
    @Published var verificationCode: String = ""
    
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var isExisted = false
    
    @Published var currentUser: User?
    
    @AppStorage("userID") var userID: String = ""
    
    // 초기화
    init() {
        Task{ await initializeUser() }
    }
    
    // MARK: - 인증 관련
    func sendOtp() async {
        // OTP 발송
        guard !isLoading else { return }
        
        do {
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+82\(phoneNumber)", uiDelegate: nil) // 사용한 가능한 번호인지
            verificationCode = result
            isLoading = false
        } catch {
            handleError(error: error)
        }
    }
    
    func verifyOtp() async -> Bool {
        // Otp 검증
        guard !otpText.isEmpty else { return false }
        isLoading = true
        do {
            let _ = try await signInWithCredential()
            isLoading = false
            return true
        } catch {
            handleError(error: error)
            isLoading = false
            return false        
        }
    }
    
    private func signInWithCredential() async throws -> AuthDataResult {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
        return try await Auth.auth().signIn(with: credential)
    }
    
    func saveUserData(_ user: Firebase.User? = nil, data: [String: Any]? = nil) async {
        // 사용자 데이터 Firestore에 저장
        do {
            let uid = user?.uid ?? userID
            let userData = data ?? [
                "name": name,
                "date": year.date,
                "id": uid,
                "phoneNumber": "+82\(phoneNumber)"
            ]
            
            try await Firestore.firestore().collection("users").document(uid).setData(userData)
            
            if let user = user {
                currentUser = User(name: name, date: year.date)
            }
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        // 사용자 데이터 불러오기
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
    
    
    func checkPhoneNumberExists(phoneNumber: String) async  -> Bool{
          // 전화번호 중복 확인
          let userDB = Firestore.firestore().collection("users")
          let query = userDB.whereField("phoneNumber", isEqualTo: phoneNumber)
          
          do {
              let querySnapshot = try await query.getDocuments()
              print("documets: \(querySnapshot.documents)")
              if !querySnapshot.documents.isEmpty {
                  return true
              } else {
                  return false
              }
          } catch {
              print("Error: \(error)")
              return false
          }
      }


    
    // MARK: - 사용자 데이터 관리
    func initializeUser() async {
        // 사용자 초기화
        guard !userID.isEmpty else { return }
        await fetchUser()
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
        // 계정 삭제
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users").document(userID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Firestore 쿼리 처리
    func fetchUIDByPhoneNumber(phoneNumber: String) async {
        // 전화번호로 Firestore
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
    
    // MARK: - 오류 처리
    func handleError(error: Error) {
        // 오류 처리
        errorMessage = error.localizedDescription
        showAlert.toggle()
        isLoading = false
    }
    
}
