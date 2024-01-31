//
//  FollowView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//
// ############################################
//                파기예정 파일
// ############################################
import SwiftUI

struct FollowView: View {
    // MARK: - PROPERTY
    @State var width = UIScreen.main.bounds.width
    @State var menu: String
    
    @ObservedObject var followVM: FollowViewModel
    
    // MARK: - BODY
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if menu == "follower" {
                    FollowerView(followVM: followVM)
                } else if menu == "following" {
                    FollowingView(followVM: followVM)
                }
                
                VStack {
                    Spacer()
                    ZStack {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 180, height: 44)
                                    .cornerRadius(25)
                                    .foregroundStyle(Color(.systemGray6))
                                
                                HStack(spacing: 4) {
                                    Rectangle()
                                        .frame(width: 71, height: 32)
                                        .foregroundStyle(Color("grayButtonColor"))
                                        .cornerRadius(25)
                                        .opacity(menu == "follower" ? 1: 0)
                                        .overlay {
                                            Text("팔로워")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .onTapGesture {
                                            self.menu = "follower"
                                        }
                                    
                                    Rectangle()
                                        .frame(width: 71, height: 32)
                                        .foregroundStyle(Color("grayButtonColor"))
                                        .cornerRadius(25)
                                        .opacity(menu == "following" ? 1: 0)
                                        .overlay {
                                            Text("팔로잉")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .onTapGesture {
                                            self.menu = "following"
                                        }
                                } //: HSTACK
                            } //: ZSTACK
                        } //: VSTACK
                        .zIndex(1)

                    } //: ZSTACK
                }
            }
        } //: VSTACK
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            let updateFollowData = UpdateFollowData()
//            Task {
//                await updateFollowData.followUser(id: "hanabi")
//                await updateFollowData.followUser(id: "pado")
//                await updateFollowData.followUser(id: "legendboy")
//                await updateFollowData.followUser(id: "king")
//                await updateFollowData.followUser(id: "goat")
//                await updateFollowData.followUser(id: "test")
//            }
//        }
    }
}
