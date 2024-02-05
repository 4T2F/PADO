//
//  SettingProfileModal.swift
//  PADO
//
//  Created by 황성진 on 2/5/24.
//

import PhotosUI
import SwiftUI

struct SettingProfileModal: View {
    var body: some View {
        VStack {
            Button {
                showProfileModal
            } label: {
                Text("프로필 사진 변경")
                    .foregroundStyle(.white)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            .background(.grayButton)
            .cornerRadius(10)
            .padding(.vertical)
            
            Button {
                print("2")
            } label: {
                Text("배경 사진 변경")
                    .foregroundStyle(.white)
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
