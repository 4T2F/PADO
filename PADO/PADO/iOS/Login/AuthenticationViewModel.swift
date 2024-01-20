//
//  AuthenticationViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI
import Firebase
import PhotosUI

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    @Published var nameID = ""
    @Published var year = Year(day: "", month: "", year: "")
    @Published var phoneNumber = ""
    
    @Published var otpText = ""
    
    @Published var isLoading: Bool = false
    @Published var verificationCode: String = ""
    
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var isExisted = false
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage()
            }
        }
    }
    @Published var profileImageUrl: Image?
    private var uiImage: UIImage?
    
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
                "nameID": nameID,
                "date": year.date,
                "id": uid,
                "phoneNumber": "+82\(phoneNumber)"
            ]
            
            try await Firestore.firestore().collection("users").document(uid).setData(userData)
        
            currentUser = User(nameID: nameID, date: year.date, phoneNumber: phoneNumber)

        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
   
   
    func checkPhoneNumberExists(phoneNumber: String) async  -> Bool {
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
    
    // MARK: - 오류 처리
    func handleError(error: Error) {
        // 오류 처리
        errorMessage = error.localizedDescription
        showAlert.toggle()
        isLoading = false
    }
    
    // MARK: - 스토리지 관련
    
    func updateUserData() async throws {
        try await updateProfileImage()
    }
    
    // PhotosUI를 통해 사용자 이미지에서 데이터를 받아옴
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImageUrl = Image(uiImage: uiImage)
    }
    
    // ImageUploader를 통해 Storage에 이미지를 올리고 imageurl을 매게변수로 updateUserProfileImage 에 넣어줌
    private func updateProfileImage() async throws {
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
        try await updateUserProfileImage(withImageUrl: imageUrl)
    }

    // 전달받은 imageUrl 의 값을 파이어 스토어 모델에 올리고 뷰모델에 넣어줌
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl": imageUrl
        ])
        self.currentUser?.profileImageUrl = imageUrl
    }
}
