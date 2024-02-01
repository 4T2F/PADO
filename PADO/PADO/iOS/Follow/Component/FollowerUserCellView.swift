//
//  FollowerUserCellView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowerUserCellView: View {
    @ObservedObject var followVM: FollowViewModel
    
    @State private var followerUsername: String = ""
    @State private var followerProfileUrl: String = ""
    @State private var showingModal: Bool = false
    
    let cellUserId: String
    
    enum SufferSet: String {
        case removesuffer = "서퍼 해제"
        case setsuffer = "서퍼 등록"
    }
    
    @State private var buttonActive: Bool = false
    @State var transitions: Bool = false
    
    let sufferset: SufferSet
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                KFImage.url(URL(string: followerProfileUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(cellUserId)
                        .font(.system(size: 14, weight: .semibold))
                    if !followerUsername.isEmpty {
                        Text(followerUsername)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color(.systemGray))
                    }
                } //: VSTACK
            }
            
            Spacer()
            
            Button {
                showingModal.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(.trailing)
            }
            
        } // :HSTACK
        .padding(.vertical, -12)
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let userProfile = await updateUserData.getOthersProfileDatas(id: cellUserId) {
                    self.followerUsername = userProfile.username
                    self.followerProfileUrl = userProfile.profileImageUrl ?? ""
                }
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
