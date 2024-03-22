//
//  SelectUserView.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import Kingfisher
import Lottie
import SwiftUI

struct SelectUserView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var padorideVM = PadoRideViewModel()
    
    @State private var fetchedData: Bool = false
    
    let user: User
    
    let columns = [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            HStack {
                CircularImageView(size: .medium,
                                  user: user)
                .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    if user.username.isEmpty {
                        Text(user.nameID)
                            .font(.system(.subheadline,
                                          weight: .semibold))
                    } else {
                        Text(user.nameID)
                            .font(.system(.subheadline, 
                                          weight: .semibold))
                        Text(user.username)
                            .font(.system(.footnote))
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding([.bottom, .horizontal], 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    if fetchedData {
                        if let padoridePosts = padorideVM.postsData[user.nameID], !padoridePosts.isEmpty {
                            LazyVGrid(columns: columns, spacing: 2) {
                                ForEach(padoridePosts, id: \.self) { post in
                                    ZStack(alignment: .bottomLeading) {
                                        Button {
                                            Task {
                                                padorideVM.selectedPost = post
                                                padorideVM.selectedImage = post.imageUrl
                                                try? await Task.sleep(nanoseconds: 1 * 250_000_000)
                                                padorideVM.downloadSelectedImage()
                                                padorideVM.isShowingEditView = true
                                            }
                                        } label: {
                                            if let imageUrl = URL(string: post.imageUrl) {
                                                KFImage.url(imageUrl)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                                    .clipped()
                                            }
                                        }
                                    }
                                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                }
                            }
                        } else {
                            Text("\(user.nameID)님은\n아직 받은 파도가 없어요")
                                .font(.system(.body, 
                                              weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .padding(.top, 60)
                        }
                    } else {
                        LottieView(animation: .named("Loading"))
                            .looping()
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 60)
                    }
                }
            }
        }
        .padding(.top)
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("파도타기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $padorideVM.isShowingEditView) {
            PadoRideEditView(padorideVM: padorideVM)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(.body))
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .task {
            await padorideVM.loadPostsData(for: user.nameID)
            fetchedData = true
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
}
