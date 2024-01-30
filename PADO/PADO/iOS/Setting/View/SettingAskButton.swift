//
//  SettingAskButton.swift
//  PADO
//
//  Created by 김명현 on 1/30/24.
//

import SwiftUI

struct SettingAskButton: View {
    @Binding var askSeletedImage: Image
    @Binding var isShowingAskImage: Bool
    @EnvironmentObject var viewModel: SurfingViewModel
    
    
    var body: some View {
        
        Image("addFileButton")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                viewModel.showPhotoPicker = true
            }
            .sheet(isPresented: $viewModel.showPhotoPicker) {
                PhotoPicker(pickerResult: $viewModel.pickerResult,
                            selectedImage: $viewModel.selectedImage,
                            selectedSwiftUIImage: $viewModel.selectedUIImage)
                .presentationDetents([.medium])
                .onDisappear {
                    askSeletedImage = viewModel.selectedUIImage
                    viewModel.selectedUIImage = Image(systemName: "photo")
                    isShowingAskImage = true
                    print("\(isShowingAskImage)")
                }
            }
    }
}

