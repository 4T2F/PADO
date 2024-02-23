//
//  FaceMoji.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import Lottie
import SwiftUI

struct FaceMojiView: View {
    @ObservedObject var commentVM: CommentViewModel
    @StateObject var surfingVM = SurfingViewModel()
    
    @Binding var postOwner: User
    @Binding var post: Post
    
    @State private var isShowingLoginPage: Bool = false
    let postID: String
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(commentVM.facemojies, id: \.self) { facemoji in
                        FaceMojiCell(facemoji: facemoji, commentVM: commentVM)
                            .padding(6)
                            .sheet(isPresented: $commentVM.deleteFacemojiModal) {
                                DeleteFaceMojiView(facemoji: commentVM.selectedFacemoji ?? facemoji,
                                                   postID: postID,
                                                   commentVM: commentVM)
                                .presentationDetents([.medium])
                            }
                    }
                    Button {
                        if !userNameID.isEmpty {
                            surfingVM.isShowingFaceMojiModal = true
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
                                commentVM.facemojies = try await commentVM.updateFacemojiData.getFaceMoji(documentID: postID) ?? []
                            }
                        }
                        .sheet(isPresented: $surfingVM.isShowingFaceMojiModal) {
                            FaceMojiModalView(surfingVM: surfingVM)
                                .presentationDetents([.fraction(0.3)])
                                .presentationDragIndicator(.visible)
                            
                        }
                        .sheet(isPresented: $surfingVM.isShownCamera) {
                            CameraAccessView(isShown: $surfingVM.isShownCamera,
                                             myimage: $surfingVM.faceMojiImage,
                                             myUIImage: $surfingVM.faceMojiUIImage,
                                             mysourceType: $surfingVM.sourceType,
                                             mycameraDevice: $surfingVM.cameraDevice)
                        }
                        .sheet(isPresented: $isShowingLoginPage, content: {
                            StartView(isShowStartView: $isShowingLoginPage)
                                .presentationDragIndicator(.visible)
                        })
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
}
