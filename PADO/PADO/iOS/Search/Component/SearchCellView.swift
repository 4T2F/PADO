//
//  FriendCellView.swift
//  BeReal
//
//  Created by 최동호 on 1/2/24.
//
// ITEM

import Kingfisher
import SwiftUI

struct SearchCellView: View {
    // MARK: - PROPERTY
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var searchVM: SearchViewModel
    
    @State var buttonOnOff: Bool = false
    
    let user: User

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                         user: user)
                        .onAppear {
                            searchVM.addSearchData(user.nameID)
                        }
                } label: {
                    HStack(spacing: 0) {
                        if let image = user.profileImageUrl {
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(40)
                                .padding(.trailing)
                        } else {
                            Image("defaultProfile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(40)
                                .padding(.trailing)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.nameID)
                                .foregroundStyle(.white)
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            if !user.username.isEmpty {
                                Text(user.username)
                                    .font(.system(.subheadline))
                                    .fontWeight(.regular)
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                        Spacer()
                    }
                }
                
            } //: HSTACK
            .padding(.horizontal)
        } //: NAVI
        .onAppear {
            self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: user.nameID)
        }
    }
}
