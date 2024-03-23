//
//  HeartUsersView.swift
//  PADO
//
//  Created by 최동호 on 2/25/24.
//

import Lottie
import SwiftUI

struct HeartUsersView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var users: [User] = []
    @State private var fetchedData: Bool = false
    
    let userIDs: [String]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if fetchedData {
                    VStack {
                        ForEach(users) { user in
                            HeartUserCell(user: user)
                                .padding(.vertical)
                        }
                    }
                } else {
                    LottieView(animation: .named(LottieType.loading.rawValue))
                        .looping()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 60)
                }
            }
            .background(.modal, ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("좋아요")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            
                            Text("닫기")
                                .font(.system(.body))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .toolbarBackground(Color(.modal), for: .navigationBar)
        }
        .task {
            for id in userIDs {
                if let user = await UpdateUserData.shared.getOthersProfileDatas(id: id) {
                    self.users.append(user)
                }
            }
            fetchedData = true
        }
    }
}
