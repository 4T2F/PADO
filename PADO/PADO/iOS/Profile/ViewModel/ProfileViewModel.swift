//
//  ProfileViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/31/24.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

enum InputPostType {
    case pado
    case sendPado
    case highlight
}

class ProfileViewModel: ObservableObject {
    @Published var currentType: String = "받은 파도"
    @Published var padoPosts: [Post] = []
    @Published var sendPadoPosts: [Post] = []
    @Published var highlights: [Post] = []
    @Published var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @Published var selectedPostID: String = ""
    
    // 사용자 차단 로직
    @Published var blockedUsers = [BlockedUser]()
    @Published var isUserBlocked: Bool = false
    
    private var db = Firestore.firestore()
    
    // 차단된 사용자들 정보 불러오기
    @MainActor
    func fetchBlockedUsers() async {
        let collectionRef = db.collection("users").document(userNameID).collection("blockUsers")
        
        do {
            let snapshot = try await collectionRef.getDocuments()
            self.blockedUsers = snapshot.documents.compactMap { document -> BlockedUser? in
                try? document.data(as: BlockedUser.self)
            }
            // 사용자 목록이 업데이트된 후에 차단 여부를 다시 확인
            checkIfUserIsBlocked(targetUserID: "여기에 확인하고 싶은 사용자의 nameID 입력")
        } catch {
            print("Error fetching blocked users: \(error.localizedDescription)")
        }
    }
    
    // 특정 사용자가 차단된 사용자 목록에 있는지 확인
    @MainActor
    func checkIfUserIsBlocked(targetUserID: String) {
        isUserBlocked = blockedUsers.contains { $0.blockedUserID == targetUserID }
    }
    
    // 사용자 차단
    @MainActor
    func blockUser(blockedUserID: String) {
        let blockUserRef = db.collection("users").document(userNameID).collection("blockUsers").document(blockedUserID)
        
        blockUserRef.setData([
            "blockedUserID": blockedUserID,
            "blockTime": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error blocking user: \(error.localizedDescription)")
            } else {
                print("User successfully blocked")
            }
        }
    }
    
    // 사용자 차단 해제
    @MainActor
    func unblockUser(blockedUserID: String) {
        let blockUserRef = db.collection("users").document(userNameID).collection("blockUsers").document(blockedUserID)
        
        blockUserRef.delete() { error in
            if let error = error {
                print("Error unblocking user: \(error.localizedDescription)")
            } else {
                print("User successfully unblocked")
            }
        }
    }
    
    @MainActor
    func fetchPadoPosts(id: String, blockedUsers: [String]) async {
        padoPosts.removeAll()
        do {
            let padoQuerySnapshot = try await db.collection("users").document(id).collection("mypost").whereField("userID", notIn: blockedUsers).order(by: "created_Time", descending: true).getDocuments()
            for document in padoQuerySnapshot.documents {
                await fetchPostData(documentID: document.documentID, inputType: InputPostType.pado)
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    // URL Scheme을 사용하여 앱 열기 시도, 앱이 설치 되지 않았다면 대체 웹 URL로 이동
    func openSocialMediaApp(urlScheme: String, fallbackURL: String) {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: fallbackURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor
    func fetchPostID(id: String) async {
        await fetchPadoPosts(id: id)
        await fetchSendPadoPosts(id: id)
        await fetchHighlihts(id: id)
    }
    
    @MainActor
    func fetchPadoPosts(id: String) async {
        padoPosts.removeAll()
        do {
            let padoQuerySnapshot = try await db.collection("users").document(id).collection("mypost").order(by: "created_Time", descending: true).getDocuments()
            for document in padoQuerySnapshot.documents {
                await fetchPostData(documentID: document.documentID, inputType: InputPostType.pado)
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchSendPadoPosts(id: String) async {
        sendPadoPosts.removeAll()
        do {
            let padoQuerySnapshot = try await db.collection("users").document(id).collection("sendpost").order(by: "created_Time", descending: true).getDocuments()
            for document in padoQuerySnapshot.documents {
                await fetchPostData(documentID: document.documentID, inputType: InputPostType.sendPado)
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchHighlihts(id: String) async {
        highlights.removeAll()
        do {
            let padoQuerySnapshot = try await db.collection("users").document(id).collection("highlight").order(by: "sendHeartTime", descending: true).getDocuments()
            for document in padoQuerySnapshot.documents {
                await fetchPostData(documentID: document.documentID, inputType: InputPostType.highlight)
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchPostData(documentID: String, inputType: InputPostType) async {
        guard !documentID.isEmpty else { return }
        do {
            let docRef = db.collection("post").document(documentID)
            let querySnapshot = try await docRef.getDocument()
            
            guard var post = try? querySnapshot.data(as: Post.self) else {
                print("\(documentID)는 삭제된 게시글입니다")
                return
            }
            
            // 스냅샷 리스너 설정
            docRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot, let data = document.data() else {
                    print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                post.heartsCount = data["heartsCount"] as? Int ?? 0
                post.commentCount = data["commentCount"] as? Int ?? 0
                
                // 배열 업데이트
                self.updatePostArray(post: post, inputType: inputType)
            }
            
            
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    
    private func updatePostArray(post: Post, inputType: InputPostType) {
        switch inputType {
        case .pado:
            if let index = padoPosts.firstIndex(where: { $0.id == post.id }) {
                padoPosts[index] = post
            } else {
                padoPosts.append(post)
            }
        case .sendPado:
            if let index = sendPadoPosts.firstIndex(where: { $0.id == post.id }) {
                sendPadoPosts[index] = post
            } else {
                sendPadoPosts.append(post)
            }
        case .highlight:
            if let index = highlights.firstIndex(where: { $0.id == post.id }) {
                highlights[index] = post
            } else {
                highlights.append(post)
            }
        }
    }
    
}
