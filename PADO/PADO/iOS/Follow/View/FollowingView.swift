//
//  FollowingView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowingView: View {
    // MARK: - PROPERTY
    @Environment (\.dismiss) var dismiss
    @State private var searchText: String = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var followVM: FollowViewModel
    
    let updateFollowData = UpdateFollowData()
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return searchText
        } set: {
            searchText = $0
            followVM.updateSearchText(with: $0)
        }
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                VStack {
                    SearchBar(text: searchTextBinding,
                              isLoading: $followVM.isLoading)
                    .padding()
                    
                    ScrollView {
                        HStack{
                            Text("팔로잉")
                                .font(.system(size: 14, weight: .semibold))
                
                            Spacer()
                        } //: HSTACK
                        .padding(.leading)
                        .padding(.bottom)
                        
                        ForEach(followVM.followingIDs, id: \.self) { followingID in
                            FollowingCellView(cellUserId: followingID,
                                              updateFollowData: updateFollowData)
                                .padding(.vertical)
                        }
                    } //: SCROLL
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
        .onDisappear {
           updateFollowData.fetchFollowStatusData()
        }
    }
}
