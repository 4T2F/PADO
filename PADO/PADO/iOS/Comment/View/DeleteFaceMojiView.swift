//
//  DeletePhotoMojiVIew.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import Kingfisher
import SwiftUI

struct DeletePhotoMojiView: View {
    @ObservedObject var commentVM: CommentViewModel
    
    let photoMoji: PhotoMoji
    let postID: String
    let updatePhotoMojiData: UpdatePhotoMojiData
    
    var body: some View {
        VStack {
            VStack {
                KFImage(URL(string: photoMoji.faceMojiImageUrl))
                    .fade(duration: 0.5)
                    .placeholder{
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                Text("해당 포토모지를 삭제 하시겠습니까?")
                    .font(.system(.body))
                    .padding()
                
                Button {
                    commentVM.deletePhotoMojiModal = false
                    Task {
                        await updatePhotoMojiData.deletePhotoMoji(documentID: postID,
                                                                          storagefileName: photoMoji.storagename)
                        commentVM.photoMojies = await updatePhotoMojiData.getPhotoMoji(documentID: postID) ?? []
                    }
                } label: {
                    Text("삭제")
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.red)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
                
                Button {
                    commentVM.deletePhotoMojiModal = false
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
