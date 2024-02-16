//
//  PadoRideView.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import SwiftUI

struct PadoRideView: View {
    // MARK: - PROPERTY
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var padorideVM: PadoRideViewModel
    @ObservedObject var postitVM: PostitViewModel
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("파도타기")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.leading, 40)
                        
                        Spacer()
                        
                        if padorideVM.selectedImage.isEmpty {
                            Button {
                            } label: {
                                Text("다음")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.trailing, 10)
                            }
                        } else {
                            Button {
                                padorideVM.downloadSelectedImage()
                                padorideVM.isShowingEditView = true
                            } label: {
                                Text("다음")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !padorideVM.postsData.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack {
                                ForEach(followVM.surfingIDs, id: \.self) { surfingID in
                                    SufferInfoCell(surfingID: surfingID)
                                    
                                    if padorideVM.postsData[surfingID] != [] {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                SufferPostCell(padorideVM: padorideVM,
                                                               suffingPost: padorideVM.postsData[surfingID],
                                                               surfingID: surfingID)
                                            }
                                        }
                                    } else {
                                        HStack {
                                            NoItemView(itemName: "해당 유저는 아직 꾸밀 파도가 없어요")
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        if followVM.followingIDs.isEmpty {
                            Spacer()
                            
                            Text("내가 팔로잉한 사람이 없어요")
                                .font(.system(size: 16, weight: .bold))
                            
                            FeedGuideView(feedVM: feedVM)
                            
                            Spacer()
                        } else if followVM.surfingIDs.isEmpty {
                            Spacer()
                            
                            SurfingGuideView(postitVM: postitVM)
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $padorideVM.isShowingEditView) {
                PadoRideEditView(padorideVM: padorideVM)
            }
        }
        .onAppear {
            Task {
                await padorideVM.preloadPostsData(for: followVM.surfingIDs)
            }
        }
    }
}
