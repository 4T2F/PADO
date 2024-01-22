//
//  TodayHeaderCell.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct TodayCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                // 프로필 사진 들어가야함 근데 프로필 사진 없으면 기본 이미지 들어가게 해야함.
                Image("pp2")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .cornerRadius(35)
                    .overlay {
                        Image("pp1")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .cornerRadius(35)
                            .offset(x: -20)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("minyoung x dongho")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                    }
                    
                    Button {
                        // 누르면 팔로잉이라고 뜨게 하기
                    } label: {
                        Text("팔로우")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.leading, 20)
            .padding(.top, 10)
            
            VStack {
                HStack {
                    Text("숟가락에 눈가려지는 너란 남자..")
                        .font(.system(size: 14))
                }
                .padding(.leading)
                .padding(.top)
            }
            
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    TodayCell()
}
