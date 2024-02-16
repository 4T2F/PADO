//
//  SettingBlockUser.swift
//  PADO
//
//  Created by 강치우 on 2/16/24.
//

import SwiftUI

struct SettingBlockUserView: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(blockingUser) { user in
                Text(user.blockUserID)
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
            }
        }
        .onAppear {
            Task {
                await profileVM.fetchBlockUsers()
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("차단 목록")
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
                        
                        Text("뒤로")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
}