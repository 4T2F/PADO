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
    
    @State var sufferPost: [Post]?
    @State private var isLoading = true
    
    var surfingID: String
    
    var body: some View {
        HStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
                    .padding(.leading, UIScreen.main.bounds.width * 0.45)
            } else {
                if let posts = sufferPost {
                    ForEach(posts, id: \.self) { post in
                        Button {
                            padorideVM.selectedImage = post.imageUrl
                        } label: {
                            ZStack {
                                KFImage(URL(string: post.imageUrl))
                                    .fade(duration: 0.5)
                                    .placeholder {
                                        Image("defaultProfile")
                                            .resizable()
                                            .scaledToFill()
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
        }
        .onAppear {
            // 데이터 로딩 시작
            isLoading = true
            Task {
                sufferPost = await padorideVM.getPostData.suffingPostData(id: surfingID)
                isLoading = false
            }
        }
    }
}
