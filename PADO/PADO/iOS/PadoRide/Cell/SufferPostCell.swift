//
//  SufferPostCell.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct SufferPostCell: View {
    @ObservedObject var padorideVM: PadoRideViewModel
    var surfingID: String
    @State var sufferPost: [Post]?
    
    var body: some View {
        HStack {
            if let posts = sufferPost {
                ForEach(posts, id: \.self) { post in
                    Button {
                        padorideVM.selectedImage = post.imageUrl
                    } label: {
                        ZStack {
                            // Kingfisher를 사용하여 이미지 로딩
                            KFImage(URL(string: post.imageUrl))
                                .onSuccess { _ in
                                    // 이미지 로딩 성공 시 처리
                                }
                                .onFailure { _ in
                                    // 이미지 로딩 실패 시 처리
                                }
                                .placeholder {
                                    // 이미지 로딩 중 ProgressView 표시
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 150)
                            
                            // 선택된 이미지일 경우 체크마크 표시
                            if padorideVM.selectedImage == post.imageUrl {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .background(Circle().fill(Color.white))
                                    .frame(width: 30, height: 30)
                                    .offset(x: 35, y: -60)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                sufferPost = await padorideVM.getPostData.suffingPostData(id: surfingID)
            }
        }
    }
}
