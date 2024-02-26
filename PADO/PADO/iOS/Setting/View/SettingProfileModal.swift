//
//  SettingProfileModal.swift
//  PADO
//
//  Created by 황성진 on 2/5/24.
//

import PhotosUI
import SwiftUI

struct SettingProfileModal: View {
    // MARK: - PROPERTY
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @Binding var isActive: Bool
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Button {
                viewModel.showProfileModal = false
            } label: {
                PhotosPicker(selection: $viewModel.selectedItem,
                             matching: .images) {
                    Text("프로필 사진 변경")
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .background(.modalCell)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                }
            }
            
            Button {
                viewModel.showProfileModal = false
            } label: {
                PhotosPicker(selection: $viewModel.selectedBackgroundItem,
                             matching: .images) {
                    Text("배경 사진 변경")
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .background(.modalCell)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                }
            }
            
            Button {
                viewModel.showProfileModal = false
                viewModel.currentUser?.profileImageUrl = ""
                isActive = true
                Task {
                    try await DeleteImageUrl.shared.deleteProfileURL()
                }
            } label: {
                Text("프로필 사진 초기화")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.modalCell)
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
            
            Button {
                viewModel.showProfileModal = false
                viewModel.currentUser?.backProfileImageUrl = ""
                isActive = true
                Task {
                    try await DeleteImageUrl.shared.deleteBackURL()
                }
            } label: {
                Text("배경 사진 초기화")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.modalCell)
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
        }
    }
}

