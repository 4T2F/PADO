//
//  FollowViewModel.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

enum CollectionType {
    case follower
    case following
    case surfer
    case surfing
    
    var collectionName: String {
        switch self {
        case .follower:
            return "follower"
        case .following:
            return "following"
        case .surfer:
            return "surfer"
        case .surfing:
            return "surfing"
        }
    }
}

enum SearchFollowType {
    case follower
    case following
}

class FollowViewModel: ObservableObject, Searchable {
    
    @Published var followerIDs: [String] = []
    @Published var followingIDs: [String] = []
    @Published var surferIDs: [String] = []
    @Published var surfingIDs: [String] = []
    
    @Published var searchedFollower: [String] = []
    @Published var searchedSurfer: [String] = []
    @Published var searchedFollowing: [String] = []
    
    @Published var isLoading: Bool = false
    @State var progress: Double = 0
    
    // 서퍼지정 관련 변수들
    @Published var showSurfingList: Bool = false
    @Published var selectSurfingID: String = ""
    @Published var selectSurfingUsername: String = ""
    @Published var selectSurfingProfileUrl: String = ""
    
    @Published var searchResults: [User] = []
    @Published var viewState: ViewState = ViewState.empty
    

    func initializeFollowFetch(id: String) {
        fetchIDs(id: userNameID, collectionType: CollectionType.follower)
        fetchIDs(id: userNameID, collectionType: CollectionType.following)
        fetchIDs(id: userNameID, collectionType: CollectionType.surfer)
        fetchIDs(id: userNameID, collectionType: CollectionType.surfing)
    }
    
    //  파라미터로 넣은 id값을 가진 문서 내용들 불러오는 스냅샷
    func fetchIDs(id: String, collectionType: CollectionType) {
        self.isLoading = true
        let db = Firestore.firestore()
        db.collection("users").document(id).collection(collectionType.collectionName).addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                self.isLoading = false
                return
            }
            
            var ids: [String] = []
            for document in documents {
                if let documentId = document.data()["\(collectionType.collectionName)ID"] as? String {
                    ids.append(documentId)
                }
            }
            
            DispatchQueue.main.async {
                switch collectionType {
                case .follower:
                    self.followerIDs = ids
                case .following:
                    self.followingIDs = ids
                case .surfer:
                    self.surferIDs = ids
                case .surfing:
                    self.surfingIDs = ids
                }
                self.isLoading = false
            }
        }
    }
    
    func searchFollowers(with str: String, type: SearchFollowType) {
        setViewState(to: .loading)
        self.isLoading = true
        if str.count > 0 {
            switch type {
            case .follower:
                searchedFollower = followerIDs.filter { $0.hasPrefix(str) }
                searchedSurfer = surferIDs.filter { $0.hasPrefix(str) }
            case .following:
                searchedFollowing = followingIDs.filter { $0.hasPrefix(str) }
            }
            self.isLoading = false
            setViewState(to: .ready)
        }
    }
}
