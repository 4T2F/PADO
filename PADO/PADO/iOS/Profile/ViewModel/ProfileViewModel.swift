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
    @Published var padoRides: [PadoRide] = []
    @Published var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @Published var selectedPostID: String = ""
    @Published var blockUser: [BlockUser] = []
    
    // 사용자 차단 로직
    @Published var isUserBlocked: Bool = false
    
    private var db = Firestore.firestore()
    
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
                await fetchPostData(documentID: document.documentID,
                                    inputType: InputPostType.pado)
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchSendPadoPosts(id: String) async {
        sendPadoPosts.removeAll()
        do {
            let padoQuerySnapshot = try await db.collection("users").document(id).collection("sendpost").order(by: "created_Time", descending: true).getDocuments()
            
            for document in padoQuerySnapshot.documents {
                await fetchPostData(documentID: document.documentID,
                                    inputType: InputPostType.sendPado)
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
                await fetchPostData(documentID: document.documentID,
                                    inputType: InputPostType.highlight)
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
            
            guard filterBlockedPost(post: post) else {
                print("\(documentID)는 차단된 사람의 글입니다")
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


extension ProfileViewModel {
    // 차단된 사용자들 정보 불러오기
    @MainActor
    func fetchBlockUsers() async {
        guard !userNameID.isEmpty else { return }
        
        let blockingCollectionRef = db.collection("users").document(userNameID).collection("blockingUsers")
        
        let blockedCollectionRef =            db.collection("users").document(userNameID).collection("blockedUsers")
        
        do {
            let blockingSnapshot = try await blockingCollectionRef.getDocuments()
            blockingUser = blockingSnapshot.documents.compactMap { document -> BlockUser? in
                try? document.data(as: BlockUser.self)
            }
            blockUser = blockingSnapshot.documents.compactMap { document -> BlockUser? in
                try? document.data(as: BlockUser.self)
            }
            let blockedSnapshot = try await blockedCollectionRef.getDocuments()
            blockedUser = blockedSnapshot.documents.compactMap { document -> BlockUser? in
                try? document.data(as: BlockUser.self)
            }
            
        } catch {
            print("Error fetching blocked users: \(error.localizedDescription)")
        }
    }
    
    // 사용자 차단
    @MainActor
    func blockUser(blockingUser: User, user: User) async {
        
        
        let blockingUserRef = db.collection("users").document(user.nameID).collection("blockingUsers").document(blockingUser.nameID)
        
        let blockedUserRef = db.collection("users").document(blockingUser.nameID).collection("blockedUsers").document(user.nameID)
        
        do {
            try await blockingUserRef.setData([
                "blockUserID": blockingUser.nameID,
                "blockUserProfileImage": blockingUser.profileImageUrl ?? "",
                "blockTime": Timestamp(date: Date())
            ])
            
            try await blockedUserRef.setData([
                "blockUserID": user.nameID,
                "blockUserProfileImage": user.profileImageUrl ?? "",
                "blockTime": Timestamp(date: Date())
            ])
            
            await UpdateFollowData.shared.directUnfollowUser(id: blockingUser.nameID)
            
            await UpdateFollowData.shared.userUnfollowMe(id: blockingUser.nameID)
            
            await fetchBlockUsers()
        }
        catch {
            print("Error blocking user: \(error.localizedDescription)")
        }
        
    }
    
    // 사용자 차단 해제
    @MainActor
    func unblockUser(blockingUser: User, user: User) async {
        let blockingUserRef = db.collection("users").document(user.nameID).collection("blockingUsers").document(blockingUser.nameID)
        
        let blockedUserRef = db.collection("users").document(blockingUser.nameID).collection("blockedUsers").document(user.nameID)
        
        do {
            try await blockingUserRef.delete()
            try await blockedUserRef.delete()
            
            await fetchBlockUsers()
        } catch {
            print("Error unblocking user: \(error.localizedDescription)")
        }
    }
    
    
    private func filterBlockedPost(post: Post) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        if blockedUserIDs.contains(post.ownerUid) || blockedUserIDs.contains(post.surferUid) {
            return false
        } else {
            return true
        }
    }
}
