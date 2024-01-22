//
//  FollowViewModel.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import SwiftUI

class FollowViewModel: ObservableObject, Searchable {
    @Published var isLoading: Bool = false
    @State var progress: Double = 0
    
    @Published var searchResult: [User] = []
    @Published var viewState: ViewState = ViewState.empty
        
}



