//
//  FreindsView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct FriendsView: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 65)
                        .foregroundStyle(Color(red: 40/255, green: 40/255, blue: 35/255))
                        .overlay {
                            HStack {
                                Image("pp")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                                
                                VStack(alignment: .leading) {
                                    Text("PADO 초대")
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("pa.do/kangciu")
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("내 친구들 (10)")
                                .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                                .padding(.leading, 14)
                            
                            Spacer()
                        }
                        
                        ForEach(1..<10) { _ in
                            FriendCellView()
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding(.top, 110)
        }
    }
}

#Preview {
    FriendsView()
}
