//
//  ImageLoadingCell.swift
//  PADO
//
//  Created by 강치우 on 3/17/24.
//

import Kingfisher

import SwiftUI

struct ImageLoadingCell: View {
    @Binding var isLoading: Bool
    @Binding var isHeaderVisible: Bool
    
    var imageUrl: String
    
    var body: some View {
        ZStack {
            if let url = URL(string: imageUrl) {
                KFImage.url(url)
                    .resizable()
                    .onSuccess { _ in isLoading = false }
                    .onFailure { _ in isLoading = false }
                    .onProgress { _, _ in isLoading = true }
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .containerRelativeFrame([.horizontal,.vertical])
                    .overlay {
                        GradientOverlay(isHeaderVisible: $isHeaderVisible)
                    }
                
                if isLoading { // feedVM에서 로딩 상태를 관리한다고 가정
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}
