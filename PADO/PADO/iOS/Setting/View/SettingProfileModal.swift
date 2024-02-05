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
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Button {
                viewModel.showProfileModal = false
            } label: {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    Text("프로필 사진 변경")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            .background(.grayButton)
            .cornerRadius(10)
            .padding(.vertical)
            
            Button {
                viewModel.showProfileModal = false
            } label: {
                PhotosPicker(selection: $viewModel.selectedBackgroundItem) {
                    Text("배경 사진 변경")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            .background(.grayButton)
            .cornerRadius(10)
        }
    }
}

#Preview {
    SettingProfileModal()
}
