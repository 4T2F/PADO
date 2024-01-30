////
////  ReMyFeedView.swift
////  PADO
////
////  Created by 강치우 on 1/22/24.
////
//
//import SwiftUI
//
//struct MyFeedView: View {
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//    @State private var isShowingSetting = false
//    @StateObject var followVM: FollowViewModel
//    
//    var body: some View {
//       
//        if isShowingSetting {
//            SettingView(isShowingSetting: $isShowingSetting)
//        } else {
//            ZStack {
//                Color.modalBlackButton.ignoresSafeArea()
//                VStack {
//                    VStack {
//                        HStack {
//                            Text("PADO")
//                                .foregroundStyle(.white)
//                                .fontWeight(.bold)
//                                .font(.system(size: 22))
//                            
//                            Spacer()
//                            
//                            Button {
//                                isShowingSetting.toggle()
//                            } label: {
//                                VStack {
//                                    Text("...")
//                                        .font(.system(size: 34))
//                                        .foregroundStyle(.white)
//                                    
//                                    Text("")
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    
//                    ScrollView(showsIndicators: false) {
//                        VStack(spacing: 16) {
//                            ProfileCell(followVM: followVM)
//                            
//                            MyFeedContentView()
//                        }
//                    }
//                    
//                }
//            }
//        }
//    }
//}
//
//
