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

@MainActor
class FeedViewModel:Identifiable ,ObservableObject {

    // MARK: - feed관련
    @Published var isShowingReportView = false
    @Published var isShowingCommentView = false
    @Published var isHeaderVisible = true
  
    @Published var followingPosts: [Post] = []
    @Published var todayPadoPosts: [Post] = []
    @Published var watchedPostIDs: Set<String> = []
    
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
    
    init() {
        // Firestore의 `post` 컬렉션에 대한 실시간 리스너 설정
        Task {
            findFollowingUsers()
            await fetchTodayPadoPosts()
        }
    }
    
    func findFollowingUsers() {
        guard !userNameID.isEmpty else { return }
        
        userFollowingIDs.removeAll()
        listener = db.collection("users").document(userNameID).collection("following").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self, let documents = querySnapshot?.documents else {
                print("Error fetching following users: \(error?.localizedDescription ?? "Unknown error")")
                return
                
            }
            
            userFollowingIDs = documents.compactMap { $0.data()["followingID"] as? String }
            
            Task {
                self.postFetchLoading = true
                await self.cacheWatchedData()
                await self.fetchFollowingPosts()
                self.postFetchLoading = false
            }
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
    private func fetchFollowingPosts() async {
        followingPosts.removeAll()
        lastFollowFetchedDocument = nil
        guard !userFollowingIDs.isEmpty else { return }
        
        // 현재 날짜로부터 2일 전의 날짜를 계산
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
           // Date 객체를 Timestamp로 변환
        let twoDaysAgoTimestamp = Timestamp(date: twoDaysAgo)
        
        let query = db.collection("post")
            .whereField("ownerUid", in: userFollowingIDs)
            .whereField("created_Time", isGreaterThanOrEqualTo: twoDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .limit(to: 5)
        
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

               for document in filteredDocuments {
                   guard let post = try? document.data(as: Post.self) else { continue }
                   setupSnapshotFollowingListener(for: post)
               }
           } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
        self.followingPosts.sort {
            !self.watchedPostIDs.contains($0.id ?? "") && self.watchedPostIDs.contains($1.id ?? "")
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

            // 인덱스 20개 초과 시 0~19번 인덱스까지만 포함
            self.todayPadoPosts = Array(filteredPosts.prefix(20))

        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }

    
    func fetchFollowMorePosts() async {
        guard let lastDocument = lastFollowFetchedDocument else { return }
        
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let twoDaysAgoTimestamp = Timestamp(date: twoDaysAgo)
        
        let query = db.collection("post")
            .whereField("created_Time", isGreaterThanOrEqualTo: twoDaysAgoTimestamp)
            .order(by: "created_Time", descending: true)
            .order(by: "heartsCount", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: 3)
            
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
            
            self.lastFollowFetchedDocument = documents.last
            let documentsData = documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            .filter { post in
                userFollowingIDs.contains(where: { $0 == post.ownerUid })
            }
      
            for documentData in documentsData {
                setupSnapshotFollowingListener(for: documentData)
                self.followingPosts.append(documentData)
            }

        } catch {
            print("포스트 가져오기 오류: \(error.localizedDescription)")
        }
    }
    
//    func fetchTodayPadoMorePosts() async {
//        guard let lastDocument = lastTodayPadoFetchedDocument else { return }
//    
//        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
//           // Date 객체를 Timestamp로 변환
//        let sevenDaysAgoTimestamp = Timestamp(date: sevenDaysAgo)
//        
//        let query = db.collection("post")
//            .whereField("created_Time", isGreaterThanOrEqualTo: sevenDaysAgoTimestamp)
//            .start(afterDocument: lastDocument)
//            .limit(to: 3)
//        
//        do {
//            let documents = try await getDocumentsAsync(collection: db.collection("post"), query: query)
//            let documentsData = documents.compactMap { document in
//                try? document.data(as: Post.self)
//            }
//            self.lastTodayPadoFetchedDocument = documents.last
//            for documentData in documentsData {
//                self.todayPadoPosts.append(documentData)
//            }
//        } catch {
//            print("포스트 가져오기 오류: \(error.localizedDescription)")
//        }
//    }
    
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

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
