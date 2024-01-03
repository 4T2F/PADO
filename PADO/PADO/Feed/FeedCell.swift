//
//  FeedCell.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct FeedCell: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // Username
                HStack {
                    Image("pp")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                    
                    VStack(alignment: .leading) {
                        Text("천랑성")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                        
                        Text("어제 오후 11:44:23") // • option + num8
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal)
                // Image
                
                ZStack {
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                Image(systemName: "bubble.left.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                                
                                Image(systemName: "face.smiling.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                                    .padding(.top, 15)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 50)
                        }
                    }
                    .zIndex(1)
                    
                    VStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                        
                        HStack {
                            Text("댓글 달기...")
                                .foregroundStyle(.gray)
                                .fontWeight(.semibold)
                            .padding(.leading, 4)
                            
                            Spacer()
                        }
                    }
                    VStack {
                        HStack {
                            Rectangle()
                                .foregroundStyle(.black)
                                .frame(width: 125, height: 165)
                                .overlay {
                                    Image("front")
                                        .resizable()
                                        .frame(width: 120, height: 160)
                                }
                                .padding(.leading)
                            
                            Spacer()
                        }
                        .padding(.top, 18)
                        
                        Spacer()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 600)
        }
    }
}

#Preview {
    FeedCell()
}
