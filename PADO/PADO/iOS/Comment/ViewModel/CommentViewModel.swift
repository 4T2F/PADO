//
//  CommentViewModel.swift
//  PADO
//
//  Created by 최동호 on 2/8/24.
//

import FirebaseFirestore
import FirebaseStorage

import SwiftUI

class CommentViewModel: ObservableObject {
    // MARK: - 댓글 관련
    @Published var buttonOnOff: Bool = false
    @Published var comments: [Comment] = []
    @Published var commentText: String = ""
    @Published var commentUserIDs: [String] = []
    @Published var commentUsers: [String: User] = [:]
    @Published var documentID: String = ""
    @Published var isFocused: Bool = false
    @Published var isHeartCheck: Bool = true
    @Published var isFetchedComment: Bool = false
    @Published var isShowingReplyCommentWriteView: Bool = false
    @Published var isShowingCommentWriteView: Bool = false
    @Published var isShowingReportView: Bool = false
    @Published var isShowingHeartUserView: Bool = false
    @Published var isShowingLoginPage: Bool = false
    @Published var inputcomment: String = ""
    @Published var replyComments: [String: ReplyComment] = [:]
    @Published var selectedComment: Comment?
    @Published var selectedReplyComment: ReplyComment?
    @Published var showDeleteModal: Bool = false
    @Published var showDeleteReplyModal: Bool = false
    @Published var showReplyComment = "hide"
    @Published var showReportModal: Bool = false
    @Published var showReportReplyModal: Bool = false
    
 
    let db = Firestore.firestore()
    
    // MARK: - PhotoMoji 관련
    @Published var photoMojiUIImage: UIImage?
    @Published var cropMojiUIImage: UIImage?
    @Published var cropMojiImage: Image = Image("")
    @Published var photoMojies: [PhotoMoji] = []
    @Published var deletePhotoMojiModal: Bool = false
    @Published var showCropPhotoMoji: Bool = false
    @Published var showEmojiView: Bool = false
    @Published var selectedEmoji: String = ""
    @Published var selectedPhotoMoji: PhotoMoji?
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    @Published var offset: CGSize = .zero
    @Published var lastStoredOffset: CGSize = .zero
    @Published var showinGrid: Bool = false

    @MainActor
    func getCommentsDocument(post: Post) async {
        guard let postID = post.id else { return }
        do {
            let querySnapshot = try await db.collection("post").document(postID).collection("comment").order(by: "time", descending: false).getDocuments()
            let comments = querySnapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
            print(comments)
            let filteredComments = filterBlockedComments(comments: comments)
            
            self.comments = filteredComments
        } catch {
            print("Error fetching comments: \(error)")
        }
        return
    }
    
    //  댓글 작성 및 프로필 이미지 URL 반환
    func writeComment(post: Post,
                      imageUrl: String,
                      inputcomment: String) async {
        
        guard !userNameID.isEmpty else { return }
        
        let initialPostData : [String: Any] = [
            "userID": userNameID,
            "content": inputcomment,
            "time": Timestamp(),
            "heartIDs": [],
            "replyComments": []
        ]
        await createCommentData(post: post,
                                data: initialPostData)
    }
    
    func createCommentData(post: Post, data: [String: Any]) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ"
        
        let formattedDate = dateFormatter.string(from: Date())
        let formattedCommentTitle = userNameID+formattedDate
        guard let postID = post.id else { return }
        do {
            // 포스트에서 댓글을 보여주기 위해 만들어줌
            try await db.collection("post").document(postID).collection("comment").document(formattedCommentTitle).setData(data)
            
            try await db.collection("post").document(postID).updateData(["commentCount": post.commentCount + 1])
            
            await getCommentsDocument(post: post)
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
    }
    
