//
//  PadoRideView1.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct PadoRideView1: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("파도타기가 가능한 팔로워")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button {
                                // 온보딩
                            } label: {
                                Text("파도타기란?")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                        
                        // 파도타기 할 수 있는 유저가 없으면 "파도타기를 할 수 있는 친구가 없어요" 텍스트 넣기
                        ForEach(1...8, id: \.self) { rideUser in
                            SelectPadoRideUserCell()
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("회원님을 위한 추천")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(Color(.systemGray))
                            .padding(.leading)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(1...5, id: \.self) { user in
                                    FollowerSuggestionCell()
                                        .padding(.trailing, 4)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .scrollIndicators(.hidden)
                    }
                    .padding(.top)
                }
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationTitle("파도타기")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    PadoRideView1()
}
