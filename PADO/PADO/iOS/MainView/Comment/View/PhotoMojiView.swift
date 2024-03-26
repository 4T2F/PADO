//
//  PhotoMoji.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import Lottie
import SwiftUI

struct PhotoMojiView: View {
    @StateObject var surfingVM = SurfingViewModel()
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State private var isShowingLoginPage: Bool = false
    
    @Binding var postOwner: User
    @Binding var post: Post
    
    let postID: String
    let updatePhotoMojiData = UpdatePhotoMojiData()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(commentVM.photoMojies, id: \.self) { photoMoji in
                    PhotoMojiCell(commentVM: commentVM, photoMoji: photoMoji)
                        .padding(6)
                        .sheet(isPresented: $commentVM.deletePhotoMojiModal) {
                            DeletePhotoMojiView(commentVM: commentVM, 
                                                photoMoji: commentVM.selectedPhotoMoji ?? photoMoji,
                                                postID: postID)
                            .presentationDetents([.medium])
                        }
                }
                Button {
                    if !userNameID.isEmpty {
                        surfingVM.isShowingPhotoMojiModal = true
                    } else {
                        isShowingLoginPage = true
                    }
                } label: {
                    VStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 1.5)
                            .foregroundStyle(Color.clear)
                            .frame(width: 50)
                            .overlay {
                                LottieView(animation: .named("photomoji"))
                                    .resizable()
                                    .looping()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.top, 4)
                        Text("")
                    }
                    .padding(.horizontal, 6)
                    .onAppear {
                        Task {
                            commentVM.photoMojies = try await updatePhotoMojiData.getPhotoMoji(documentID: postID) ?? []
                        }
                        surfingVM.photoMojiItem = nil
                    }
                    .sheet(isPresented: $surfingVM.isShowingPhotoMojiModal) {
                        PhotoMojiModalView(surfingVM: surfingVM)
                            .presentationDetents([.fraction(0.3)])
                            .presentationDragIndicator(.visible)
                        
                    }
                    .sheet(isPresented: $surfingVM.isShownCamera) {
                        CameraAccessView(isShown: $surfingVM.isShownCamera,
                                         myimage: $surfingVM.photoMojiImage,
                                         myUIImage: $surfingVM.photoMojiUIImage,
                                         mysourceType: $surfingVM.sourceType,
                                         mycameraDevice: $surfingVM.cameraDevice)
                    }
                    .sheet(isPresented: $isShowingLoginPage, content: {
                        StartView(isShowStartView: $isShowingLoginPage)
                            .presentationDragIndicator(.visible)
                    })
                    .onChange(of: surfingVM.photoMojiUIImage) { _, _ in
                        surfingVM.isShowingPhotoMojiModal = false
                        commentVM.photoMojiUIImage = surfingVM.photoMojiUIImage
                        commentVM.showCropPhotoMoji = true
                    }
                    .navigationDestination(isPresented: $commentVM.showCropPhotoMoji) {
                        PhotoMojiCropView(commentVM: commentVM,
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
