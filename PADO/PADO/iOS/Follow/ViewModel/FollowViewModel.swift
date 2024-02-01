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

class FollowViewModel: ObservableObject, Searchable {
    
    @Published var followerIDs: [String] = []
    @Published var followingIDs: [String] = []
    @Published var surferIDs: [String] = []
    @Published var surfingIDs: [String] = []
    
    @Published var isLoading: Bool = false
    @Published var profileFollowId = ""
    @State var progress: Double = 0
    
    @Published var searchResults: [User] = []
    @Published var viewState: ViewState = ViewState.empty
    

    func initializeFollowFetch() {
        fetchIDs(id: profileFollowId, collectionType: CollectionType.follower)
        fetchIDs(id: profileFollowId, collectionType: CollectionType.following)
        fetchIDs(id: profileFollowId, collectionType: CollectionType.surfer)
        fetchIDs(id: profileFollowId,collectionType: CollectionType.surfing)
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
}
