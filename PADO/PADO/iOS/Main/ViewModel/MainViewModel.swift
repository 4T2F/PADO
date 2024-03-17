//
//  MainViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import Firebase
import FirebaseStorage
import PhotosUI

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var showLaunchScreen = true
    @Published var isShowingMessageView = false

    // 탭바 이동관련 변수
    @Published var showTab: Int = 0
    @Published var scrollToTop: Bool = false
    
    // 세팅 관련 뷰 이동 변수
    @Published var showingProfileView: Bool = false
    @Published var showingEditProfile: Bool = false
    @Published var showingEditBackProfile: Bool = false
    
    // MARK: - SettingProfile
    @Published var username = ""
    @Published var instaAddress = ""
    @Published var tiktokAddress = ""
    @Published var imagePick: Bool = false
    @Published var backimagePick: Bool = false
    @Published var changedValue: Bool = false
    @Published var showProfileModal: Bool = false
    @Published var selectedFilter: FeedFilter = .today
    @Published var tempProfileImage: String? = nil
    @Published var tempBackImage: String? = nil
    
    // MARK: - SettingNoti
    @Published var alertAccept = ""
    
    // 프로필 사진 변경 값 저장
    @Published var userSelectImage: Image?
    @Published var uiImage: UIImage?
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                do {
                    let (loadedUIImage, loadedSwiftUIImage) = try await UpdateImageUrl.shared.loadImage(selectedItem: selectedItem)
                    self.uiImage = loadedUIImage
                    self.userSelectImage = loadedSwiftUIImage
                } catch {
                    print("선택 이미지 초기화: \(error)")
                }
            }
        }
    }
    
    // 배경화면 변경값 저장
    @Published var backSelectImage: Image?
    @Published var backuiImage: UIImage?
    
    @Published var selectedBackgroundItem: PhotosPickerItem? {
        didSet {
            Task {
                do {
                    let (loadedUIImage, loadedSwiftUIImage) = try await UpdateImageUrl.shared.loadImage(selectedItem: selectedBackgroundItem)
                    self.backuiImage = loadedUIImage
                    self.backSelectImage = loadedSwiftUIImage
                } catch {
                    print("선택 이미지 초기화: \(error)")
                }
            }
        }
    }
        
    @Published var currentUser: User?
    
    // MARK: - Profile SNS
    // SNS 주소의 등록 여부를 확인
    var isAnySocialAccountRegistered: Bool {
        !(currentUser?.instaAddress ?? "").isEmpty || !(currentUser?.tiktokAddress ?? "").isEmpty
    }
    
    var areBothSocialAccountsRegistered: Bool {
        !(currentUser?.instaAddress ?? "").isEmpty && !(currentUser?.tiktokAddress ?? "").isEmpty
    }
    
    
    // MARK: - 사용자 데이터 관리
    @MainActor
    func initializeUser() async {
        // 사용자 초기화
        guard Auth.auth().currentUser?.uid != nil,
              !userNameID.isEmpty else {
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            return
        }
        await fetchUser()

    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            userNameID = ""
            instaAddress = ""
            tiktokAddress = ""
            currentUser = nil
            selectedFilter = .today
            userFollowingIDs.removeAll()
            showTab = 0
            
            print("dd")
            print(String(describing: Auth.auth().currentUser?.uid))
            print("dd")
            print(String(describing: currentUser))
        } catch {
            print("로그아웃 오류: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func deleteAccount() async {
        // 계정 삭제
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        
        let postQuery = db.collection("post").whereField("ownerUid", isEqualTo: userNameID)
        
        // Firestore의 `post` 컬렉션에서 사용자의 게시물 삭제
        do {
            let querySnapshot = try await postQuery.getDocuments()
            for document in querySnapshot.documents {
                await DeletePost.shared.deletePost(postID: document.documentID)
            }
        
        } catch {
            print("Error removing posts: \(error.localizedDescription)")
        }
        
        // user 컬렉션 삭제
        do {
            let sendPostQuery = try await db.collection("users").document(userNameID).collection("sendpost").getDocuments()
            
            let myPostQuery = try await db.collection("users").document(userNameID).collection("mypost").getDocuments()
            
            let followingQuery = try await db.collection("users").document(userNameID).collection("following").getDocuments()
            
            let followerQuery = try await db.collection("users").document(userNameID).collection("follower").getDocuments()
            
            let surferQuery = try await db.collection("users").document(userNameID).collection("surfer").getDocuments()
            
            let notiQuery = try await db.collection("users").document(userNameID).collection("notifications").getDocuments()
            
            let messageQuery = try await db.collection("users").document(userNameID).collection("message").getDocuments()
            
            let highlightQuery = try await db.collection("users").document(userNameID).collection("highlight").getDocuments()
            
            for document in sendPostQuery.documents {
                try await db.collection("users").document(userNameID).collection("sendpost").document(document.documentID).delete()
            }
            
            for document in myPostQuery.documents {
                try await db.collection("users").document(userNameID).collection("mypost").document(document.documentID).delete()
            }
            
            for document in followingQuery.documents {
                await UpdateFollowData.shared.directUnfollowUser(id: document.documentID)
            }
            
            for document in followerQuery.documents {
                await UpdateFollowData.shared.removeFollower(id: document.documentID)
            }
        
            for document in surferQuery.documents {
                await UpdateFollowData.shared.removeSurfer(id: document.documentID)
            }
            
            for document in notiQuery.documents {
                try await db.collection("users").document(userNameID).collection("notifications").document(document.documentID).delete()
            }
            
            for document in messageQuery.documents {
                try await db.collection("users").document(userNameID).collection("message").document(document.documentID).delete()
            }
            
            for document in highlightQuery.documents {
                try await db.collection("users").document(userNameID).collection("highlight").document(document.documentID).delete()
            }
            
            try await db.collection("users").document(userNameID).delete()
            
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
        
        // Firebase Storage에서 사용자의 'post/' 경로에 있는 모든 이미지 삭제
        let userPostsRef = storageRef.child("post/\(userNameID)")
        let userProfliesRef = storageRef.child("profile_image/\(userNameID)")
        let userBackRef = storageRef.child("back_image/\(userNameID)")
        do {
            let listResult = try await userPostsRef.listAll()
            let profileListResult = try await userProfliesRef.listAll()
            let backgroundListResult = try await userBackRef.listAll()
            for item in listResult.items {
                // 각 항목 삭제
                try await item.delete()
            }
            
            for item in profileListResult.items {
                try await item.delete()
            }
            
            for item in backgroundListResult.items {
                try await item.delete()
            }
            
        } catch {
            print("Error removing posts from storage: \(error.localizedDescription)")
        }
        
        userNameID = ""
        instaAddress = ""
        tiktokAddress = ""
        currentUser = nil
        selectedFilter = .today
        userFollowingIDs.removeAll()
        showTab = 0
    }
    
    // MARK: - Firestore 쿼리 처리
    @MainActor
    func fetchUIDByPhoneNumber(phoneNumber: String) async {
        // 전화번호로 Firestore
        let usersCollection = Firestore.firestore().collection("users")
        let query = usersCollection.whereField("phoneNumber", isEqualTo: phoneNumber)
        
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {
                userNameID = document.documentID
            }
            
        } catch {
            print("Error fetching user by phone number: (error)")
        }
    }
    
    @MainActor
    func fetchUser() async {
        // 사용자 데이터 불러오기
        do {
            try await Firestore.firestore().collection("users").document(userNameID).updateData([
                "fcmToken": userToken,
            ])
            
            let snapshot = try await Firestore.firestore().collection("users").document(userNameID).getDocument()
            print("nameID: \(userNameID)")
            print("Snapshot: \(String(describing: snapshot.data()))")
            
            guard let user = try? snapshot.data(as: User.self) else {
                print("Error: User data could not be decoded")
                return
            }
            currentUser = user
            print("Current User: \(String(describing: currentUser))")
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    // MARK: - SettingProfileView
    @MainActor
    func profileSaveData() async {
        Task {
            // 버튼이 활성화된 경우 실행할 로직
            try await UpdateUserData.shared.updateUserData(initialUserData: ["username": username,
                                                                             "lowercasedName": username.lowercased(),
                                                                             "instaAddress": instaAddress,
                                                                             "tiktokAddress": tiktokAddress])
            currentUser?.username = username
            currentUser?.lowercasedName = username.lowercased()
            currentUser?.instaAddress = instaAddress
            currentUser?.tiktokAddress = tiktokAddress
            
            
            if imagePick && backimagePick {
                let returnString = try await UpdateImageUrl.shared.updateImageUserData(uiImage: uiImage,
                                                                                       storageTypeInput: .user,
                                                                                       documentid: "",
                                                                                       imageQuality: .middleforProfile,
                                                                                       surfingID: "")
                currentUser?.profileImageUrl = returnString
                
                let returnBackString = try await UpdateImageUrl.shared.updateImageUserData(uiImage: backuiImage,
                                                                                           storageTypeInput: .backImage,
                                                                                           documentid: "",
                                                                                           imageQuality: .highforPost,
                                                                                           surfingID: "")
                currentUser?.backProfileImageUrl = returnBackString
            } else if imagePick {
                let returnString = try await UpdateImageUrl.shared.updateImageUserData(uiImage: uiImage,
                                                                                       storageTypeInput: .user,
                                                                                       documentid: "",
                                                                                       imageQuality: .middleforProfile,
                                                                                       surfingID: "")
                currentUser?.profileImageUrl = returnString
            } else if backimagePick {
                let returnBackString = try await UpdateImageUrl.shared.updateImageUserData(uiImage: backuiImage,
                                                                                           storageTypeInput: .backImage,
                                                                                           documentid: "",
                                                                                           imageQuality: .highforPost,
                                                                                           surfingID: "")
                currentUser?.backProfileImageUrl = returnBackString
            }
        }
    }
    
    func fetchUserProfile() {
        username = currentUser?.username ?? ""
        instaAddress = currentUser?.instaAddress ?? ""
        tiktokAddress = currentUser?.tiktokAddress ?? ""
        changedValue = false
    }
    
    func checkForChanges() {
        // 현재 데이터와 원래 데이터 비교
        let isUsernameChanged = currentUser?.username != username
        let isInstaAddressChanged = currentUser?.instaAddress != instaAddress
        let isTiktokAddressChanged = currentUser?.tiktokAddress != tiktokAddress
        
        changedValue = isUsernameChanged || isInstaAddressChanged || isTiktokAddressChanged || imagePick || backimagePick
        
    }
    
    @MainActor
    func updateAlertAcceptance(newStatus: Bool) async {
        let alertAccept = newStatus ? "yes" : "no"
        
        do {
            try await UpdateUserData.shared.updateUserData(initialUserData: ["alertAccept": alertAccept])
            currentUser?.alertAccept = alertAccept
        } catch {
            print("알림 설정 업데이트 중 오류 발생: \(error)")
        }
    }
}
