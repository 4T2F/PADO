//
//  FaceMoji.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct FaceMojiView: View {
    @ObservedObject var commentVM: CommentViewModel
    @StateObject var surfingVM = SurfingViewModel()
    
    @Binding var postOwner: User
    @Binding var post: Post
    
    let postID: String
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(commentVM.facemojies, id: \.self) { facemoji in
                        FaceMojiCell(facemoji: facemoji, commentVM: commentVM)
                            .padding(.horizontal, 6)
                            .sheet(isPresented: $commentVM.deleteFacemojiModal) {
                                DeleteFaceMojiView(facemoji: commentVM.selectedFacemoji ?? facemoji,
                                                   postID: postID,
                                                   commentVM: commentVM)
                                    .presentationDetents([.medium])
                            }
                    }
                    Button {
                        surfingVM.isShowingFaceMojiModal = true
                    } label: {
                        VStack {
                            Image("face.dashed")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .padding(.vertical, 16)
                            
                            Text("")
                            
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        Task {
                            commentVM.facemojies = try await commentVM.updateFacemojiData.getFaceMoji(documentID: postID) ?? []
                        }
                    }
                    .sheet(isPresented: $surfingVM.isShowingFaceMojiModal) {
                        FaceMojiModalView(surfingVM: surfingVM)
                            .presentationDetents([.fraction(0.3)])
                        
                    }
                    .sheet(isPresented: $surfingVM.isShownCamera) {
                        CameraAccessView(isShown: $surfingVM.isShownCamera,
                                         myimage: $surfingVM.faceMojiImage,
                                         myUIImage: $surfingVM.faceMojiUIImage,
                                         mysourceType: $surfingVM.sourceType,
                                         mycameraDevice: $surfingVM.cameraDevice)
                    }
                    .onChange(of: surfingVM.faceMojiUIImage) { _, _ in
                        surfingVM.isShowingFaceMojiModal = false
                        commentVM.faceMojiUIImage = surfingVM.faceMojiUIImage
                        commentVM.showCropFaceMoji = true
                    }
                    .navigationDestination(isPresented: $commentVM.showCropFaceMoji) {
                        FaceMojiCropView(commentVM: commentVM,
                                         postOwner: $postOwner,
                                         post: $post,
                                         postID: postID)
                        { croppedImage, status in
                            if let croppedImage {
                                commentVM.cropMojiUIImage = croppedImage
                            }
                        }
                    }
                }
            }
        }
    }
}
