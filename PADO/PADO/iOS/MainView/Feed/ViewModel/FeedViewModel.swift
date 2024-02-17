//
//  ViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/23/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

let developerIDs: [String] = ["pado", "hanami", "legendboy", "goat", "king"]

protocol FeedItem {}

extension Post: FeedItem {}
extension User: FeedItem {}

@MainActor
class FeedViewModel:Identifiable ,ObservableObject {

    // MARK: - feed관련
    @Published var isShowingReportView = false
    @Published var isShowingCommentView = false
    @Published var isHeaderVisible = true
  
    @Published var followingPosts: [Post] = []
    @Published var todayPadoPosts: [Post] = []
    @Published var watchedPostIDs: Set<String> = []
    @Published private var popularUsersSet: Set<User> = []
    @Published var popularUsers: [User] = []
    
    @Published var feedItems: [FeedItem] = []
    
    @Published var selectedFeedCheckHeart: Bool = false
    @Published var postFetchLoading: Bool = false
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    @Published var documentID: String = ""
    
    @Published var lastFollowFetchedDocument: DocumentSnapshot? = nil
    @Published var lastTodayPadoFetchedDocument: DocumentSnapshot? = nil
    
    // MARK: - 파도타기 관련
    @Published var padoRidePosts: [PadoRide] = []
    @Published var currentPadoRideIndex: Int? = nil
    @Published var isShowingPadoRide: Bool = false
    
    
    func getPopularUser() async {
        let querySnapshot = db.collection("users")
            .whereField("profileImageUrl", isNotEqualTo: NSNull())
            .limit(to: 20)
        
        let developerSnapshot = db.collection("users")
            .whereField("nameID", in: developerIDs)
       
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("users"), query: querySnapshot)
                
            let developerDocuments = try await getDocumentsAsync(collection: db.collection("users"), query: developerSnapshot)
            
            let newUsers = documents.compactMap { document in
                try? document.data(as: User.self)
            }
            
            let developerUsers = developerDocuments.compactMap { document in
                try? document.data(as: User.self)
            }
            
            // Set을 사용하여 popularUsers 업데이트
            self.popularUsersSet = self.popularUsersSet.union(newUsers)
            self.popularUsersSet = self.popularUsersSet.union(developerUsers)
            
            let usersSet = self.popularUsersSet.filter {
                $0.nameID != userNameID
            }
            
