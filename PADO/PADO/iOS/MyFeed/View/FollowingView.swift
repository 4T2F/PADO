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
                ZStack {
                    Text("팔로잉")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    SearchBar(text: searchTextBinding,
                              isLoading: $followVM.isLoading)
                    .padding()
                    
                    ScrollView {
                        ForEach(followVM.followingIDs, id: \.self) { followingID in
                            FollowingCellView(cellUserId: followingID)
                                .padding(.vertical)
                        }
                    } //: SCROLL
                } //: VSTACK
                
            } //: VSTACK
            
        } //: ZSTACK
    }
}
