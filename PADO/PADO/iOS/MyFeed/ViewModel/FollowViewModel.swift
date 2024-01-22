//
//  FollowViewModel.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import SwiftUI

class FollowViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @State var progress: Double = 0
    
    @Published var searchResult: [User] = []
    @Published var viewState: ViewState = ViewState.empty
        
    public func updateSearchText(with text: String) {
        setViewState(to: .loading)
        if text.count > 0 {
            getSearchResults(forText: text)
        }
    }
    
    private func getSearchResults(forText text: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.searchResult.count == 0 {
                // Empty view
                self.setViewState(to: .empty)
            } else {
                self.setViewState(to: .ready)
            }
        }
    }
    
    private func setViewState(to state: ViewState) {
        DispatchQueue.main.async {
            self.viewState = state
            self.isLoading = state == . loading
        }
    }
}



