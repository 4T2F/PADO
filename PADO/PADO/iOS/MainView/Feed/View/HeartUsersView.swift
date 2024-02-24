//
//  HeartUsersView.swift
//  PADO
//
//  Created by 최동호 on 2/25/24.
//

import Lottie
import SwiftUI

struct HeartUsersView: View {
    // MARK: - PROPERTY
    @Environment(\.dismiss) var dismiss
    
    let userIDs: [String]
    @State var users: [User] = []
    @State private var fetchedData: Bool = false
    
    // MARK: - BODY
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
                    LottieView(animation: .named("Loading"))
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
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Text("닫기")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .toolbarBackground(Color(.modal), for: .navigationBar)
        }
        .onAppear {
            Task {
                for id in userIDs {
                    if let user = await UpdateUserData.shared.getOthersProfileDatas(id: id) {
                        self.users.append(user)
                    }
                }
                fetchedData = true
            }
        }
    }
}
