//
//  PostitViewModel.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//

import FirebaseFirestore

import Foundation

class PostitViewModel: ObservableObject {
    @Published var messages: [PostitMessage] = []
    @Published var ownerID: String = ""
    @Published var inputcomment: String = ""
    @Published var inputcommentForNoti: String = ""
    @Published var longpressedMessage: String = ""
    @Published var longpressedID: String = ""
    @Published var showdeleteModal: Bool = false
    @Published var messageUserIDs: [String] = []
    @Published var messageUsers: [String: User] = [:]
    @Published var isFetchedMessages: Bool = false
    @Published var isShowingLoginPage: Bool = false
    @Published var fetchedPostitData: Bool = false
    
    let db = Firestore.firestore()
    
    private var messagesListener: ListenerRegistration?
    
    @MainActor
    func getMessageDocument(ownerID: String) async {
        self.messages.removeAll()
        self.ownerID = ownerID
        guard !ownerID.isEmpty else { return }
        
        do {
            let querySnapshot = try await db.collection("users").document(ownerID).collection("message").order(by: "messageTime", descending: false).getDocuments()
            self.messages = querySnapshot.documents.compactMap { document in
                try? document.data(as: PostitMessage.self)
            }
            self.messages = filterBlockedMessages(messages: self.messages)
            self.messageUserIDs = removeDuplicateUserIDs(from: messages)
            await fetchMessageUser()
        } catch {
            print("Error fetching comments: \(error)")
        }
    }
    
    @MainActor
    func writeMessage(ownerID: String, imageUrl: String, inputcomment: String) async {
        
        guard !ownerID.isEmpty else { return }
        
        let initialMessageData : [String: Any] = [
            "messageUserID": userNameID,
            "imageUrl": imageUrl,
            "content": inputcomment,
            "messageTime": Timestamp(),
        ]
        await createMessageData(ownerID: ownerID, data: initialMessageData)
        self.inputcommentForNoti = inputcomment
        self.inputcomment = ""
    }
    
    @MainActor
    func createMessageData(ownerID: String, data: [String: Any]) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
        
        let formattedDate = dateFormatter.string(from: Date())
        let formattedCommentTitle = userNameID+formattedDate
        
        do {
            try await db.collection("users").document(ownerID).collection("message").document(formattedCommentTitle).setData(data)
            
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    func removeMessageData(ownerID: String, messageID: String) async {
        do {
            try await db.collection("users").document(ownerID).collection("message").document(messageID).delete()
        } catch {
            print("Error removing document: \(error.localizedDescription)")
        }
    }
    
    func removeDuplicateUserIDs(from messages: [PostitMessage]) -> [String] {
        let userIDs = messages.map { $0.messageUserID }
        var uniqueUserIDs = Set(userIDs)
        if !userNameID.isEmpty {
            uniqueUserIDs.insert(userNameID)
        }
        return Array(uniqueUserIDs)
    }
    
    @MainActor
    func listenForMessages(ownerID: String) async {
        self.ownerID = ownerID
        messagesListener = db.collection("users").document(ownerID).collection("message")
          .order(by: "messageTime", descending: false)
          .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error listening for message updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.messages = snapshot.documents.compactMap { document in
                try? document.data(as: PostitMessage.self)
            }
            self.messages = self.filterBlockedMessages(messages: self.messages)
        }
        self.messageUserIDs = removeDuplicateUserIDs(from: self.messages)
        await fetchMessageUser()
    }
    
    @MainActor
    func fetchMessageUser() async {
        do {
            for documentID in messageUserIDs {
                let querySnapshot = try await db.collection("users").document(documentID).getDocument()
                
                let userData = try? querySnapshot.data(as: User.self)
                self.messageUsers[documentID] = userData
            }
        } catch {
            print("Error fetch User: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func removeListner() {
        messagesListener?.remove()
        messagesListener = nil
    }
    
    func sendMessage(sendUser: User) {
        if userNameID.isEmpty {
            isShowingLoginPage = true
        } else if !blockPostit(id: ownerID) {
            Task {
                await writeMessage(ownerID: ownerID,
                                   imageUrl: sendUser.profileImageUrl ?? "",
                                            inputcomment: inputcomment)
                if let user = messageUsers[ownerID] {
                    await UpdatePushNotiData.shared.pushNoti(receiveUser: user,
                                                             type: .postit,
                                                             sendUser: sendUser,
                                                             message: inputcommentForNoti)
                }
            }
        }
    }
    
    
    private func blockPostit(id: String) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return blockedUserIDs.contains(id)
    }
}

extension PostitViewModel {
    private func filterBlockedMessages(messages: [PostitMessage]) -> [PostitMessage] {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return messages.filter { message in
            !blockedUserIDs.contains(message.messageUserID)
        }
    }
}
