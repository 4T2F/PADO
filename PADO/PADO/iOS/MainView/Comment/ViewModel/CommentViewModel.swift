//
//  CommentViewModel.swift
//  PADO
//
//  Created by 최동호 on 2/8/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var documentID: String = ""
    @Published var inputcomment: String = ""
    @Published var showdeleteModal: Bool = false
    @Published var showreportModal: Bool = false
    @Published var showselectModal: Bool = false
    @Published var selectedComment: Comment?
    @Published var commentUserIDs: [String] = []
    @Published var commentUsers: [String: User] = [:]
    
    let updateCommentData = UpdateCommentData()
    
    let db = Firestore.firestore()
    
    // MARK: - FaceMoji 관련
    @Published var faceMojiUIImage: UIImage?
    @Published var cropMojiUIImage: UIImage?
    @Published var cropMojiImage: Image = Image("")
    @Published var facemojies: [Facemoji] = []
    @Published var deleteFacemojiModal: Bool = false
    @Published var showCropFaceMoji: Bool = false
    @Published var showEmojiView: Bool = false
    @Published var selectedEmoji: String = ""
    @Published var selectedFacemoji: Facemoji?

    let updateFacemojiData = UpdateFacemojiData()
    
    func removeDuplicateUserIDs(from comments: [Comment])  {
        let userIDs = comments.map { $0.userID }
        var uniqueUserIDs = Set(userIDs)
        if !userNameID.isEmpty {
            uniqueUserIDs.insert(userNameID)
        }
        self.commentUserIDs = Array(uniqueUserIDs)
    }
    
    @MainActor
    func fetchCommentUser() async {
        do {
            for documentID in commentUserIDs {
                let querySnapshot = try await Firestore.firestore().collection("users").document(documentID).getDocument()
                
                let userData = try? querySnapshot.data(as: User.self)
                self.commentUsers[documentID] = userData
            }
        } catch {
            print("유저 데이터 가져오기 실패: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func addCommentHeart(post: Post, index: Int) async {
        guard !userNameID.isEmpty else { return }
        guard let postID = post.id else { return }
        guard let commentID = comments[index].id else { return }
        
        do {
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(postID).collection("comment").document(commentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return
                }
                
                guard var commentHeartIDs = postDocument.data()?["heartIDs"] as? [String] else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "하트준 ID값들에 접근 못함 \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return
                }
                guard !commentHeartIDs.contains(userNameID) else { return }
                
                commentHeartIDs.append(userNameID)
                transaction.updateData(["heartIDs": commentHeartIDs], forDocument: postRef)
                DispatchQueue.main.async {
                    self.comments[index].heartIDs.append(userNameID)
                }
                
                return
            })
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        return
    }
    
    @MainActor
    func deleteCommentHeart(post: Post, index: Int) async {
        guard !userNameID.isEmpty else { return }
        guard let postID = post.id else { return }
        guard let commentID = comments[index].id else { return }

        do {
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(postID).collection("comment").document(commentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return
                }
                
                guard var commentHeartIDs = postDocument.data()?["heartIDs"] as? [String] else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "하트준 ID값들에 접근 못함 \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return
                }
                
                guard let removeIndex = commentHeartIDs.firstIndex(of: userNameID) else { return }
                
                commentHeartIDs.remove(at: removeIndex)

                transaction.updateData(["heartIDs": commentHeartIDs], forDocument: postRef)
                
                DispatchQueue.main.async {
                    if let localRemoveIndex = self.comments[index].heartIDs.firstIndex(of: userNameID) {
                        self.comments[index].heartIDs.remove(at: localRemoveIndex)
                    }
                }
                return
            })
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func checkCommentHeartExists(index: Int) -> Bool {
        guard !userNameID.isEmpty else { return false }
        return comments[index].heartIDs.contains(userNameID)
    }
}

// MARK: 대댓글
extension CommentViewModel {
    func writeReplyComment(post: Post,
                           index: Int,
                           imageUrl: String,
                           inputcomment: String) async {
        
        guard !userNameID.isEmpty else { return }
        
        let initialPostData : [String: Any] = [
            "userID": userNameID,
            "content": inputcomment,
            "time": Timestamp(),
            "heartIDs": [],
        ]
        await createReplyCommentData(post: post,
                                     index: index,
                                     data: initialPostData)
    }
    
    @MainActor
    func createReplyCommentData(post: Post,
                                index: Int,
                                data: [String: Any]) async {
        guard let commentID = comments[index].id else {
            print("댓글 ID가 없습니다.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
        
        let formattedDate = dateFormatter.string(from: Date())
        let formattedCommentTitle = userNameID+formattedDate
        guard let postID = post.id else { return }
        do {
            // 포스트에서 댓글을 보여주기 위해 만들어줌
            try await db.collection("post").document(postID).collection("comment").document(commentID).collection("replyComments").document(formattedCommentTitle).setData(data)
            
            try await db.collection("post").document(postID).updateData(["commentCount": post.commentCount + 1])
            
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(postID).collection("comment").document(commentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return
                }
                
                guard var commentReplyIDs = postDocument.data()?["replyComments"] as? [String] else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "답글 데이터들에 접근 못함: \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return
                }
                
                commentReplyIDs.append(formattedCommentTitle)

                transaction.updateData(["replyComments": commentReplyIDs], forDocument: postRef)
                
                DispatchQueue.main.async {
                    self.comments[index].replyComments.append(formattedCommentTitle)
                }
                return
            })
            
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
    }
    
    func deleteReplyComment(post: Post, index: Int, replyCommentID: String) async {
        guard let postID = post.id else { return }
        guard let commentID = comments[index].id else { return }
        do {
            // 포스트의 'comment' 컬렉션에서 특정 댓글 삭제
            try await db.collection("post").document(postID).collection("comment").document(commentID).collection("replyComments").document(replyCommentID).delete()
            
            try await db.collection("post").document(postID).updateData(["commentCount": post.commentCount-1])
            
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(postID).collection("comment").document(commentID)
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return
                }
                
                guard var commentReplyIDs = postDocument.data()?["replyComments"] as? [String] else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "답글 데이터들에 접근 못함: \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return
                }
                
                guard let removeIndex = commentReplyIDs.firstIndex(of: replyCommentID) else { return }
                
                commentReplyIDs.remove(at: removeIndex)
              
                transaction.updateData(["replyComments": commentReplyIDs], forDocument: postRef)
                
                guard let removeLocalIndex = self.comments[index].replyComments.firstIndex(of: replyCommentID) else { return }
                DispatchQueue.main.async {
                    self.comments[index].replyComments.remove(at: removeLocalIndex)
                }
                return
            })
            
            // 성공적으로 삭제됐다는 메시지 출력
            print(commentID)
            print("답글이 성공적으로 삭제되었습니다.")
        } catch {
            print("답글 삭제 중 오류 발생: \(error.localizedDescription)")
        }
    }
}