            self.popularUsers = Array(Array(usersSet).prefix(5))
            
        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    // Firestore의 getDocuments에 대한 비동기 래퍼 함수
    func getDocumentsAsync(collection: CollectionReference, query: Query) async throws -> [QueryDocumentSnapshot] {
        try await withCheckedThrowingContinuation { continuation in
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let querySnapshot = querySnapshot {
                    continuation.resume(returning: querySnapshot.documents)
                } else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    // 팔로잉 중인 사용자들로부터 포스트 가져오기 (비동기적으로)
    func fetchFollowingPosts() async {
        followingPosts.removeAll()
        feedItems.removeAll()
        lastFollowFetchedDocument = nil
        guard !userFollowingIDs.isEmpty else {
            Task {
                await getPopularUser()
            }
            return
        }
        var getFollowingPostIDs = userFollowingIDs
        getFollowingPostIDs.append(userNameID)
        // 현재 날짜로부터 2일 전의 날짜를 계산
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
           // Date 객체를 Timestamp로 변환
        let twoDaysAgoTimestamp = Timestamp(date: twoDaysAgo)
        
        let query = db.collection("post")
            .whereField("ownerUid", in: getFollowingPostIDs)
            .whereField("created_Time", isGreaterThanOrEqualTo: twoDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .limit(to: 6)
        
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            
            let filteredDocuments = documents.compactMap { document -> DocumentSnapshot? in
                if (try? document.data(as: Post.self)) != nil {
                    return document
                } else {
                    return nil
                }
            }
            
            self.lastFollowFetchedDocument = filteredDocuments.last
            
            let fetchedFollowingPosts = filteredDocuments.compactMap { document in
                try? document.data(as: Post.self)
            }
            
            self.followingPosts = fetchedFollowingPosts.sorted {
                $0.created_Time.dateValue() > $1.created_Time.dateValue()
            }
            
            self.followingPosts = filterBlockedPosts(posts: self.followingPosts)
            
            for document in filteredDocuments {
                guard let post = try? document.data(as: Post.self) else { continue }
                setupSnapshotFollowingListener(for: post)
            }
            
            await getPopularUser()

        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
        
    }
    
    // 오늘 파도 포스트 가져오기
    func fetchTodayPadoPosts() async {
        todayPadoPosts.removeAll()

        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let threeDaysAgoTimestamp = Timestamp(date: threeDaysAgo)

        let query = db.collection("post")
            .whereField("created_Time", isGreaterThanOrEqualTo: threeDaysAgoTimestamp)
        
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            var filteredPosts = documents.compactMap { document in
                try? document.data(as: Post.self)
            }

            filteredPosts.sort { $0.heartsCount > $1.heartsCount }

            for post in filteredPosts.prefix(20) {
                setupSnapshotTodayPadoListener(for: post)
            }

            // 인덱스 20개 초과 시 0~24번 인덱스까지만 포함
            self.todayPadoPosts = Array(filteredPosts.prefix(25))
            self.todayPadoPosts = filterBlockedPosts(posts: self.todayPadoPosts)
        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }

    
    func fetchFollowMorePosts() async {
        guard let lastDocument = lastFollowFetchedDocument else { return }
        
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let twoDaysAgoTimestamp = Timestamp(date: twoDaysAgo)
        
        var getFollowingPostIDs = userFollowingIDs
        getFollowingPostIDs.append(userNameID)
        
        let query = db.collection("post")
            .whereField("ownerUid", in: getFollowingPostIDs)
            .whereField("created_Time", isGreaterThanOrEqualTo: twoDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: 3)
            
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            
            self.lastFollowFetchedDocument = documents.last
            var documentsData = documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            .filter { post in
                userFollowingIDs.contains(where: { $0 == post.ownerUid })
            }
            
            documentsData = filterBlockedPosts(posts: documentsData)
      
            for documentData in documentsData {
                setupSnapshotFollowingListener(for: documentData)
                feedItems.append(documentData)
            }
            
        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
    
    private func cacheWatchedData() async {
        do {
            let documents = try await db.collection("users").document(userNameID).collection("watched").getDocuments()
            self.watchedPostIDs = Set(documents.documents.compactMap { $0.documentID })
        } catch {
            print("Error fetching watched data: \(error.localizedDescription)")
        }
    }
    
    func setupProfileImageURL(id: String) async -> String {
        guard !id.isEmpty else { return "" }
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").document(id).getDocument()
            
            guard let user = try? querySnapshot.data(as: User.self) else {
                print("Error: User data could not be decoded")
                return ""
            }
            
            guard let profileImage = user.profileImageUrl else { return "" }
            
            return profileImage
            
        } catch {
            print("Error fetching user: \(error)")
        }
        
        return ""
    }
  
    func watchedPost(_ story: Post) async {
        do {
            if let postID = story.id {
                try await db.collection("users").document(userNameID).collection("watched")
                    .document(postID).setData(["created_Time": story.created_Time,
                                               "watchedPost": postID])
                self.watchedPostIDs.insert(postID)
            }
        } catch {
            print("Error : \(error)")
        }
    }
    
    // 파도타기 게시글 불러오기
    func fetchPadoRides(postID: String) async {
        padoRidePosts.removeAll()

        let postRef = db.collection("post").document(postID)
        let padoRideCollection = postRef.collection("padoride")

        do {
            let snapshot = try await padoRideCollection.getDocuments()
            self.padoRidePosts = snapshot.documents.compactMap { document in
                try? document.data(as: PadoRide.self)
            }
        } catch {
            print("PadoRides 가져오기 오류: \(error.localizedDescription)")
        }
    }
}

extension FeedViewModel {
    @MainActor
    private func setupSnapshotFollowingListener(for post: Post) {
        guard let postID = post.id else { return }

        let docRef = db.collection("post").document(postID)
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let index = self.followingPosts.firstIndex(where: { $0.id == postID }) {
                self.followingPosts[index].heartsCount = data["heartsCount"] as? Int ?? 0
                self.followingPosts[index].commentCount = data["commentCount"] as? Int ?? 0
            }
        }
    }
    
    @MainActor
    func setupSnapshotTodayPadoListener(for post: Post) {
        guard let postID = post.id else { return }

        let docRef = db.collection("post").document(postID)
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let index = self.todayPadoPosts.firstIndex(where: { $0.id == postID }) {
                self.todayPadoPosts[index].heartsCount = data["heartsCount"] as? Int ?? 0
                self.todayPadoPosts[index].commentCount = data["commentCount"] as? Int ?? 0
            }
        }
    }
}

// Timestamp 형식의 시간을 가져와서 날짜 및 시간 형식으로 변환
extension Timestamp {
    func formatDate(_ timestamp: Timestamp) -> String {
        let currentDate = Date() // 현재 날짜 및 시간
        let date = timestamp.dateValue() // Timestamp를 Date로 변환
        let calendar = Calendar.current

        let hoursAgo = calendar.dateComponents([.hour], from: date, to: currentDate).hour ?? 0
        let minutesAgo = calendar.dateComponents([.minute], from: date, to: currentDate).minute ?? 0
        let secondsAgo = calendar.dateComponents([.second], from: date, to: currentDate).second ?? 0
        
        switch hoursAgo {
        case 24...:
            // 1일보다 오래된 경우
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // AM/PM을 포함하는 날짜 형식 지정
            return formatter.string(from: date)
        case 1...:
            // 1시간 이상, 1일 미만
            return "\(hoursAgo)시간 전"
            
        default:
            // 1시간 미만
            if minutesAgo >= 1 {
                return "\(minutesAgo)분 전"
            } else {
                return "\(secondsAgo)초 전"
            }
        }
    }
    
    func convertTimestampToString(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue() // Timestamp를 Date로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ" // 원하는 날짜 형식 설정
        let dateString = dateFormatter.string(from: date) // Date를 String으로 변환
        return dateString
    }
}

// 차단된 사용자의 게시물 필터링
extension FeedViewModel {
    private func filterBlockedPosts(posts: [Post]) -> [Post] {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return posts.filter { post in
            !blockedUserIDs.contains(post.ownerUid) && !blockedUserIDs.contains(post.surferUid)
        }
    }
}

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
