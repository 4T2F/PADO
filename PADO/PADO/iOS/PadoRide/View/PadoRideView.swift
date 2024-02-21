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
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                Color.main.ignoresSafeArea()
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
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.trailing, 18)
                            }
                        } else {
                            Button {
                                padorideVM.downloadSelectedImage()
                                padorideVM.isShowingEditView = true
                            } label: {
                                Text("다음")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.trailing, 18)
                            }
                        }
                    }
                    
                    Spacer()
                    
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
                    
                    //                        if followVM.followingIDs.isEmpty {
                    //                            Spacer()
                    //
                    //                            FeedGuideView(feedVM: feedVM,
                    //                                          title: "먼저 계정을 팔로우해주세요",
                    //                                          content: "서퍼로 등록이 되어야 파도를\n보낼 수 있어요")
                    //
                    //                            Spacer()
                    //                        } else if followVM.surfingIDs.isEmpty {
                    //                            Spacer()
                    //
                    //                            SurfingGuideView()
                    //
                    //                            Spacer()
                    //                        }
                    
                }
            }
            .navigationDestination(isPresented: $padorideVM.isShowingEditView) {
                PadoRideEditView(padorideVM: padorideVM)
            }
        }
        //        .onAppear {
        //            Task {
        //                await padorideVM.preloadPostsData(for: followVM.surfingIDs)
        //            }
        //        }
    }
}
