//
//  Feed.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct FeedView: View {
    
    @Binding var mainMenu: String
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack {
                            ZStack {
                                VStack(alignment: .leading) {
                                    Image("back")
                                        .resizable()
                                        .scaledToFit()
                                }
                                
                                VStack {
                                    HStack {
                                        Image("front")
                                            .resizable()
                                            .border(.black)
                                            .frame(width: 20, height: 40)
                                            .padding(.leading)
                                        
                                        Spacer()
                                    }
                                    .padding(.top, 18)
                                    
                                    Spacer()
                                    
                                }
                            }
                            .frame(width: 100)
                        }
                        VStack {
                            Text("캡션 추가하기...")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            Text("View Comment")
                                .foregroundStyle(.gray)
                            
                            HStack {
                                Text("Enschede, Enschede-North • 1 hr late")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                ThreeDots(size: 3, color: .gray)
                            }
                        }
                        
                        ForEach(1..<8) { _ in
                            FeedCell()
                        }
                    }
                    .padding(.top, 80)
                }
                
                VStack {
                    VStack {
                        HStack {
                            Button {
                                withAnimation {
                                    self.mainMenu = "left"
                                }
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Text("PADO.")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 22))
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    self.mainMenu = "profile"
                                }
                            } label: {
                                Circle()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(17.5)
                                    .foregroundStyle(Color(red: 152/255, green: 163/255, blue: 16/255))
                                    .overlay {
                                        Text(viewModel.currentUser!.name.prefix(1).uppercased())
                                            .foregroundStyle(.white)
                                            .font(.system(size: 15))
                                    }
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("내 친구들")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            Text("파도타기")
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

//#Preview {
//    FeedView(mainMenu: .constant("feed"))
//}
