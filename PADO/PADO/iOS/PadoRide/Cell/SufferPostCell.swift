//
//  SufferPostCell.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct SufferPostCell: View {
    // MARK: - PROPERTY
    @ObservedObject var padorideVM: PadoRideViewModel
    
    var suffingPost: [Post]?
    var surfingID: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            if let posts = suffingPost {
                ForEach(posts, id: \.self) { post in
                    Button {
                        padorideVM.selectedImage = post.imageUrl
                        padorideVM.selectedPost = post
                    } label: {
                        ZStack {
                            KFImage(URL(string: post.imageUrl))
                                .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 150), mode: .aspectFill))
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 150)
                                .cornerRadius(12)
                            
                            // 선택된 이미지일 경우 체크마크 표시
                            if padorideVM.selectedImage == post.imageUrl {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .background(Circle().fill(Color.white))
                                    .frame(width: 30, height: 30)
                                    .offset(x: 35, y: -60)
                            }
                        }
                    }
                }
            } else {
                ProgressView()
                    .padding(.leading, UIScreen.main.bounds.width * 0.45)
            }
        }
    }
}
