//
//  SearchViewModel.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

//
//var searchDatas: [String] {
//    get {
//        UserDefaults.standard.array(forKey: "searchData") as? [String] ?? [""]
//    }
//    set {
//        UserDefaults.standard.set(newValue, forKey: "searchData")
//    }
//}
//

class SearchViewModel: ObservableObject, Searchable {
    @Published var isLoading: Bool = false
    @State var progress: Double = 0
    
    @Published var searchResults: [User] = []
    @Published var viewState: ViewState = ViewState.empty
        
    let db = Firestore.firestore()
    
    public func updateSearchText(with text: String) {
        setViewState(to: .loading)
        if text.count > 0 {
            Task {
                await searchUserData(str: text)
            }
        }
    }
    
    @MainActor
    func searchUserData(str: String) async {
        isLoading = true
        viewState = .loading
        
        let strNext = str + "\u{f8ff}"
        let nameIDQuery = db.collection("users")
            .whereField("nameID", isGreaterThanOrEqualTo: str)
            .whereField("nameID", isLessThan: strNext)

        let usernameQuery = db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: str)
            .whereField("username", isLessThan: strNext)
        
        do {
            let nameIDResults = try await nameIDQuery.getDocuments()
            let usernameResults = try await usernameQuery.getDocuments()


            let nameIDUsers = nameIDResults.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
            }

            let usernameUsers = usernameResults.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
            }

            // 두 결과의 합집합을 구하고 중복 제거
            let combinedResults = Array(Set(nameIDUsers + usernameUsers))

            self.searchResults = combinedResults
            viewState = searchResults.isEmpty ? .empty : .ready
        } catch {
            print("Error getting documents: \(error)")
            viewState = .error
        }
        
        isLoading = false
    }
    
//    @MainActor
//    func searchUserData(str: String) async {
//        isLoading = true
//        viewState = .loading
//        
//        let strNext = str + "\u{f8ff}"
//        let query = db.collection("users")
//            .whereField("nameID", isGreaterThanOrEqualTo: str)
//            .whereField("nameID", isLessThan: strNext)
//        
//        do {
//            let querySnapshot = try await query.getDocuments()
//            self.searchResults = querySnapshot.documents.compactMap { document in
//                try? document.data(as: User.self)
//            }
//            viewState = searchResults.isEmpty ? .empty : .ready
//        } catch {
//            print("Error getting documents: \(error)")
//            viewState = .error
//        }
//        
//        isLoading = false
//    }
}
