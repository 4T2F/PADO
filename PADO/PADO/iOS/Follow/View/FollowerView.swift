//
//  FollowerView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowerView: View {
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
                VStack {
                    SearchBar(text: searchTextBinding,
                              isLoading: $followVM.isLoading)
                        .padding()
                    
                    ScrollView(.vertical) {
                        if !followVM.surferIDs.isEmpty {
                            HStack{
                                Text("내 서퍼")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding()
                                Spacer()
                            } //: HSTACK
                            .padding(.leading)
                            .padding(.bottom)
                            
                            ForEach(followVM.surferIDs, id: \.self) { surferId in
                                FollowerUserCellView(cellUserId: surferId, sufferset: .removesuffer)
                                    .padding(.vertical)
                            }
                        }
                        HStack{
                            Text("팔로워")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        } //: HSTACK
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        ForEach(followVM.followerIDs, id: \.self) { followerId in
                            FollowerUserCellView(cellUserId: followerId, sufferset: .setsuffer)
                                .padding(.vertical)
                        }
                    } //: SCROLL
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
    }
}
