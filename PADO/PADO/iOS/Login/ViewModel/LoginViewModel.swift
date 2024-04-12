//
//  LoginViewModel.swift
//  PADO
//
//  Created by 최동호 on 3/17/24.
//

import Firebase
import FirebaseStorage

import SwiftUI

class LoginViewModel: ObservableObject {
    
    // StartView 문구
    @Published var titleIndex: Int = 0
    @Published var titleText: [TextAnimation] = []
    @Published var subTitleAnimation: Bool = false
    @Published var endAnimation = false
    
    @Published var currentStep: SignUpStep = .phoneNumber

    @Published var nameID = ""
    @Published var year = ""
    @Published var phoneNumber = ""
    @Published var otpText = ""

    @Published var isLoading: Bool = false
    @Published var verificationCode: String = ""
    @Published var isDuplicateID: Bool = false
    
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var isExisted = false
    @Published var isShowingMessageView = false
    
    @Published var birthDate = Date() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            year = dateFormatter.string(from: birthDate)
        }
    }
    
    @Published var authResult: AuthDataResult?
    
    let titles = ["Clean your mind from", "Unique experience", "The ultimate sns"]
    let subTitles = ["Decorate your friend's picture", "Prepare your mind for sweet dreams", "Healty mind - better think - well being"]
    
    // MARK: - StartView 애니메이션
    func startAnimation() {
        titleText.removeAll()
        subTitleAnimation = false
        endAnimation = false

        getSpilitedText(text: titles[titleIndex]) {
            withAnimation(.easeInOut(duration: 1)) {
                self.endAnimation.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.subTitleAnimation.toggle()
                self.endAnimation.toggle()

                if self.titleIndex < (self.titles.count - 1) {
                    self.titleIndex += 1
                } else {
                    self.titleIndex = 0
                }
            }
        }
    }
    
    func getSpilitedText(text: String, completion: @escaping () -> Void) {
        for (index, character) in text.enumerated() {
            titleText.append(TextAnimation(text: String(character)))

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.03) {
                withAnimation(.easeInOut(duration: 0.45)) {
                    self.titleText[index].offset = 0
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.count) * 0.02) {
            withAnimation(.easeInOut(duration: 0.75)) {
                self.subTitleAnimation.toggle()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
            completion()
        }
    }

    func handleBackButton(dismiss: @escaping () -> Void) {
        switch currentStep {
        case .phoneNumber:
            dismiss()
            phoneNumber = ""
        case .code:
            currentStep = .phoneNumber
            phoneNumber = ""
            otpText = ""
        case .id:
            currentStep = .phoneNumber
            phoneNumber = ""
            otpText = ""
            nameID = ""
        case .birth:
            nameID = ""
            year = ""
            currentStep = .id
        }
    }
    
    func isFourteenOrOlder() -> Bool {
        let calendar = Calendar.current
        let fourteenYearsAgo = calendar.date(byAdding: .year, value: -14, to: Date())!
        return birthDate <= fourteenYearsAgo
    }
    
    func selectID() {
        if nameID.contains(" ") {
            // 공백이 있으면 경고 메시지 표시
            isDuplicateID = true
            return
        }

        let regex = "^[A-Za-z0-9]+$"
        if nameID.range(of: regex, options: .regularExpression) != nil {
            Task {
                let isDuplicate = await checkForDuplicateID()
                if !isDuplicate {
                    nameID = nameID.lowercased()
                    currentStep = .birth
                } else {
                    isDuplicateID = true
                }
            }
        } else {
            isDuplicateID = true
        }
    }
    
    // MARK: - 인증 관련
    @MainActor
    func sendOtp() async {
        // OTP 발송
        do {
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+82\(phoneNumber)", uiDelegate: nil) // 사용한 가능한 번호인지
            verificationCode = result
            isLoading = false
        } catch {
            handleError(error: error)
        }
    }
    
    @MainActor
    func verifyOtp() async -> Bool {
        // Otp 검증
        guard !otpText.isEmpty else { return false }
        isLoading = true
        do {
            let result = try await signInWithCredential()
            authResult = result
            
            isLoading = false
            return true
        } catch {
            handleError(error: error)
            isLoading = false
            return false
        }
    }
    
    @MainActor
    private func signInWithCredential() async throws -> AuthDataResult {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
        print(credential)
        return try await Auth.auth().signIn(with: credential)
    }
    
    @MainActor
    func signUpUser() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let initialUserData = [
            "username": "",
            "lowercasedName": "",
            "id": userId,
            "nameID": nameID,
            "date": year,
            "phoneNumber": "+82\(phoneNumber)",
            "fcmToken": userToken,
            "alertAccept": acceptAlert,
            "instaAddress": "",
            "tiktokAddress": "",
            "openHighlight": "yes"
        ]
        userNameID = nameID
        await createUserData(nameID, data: initialUserData)
    }
    
    @MainActor
    func createUserData(_ nameID: String, data: [String: Any]) async {
        
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        
        do {
            try await Firestore.firestore().collection("users").document(nameID).setData(data)
           
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func checkForDuplicateID() async -> Bool {
        // ID 중복 확인
        let usersCollection = Firestore.firestore().collection("users")
        let query = usersCollection.whereField("nameID", isEqualTo: nameID.lowercased())
        
        do {
            let querySnapshot = try await query.getDocuments()
            return !querySnapshot.documents.isEmpty
        } catch {
            print("Error checking for duplicate ID: \(error)")
            return true
        }
    }
    
    @MainActor
    func checkPhoneNumberExists(phoneNumber: String) async -> Bool {
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
    
    // MARK: - 오류 처리
    func handleError(error: Error) {
        // 오류 처리
        errorMessage = error.localizedDescription
        showAlert.toggle()
        isLoading = false
    }
}