    // 댓글 삭제 함수에 commentID = 댓글 서브 컬렉션의 DocumentID 매개변수
    func deleteComment(post: Post, commentID: String) async {
        guard let postID = post.id else { return }
        do {
            // 포스트의 'comment' 컬렉션에서 특정 댓글 삭제
            var count = 1
            
            let index = comments.firstIndex {
                $0.id == commentID
            }
            if let index = index, !comments[index].replyComments.isEmpty {
                let querySnapshot = try await db.collection("post").document(postID).collection("comment").document(commentID).collection("replyComments").getDocuments()
            
                for queryDocument in querySnapshot.documents {
                    try await db.collection("post").document(postID).collection("comment").document(commentID).collection("replyComments").document(queryDocument.documentID).delete()
                    count += 1
                }
            }
            
            try await db.collection("post").document(postID).collection("comment").document(commentID).delete()
            
            try await db.collection("post").document(postID).updateData(["commentCount": post.commentCount-count])
            
            await getCommentsDocument(post: post)
            // 성공적으로 삭제됐다는 메시지 출력
            print(commentID)
            print("댓글이 성공적으로 삭제되었습니다.")
        } catch {
            print("댓글 삭제 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
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
    @MainActor
    func getReplyCommentsDocument(post: Post, index: Int) async {
        guard let postID = post.id else { return }
        guard let commentID = comments[index].id else { return }
        
        do {
            let querySnapshot = try await db.collection("post").document(postID).collection("comment")
                .document(commentID).collection("replyComments")
                .order(by: "time", descending: false).getDocuments()
            
            let fetchCommentData = querySnapshot.documents.compactMap { document in
                try? document.data(as: ReplyComment.self)
            }
            
            let filteredComments = filterBlockedReplyComments(comments: fetchCommentData)
            for replyComment in filteredComments {
                if let replyCommentId = replyComment.id {
                    replyComments[replyCommentId] = replyComment
                }
            }
        } catch {
            print("Error fetching comments: \(error)")
        }
    }
    
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
    
    @MainActor
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
    
    // 대댓글 좋아요
    @MainActor
    func addReplyCommentHeart(post: Post, index: Int, replyComment: ReplyComment) async {
        guard !userNameID.isEmpty else { return }
        guard let postID = post.id else { return }
        guard let commentID = comments[index].id else { return }
        guard let replyCommentID = replyComment.id else { return }
        do {
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(postID).collection("comment").document(commentID).collection("replyComments").document(replyCommentID)
                
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return
                }
                
                guard var replyCommentHeartIDs = postDocument.data()?["heartIDs"] as? [String] else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "하트준 ID값들에 접근 못함 \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return
                }
                guard !replyCommentHeartIDs.contains(userNameID) else { return }
                
                replyCommentHeartIDs.append(userNameID)
                transaction.updateData(["heartIDs": replyCommentHeartIDs], forDocument: postRef)
                
                DispatchQueue.main.async {
                    if var newDictionaryData: ReplyComment = self.replyComments[replyCommentID] {
                        var newArray = newDictionaryData.heartIDs
                        newArray.append(userNameID)
                        newDictionaryData.heartIDs = newArray
                        self.replyComments[replyCommentID] = newDictionaryData
                    }
                }
            
                return
            })
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        return
    }
    
    // 대댓글 좋아요 삭제
    @MainActor
    func deleteReplyCommentHeart(post: Post, index: Int, replyComment: ReplyComment) async {
        guard !userNameID.isEmpty else { return }
        guard let postID = post.id else { return }
        guard let commentID = comments[index].id else { return }
        guard let replyCommentID = replyComment.id else { return }

        do {
            _ = try await db.runTransaction({ (transaction, errorPointer) in
                let postRef = self.db.collection("post").document(postID).collection("comment").document(commentID).collection("replyComments").document(replyCommentID)
                
                let postDocument: DocumentSnapshot
                
                do {
                    try postDocument = transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return
                }
                
                guard var replyCommentHeartIDs = postDocument.data()?["heartIDs"] as? [String] else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "하트준 ID값들에 접근 못함 \(postDocument)"
                    ])
                    errorPointer?.pointee = error
                    return
                }
                
                guard let removeIndex = replyCommentHeartIDs.firstIndex(of: userNameID) else { return }
                
                replyCommentHeartIDs.remove(at: removeIndex)

                transaction.updateData(["heartIDs": replyCommentHeartIDs], forDocument: postRef)
                
                DispatchQueue.main.async {
                    if var newDictionaryData: ReplyComment = self.replyComments[replyCommentID] {
                        var newArray = newDictionaryData.heartIDs
                        guard let index = newArray.firstIndex(of: userNameID) else { return }
                        newArray.remove(at: index)
                        newDictionaryData.heartIDs = newArray
                        self.replyComments[replyCommentID] = newDictionaryData
                    }
                }
                
                
                return
            })
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // 대댓글 좋아요 체크
    func checkReplyCommentHeartExists(replyComment: ReplyComment) -> Bool {
        guard !userNameID.isEmpty else { return false }
        return replyComment.heartIDs.contains(userNameID)
    }
}

extension CommentViewModel {
    private func filterBlockedComments(comments: [Comment]) -> [Comment] {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        let filteredComments = comments.filter { comment in
            !blockedUserIDs.contains(comment.userID)
        }
        
        return filteredComments
    }
    
    private func filterBlockedReplyComments(comments: [ReplyComment]) -> [ReplyComment] {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        let filteredComments = comments.filter { comment in
            !blockedUserIDs.contains(comment.userID)
        }
        
        return filteredComments
    }
}
