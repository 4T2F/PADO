//
//  DeleteFaceMojiVIew.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import Kingfisher
import SwiftUI

struct DeleteFaceMojiView: View {
    // MARK: - PROPERTY
    let facemoji: Facemoji
    
    @ObservedObject var feedVM: FeedViewModel
    
    // MARK: - BODY
    var body: some View {
        VStack {
            VStack {
                KFImage(URL(string: facemoji.faceMojiImageUrl))
                    .fade(duration: 0.5)
                    .placeholder{
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                Text("해당 페이스모지를 삭제 하시겠습니까?")
                    .font(.system(size: 16))
                    .padding()
                
                Button {
                    feedVM.deleteFacemojiModal = false
                    Task {
                        await feedVM.deleteFaceModji(storagefileName: facemoji.storagename)
                        try await feedVM.getFaceMoji()
                    }
                } label: {
                    Text("삭제")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.red)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
                
                Button {
                    feedVM.deleteFacemojiModal = false
                } label: {
                    Text("취소")
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.grayButton)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
            }
        }
        .padding()
    }
}
