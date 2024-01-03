//
//  AuthenticationViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI
import Firebase

// UI 관련 변수를 업데이트할 때에는 main 쓰레드에서 업데이트 될 수 있도록 @MainActor 어노테이션을 사용 해야함.
// 해당 변수를 업데이트하는 코드가 들어있는 함수 선언에 어노테이션을 추가 해줘야함.
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
    
//    init() {
//        userSession = Auth.auth().currentUser
//        fetchUser()
//    }
    
    // 전화번호 인증을 시작하는 비동기 함수
    func sendOtp() async {
        if isLoading { return }
        
        do {
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(country.phoneCode)\(phoneNumber)", uiDelegate: nil)
            DispatchQueue.main.async {
                self.isLoading = true
                self.verificationCode = result
                self.navigationTag = "VERIFICATION"
            }
        } catch {
            handleError(error: error.localizedDescription)
        }
        
        self.navigationTag = "VERIFICATION"
    }
    
    func handleError(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = error
            self.showAlert.toggle()
        }
    }
    
    // 올바른 OTP인지 검증하는 비동기 함수
    func verifyOtp() async {
        do {
            isLoading = true
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
            let result = try await Auth.auth().signIn(with: credential)
            let db = Firestore.firestore()
            
            db.collection("users").document(result.user.uid).setData([
                "fullname": name,
                "date": year.date,
                "id": result.user.uid
            ]) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
            
            DispatchQueue.main.async { [self] in
                self.isLoading = false
                let user = result.user
                self.userSession = user
                self.currentUser = User(name: name, date: year.date)
                print(user.uid)
            }
        } catch {
            print("ERROR : OTP 인증 실패함")
            handleError(error: error.localizedDescription)
        }
    }
    
    func signOut() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let user = try? snapshot?.data(as: User.self) else { return }
            self.currentUser = user
            print("ERROR : User 정보를 받아오질 못했음")
            print(user)
        }
    }
}
